import csv
import math
import sys
from datetime import datetime
import psycopg2
from itertools import *
import numpy as np
import scipy.stats as st
from matplotlib import pyplot as plt
from scipy.stats import lognorm
from scipy.stats import gaussian_kde
from pyqt_fit import kde, kde_methods
from sklearn.neighbors import KernelDensity

class SQLSource(object):

    """A class for iterating the result set of a single SQL query."""

    def __init__(self, connection, query, names=(), initsql=None,
                 cursorarg=None, parameters=None):
        """Arguments:
           - connection: the PEP 249 connection to use. NOT a
             ConnectionWrapper!
           - query: the query that generates the result
           - names: names of attributes in the result. If not set,
             the names from the database are used. Default: ()
           - initsql: SQL that is executed before the query. The result of this
             initsql is not returned. Default: None.
           - cursorarg: if not None, this argument is used as an argument when
             the connection's cursor method is called. Default: None.
           - parameters: if not None, this sequence or mapping of parameters
             will be sent when the query is executed.
        """
        self.connection = connection
        if cursorarg is not None:
            self.cursor = connection.cursor(cursorarg)
        else:
            self.cursor = connection.cursor()
        if initsql:
            self.cursor.execute(initsql)
        self.query = query
        self.names = names
        self.executed = False
        self.parameters = parameters

    def __iter__(self):
        try:
            if not self.executed:
                if self.parameters:
                    self.cursor.execute(self.query, self.parameters)
                else:
                    self.cursor.execute(self.query)
                names = None
                if self.names or self.cursor.description:
                    names = self.names or \
                        [t[0] for t in self.cursor.description]
            while True:
                data = self.cursor.fetchmany(500)
                if not data:
                    break
                if not names:
                    # We do this to support cursor objects that only have
                    # a meaningful .description after data has been fetched.
                    # This is, for example, the case when using a named
                    # psycopg2 cursor.
                    names = [t[0] for t in self.cursor.description]
                if len(names) != len(data[0]):
                    raise ValueError(
                        "Incorrect number of names provided. " +
                        "%d given, %d needed." % (len(names), len(data[0])))
                for row in data:
                    yield dict(zip(names, row))
        finally:
            try:
                self.cursor.close()
            except Exception:
                pass




def observe_time(date, hour):
    return datetime.strptime(('01/01/9999' if date == '' else date) + ' ' + hour, '%m/%d/%Y %H:%M').strftime(
        '%Y-%m-%d %X')


def encode(l):
    return [(len(list(group)), name) for name, group in groupby(l)]


def write_csv():
    count = 0
    header = []
    times = []
    try:
        with open('/home/xiuli/Dropbox/XF_DH_analysis/data_Time.csv', 'r') as f:
            of = open('/tmp/activities.csv', 'w')
            af = open('/tmp/families.csv', 'w')
            csv_writer = csv.DictWriter(of,
                                        fieldnames=['fid', 'obs_no', 'ts_no', 'obs_time', 'interview_date', 'activity'],
                                        delimiter='|')
            families_writer = csv.DictWriter(af,
                                             fieldnames=['fid', 'obs_no', 'familytype', 'vs1_hvornaar', 'vs1_antaldage',
                                                         'vs4_stress', 'vs5_normal', 'vs6_arbejde', 'vs6_normal',
                                                         'vs7_uddannelse', 'vs7_normal', 'vs1_hvornaar2',
                                                         'vs1_antaldage2', 'vt_foraelder', 'vt2_skole'], delimiter='|')
            csv_reader = csv.reader(f, delimiter='|')
            csv_writer.writeheader()
            families_writer.writeheader()
            for row in csv_reader:
                if count == 0:
                    header.extend(row)
                    # print header
                elif count == 1:
                    times.extend(row)
                    # print times
                else:
                    families_writer.writerow(
                        {'fid': row[0], 'obs_no': row[1], 'familytype': row[150], 'vs1_hvornaar': row[155],
                         'vs1_antaldage': row[156],
                         'vs4_stress': row[157], 'vs5_normal': row[158], 'vs6_arbejde': row[159],
                         'vs6_normal': row[160],
                         'vs7_uddannelse': row[161], 'vs7_normal': row[162], 'vs1_hvornaar2': row[163],
                         'vs1_antaldage2': row[164],
                         'vt_foraelder': row[165], 'vt2_skole': row[166]})
                    for i in range(2, 146):
                        csv_writer.writerow({'fid': row[0], 'obs_no': row[1], 'ts_no': i - 2,
                                             'obs_time': observe_time(row[146], times[i]),
                                             'interview_date': datetime.strptime(
                                                 '01/01/9999' if row[151] == '' else row[151], '%m/%d/%Y').strftime(
                                                 '%Y-%m-%d'),
                                             'activity': row[i]})
                count += 1
    except Exception as e:
        print times
        print e


hours = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3]


def claircity_start_activities():
    conn = None
    try:
        conn = psycopg2.connect(host="193.200.45.38", database="testdb", user="xiuli", password="Abcd1234")
        cursor = conn.cursor()
        cursor.execute(
            'select fid, obs_id, array_agg(activity order by time) from cc_activity_all group by  fid, obs_id  order by fid, obs_id')
        row = cursor.fetchone()
        while row is not None:
            row = cursor.fetchone()
            if row:
                activities = row[2]
                if not None in activities:
                    prev = -1
                    for i in range(24):
                        hour = hours[i]
                        activities_in_hour = activities[i * 6:(i + 1) * 6]
                        for j in range(6):
                            cur = activities_in_hour[j]
                            if cur is None:
                                pass  # print row
                            if cur != prev and prev != -1:
                                idx = i * 6 + j
                                count = 0
                                while idx < len(activities) and cur == activities[idx]:
                                    count += 1
                                    idx += 1
                                s = '%s|%s|%s' % (hour, cur, count * 10.0)
                                print s
                            prev = cur
        cursor.close()
    except Exception as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()


SQL = '''select
            fid, 
            obs_id, 
            array_agg(activity order by ts_no) as activities
        from cc_activity_merge
        group by 1,2 
        order by 1,2'''


def run_length_encode():
    conn = None
    try:
        conn = psycopg2.connect(host="193.200.45.38", database="testdb", user="xiuli", password="Abcd1234")
        cursor = conn.cursor()
        cursor.execute(SQL)
        row = cursor.fetchone()

        while row is not None:
            if row:
                activities = row[2]
                for i in range(10):
                    for j in range(144):
                        start = j
                        sub = activities[start:]
                        cnt = 0
                        for c in sub:
                            if i+1 == int(c):
                                cnt += 1
                            else:
                                break
                        print '%d|%d|%d'%(i+1, j, cnt)
            row = cursor.fetchone()
        cursor.close()
    except Exception as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()



def find_best_fit(data=[]):
    distributions = [st.laplace, st.norm, st.lognorm, st.expon, st.weibull_min, st.uniform]
    mles = []

    for distribution in distributions:
        pars = distribution.fit(data)
        mle = distribution.nnlf(pars, data)
        mles.append(mle)
    results = [(distribution.name, mle) for distribution, mle in zip(distributions, mles)]
    best_fit = sorted(zip(distributions, mles), key=lambda d: d[1])[0]
    print 'Best fit reached using {}, MLE value: {}'.format(best_fit[0].name, best_fit[1])


def histogram():
    conn = None
    try:

        cursor = conn.cursor()
        cursor.execute("SELECT length FROM cc_activity_length_1 WHERE ts_no=76 AND activity=1")
        row = cursor.fetchone()
        fig, ax = plt.subplots(1, 1)
        while row is not None:
            data = filter(lambda a: a != 0, row[0])
            #data = [a / 144.0 for a in data]

            #find_best_fit(data)
            #print data
            xs = np.linspace(min(data), max(data), 100)  # fixed number of bins
            ax.set_xlim([min(data) - 0.001, max(data) + 0.001])
            #ax.hist(data, bins=xs, edgecolor='black', linewidth=0.5)
            ax.hist(data, bins=100, normed=1, edgecolor='black', linewidth=0.5)
            kde = gaussian_kde(data) #

            kdepdf = kde.evaluate(xs)
            ax.plot(xs, kdepdf)

            ax.set(title='Activity', xlabel='Data', ylabel='Count')
            plt.show()
            row = cursor.fetchone()
        cursor.close()
    except Exception as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()



def markov_transit_into_matrix(con=None):
    SQL = 'SELECT id, array_agg(prob ORDER BY i ASC, j ASC) as props FROM cc_makov_transition_matrix GROUP BY 1 ORDER BY 1 asc'
    matrix = []
    for row in SQLSource(con, SQL):
        mat = np.array([float(x) for x in row['props']]).reshape(10, 10)
        matrix.append(mat)
    return matrix


def activity_data_matrix(con=None, size=1):
    SQL = 'SELECT ts_no, array_agg(length ORDER BY activity ASC) as duration_freqs FROM cc_activity_length_1 GROUP BY 1 ORDER BY 1 ASC'
    matrix = []
    for row in SQLSource(con, SQL):
        duration_freqs = row['duration_freqs']
        activity_durations = []
        for X in duration_freqs:
            X = filter(lambda a: a != 0, X)
            kde = KernelDensity(kernel='gaussian', bandwidth=0.75).fit(np.array(X).reshape(-1, 1))
            #pyqt_kde = kde.KDE1D(duration_freq, lower=0, upper=143 - ts_no, method=kde_methods.renormalization)
            #np.random.seed(0)
            #cdfs = np.random.uniform(0, 1, 10) #https://plot.ly/scikit-learn/plot-kde-1d/
            durations = kde.sample(size).reshape(1,-1)[0].tolist()
            activity_durations.append(durations)
        matrix.append(activity_durations)
    return matrix


def sequence_generate(con=None, size=1):
    transition_matrixes = markov_transit_into_matrix(con)
    activity_matrixes = activity_data_matrix(con, size)
    f_act = open('/tmp/activity_sequence.csv', 'w')
    f_con = open('/tmp/consumption_sequence.csv', 'w')
    for n in range(size):
        seq = []
        seq.append(1)
        while len(seq)<144:
            ts_no = len(seq) - 1
            cur_activity = seq[-1]
            np.random.seed(ts_no)
            props = transition_matrixes[ts_no][cur_activity-1].tolist()
            if (len(seq)>1):
                delta = props[cur_activity-1]/9.0
                props = [x+delta for x in props]
                props[cur_activity - 1] = 0.0 # means that not choose itself again

            next_activity = np.random.choice(range(len(props)), size, p=props)[n]+1
            seq.append(next_activity)

            ts_no = len(seq) - 1
            duration = activity_matrixes[ts_no][next_activity-1].pop()
            if duration>=1.0:
                for d in range(int(duration)):
                    if (len(seq)<144):
                        seq.append(next_activity)

        act_seq, con_seq = covert_hourly_power_consumption(seq)
        f_act.write('%d|%s\n' % (n, act_seq))
        f_con.write('%d|%s\n' % (n, con_seq))
    f_act.close()
    f_con.close()


activity_kWh = {1:0.0, 2:0.0, 3:0.0, 4:1.225, 5:1.543, 6:0, 7:0, 8:0.2, 9:0, 10:0}
def covert_hourly_power_consumption(seq=[]):
    consumptions = [x* activity_kWh[x]/6.0 for x in seq]
    hourlyConsumptions = np.sum(np.array(consumptions).reshape(24, 6), axis=1).tolist()
    return [','.join(str(x) for x in seq),  ','.join(str(x) for x in hourlyConsumptions)]




def count_activities():
    h2a = {}
    with open('/tmp/activity_sequence.csv') as f:
        for line in f.readlines():
            activities = line.rstrip('\n').split('|')[1].split(',')
            for h in range(24):
                startIdx, endIdx = h*6, h*6+6
                timeIdx = (h+4) % 24
                data = h2a.get(timeIdx, [])
                data.extend(activities[startIdx:endIdx])
                h2a[timeIdx] = data

    for h in h2a:
        data = h2a[h]
        #print h, [data.count(str(i)) for i in range(1,11)]
        s = '|'.join(map(str,[data.count(str(i)) for i in range(1,11)]))
        print str(h)+'|'+s





def count_activities_2():
    h2a = {}
    with open('/tmp/activity_sequence.csv') as f:
        for line in f.readlines():
            activities = map(str, [x-1 for x in map(int, line.split('|')[1].rstrip('\n').split(','))])
            activities_counts = run_length_encode(''.join(activities))
            for a, c in activities_counts:
                print '{}|{}'.format(int(a)+1, c)


def run_length_encode(l):
    return [(name, len(list(group))) for name, group in groupby(l)]






if __name__ == '__main__':
    conn = None
    try:
        #con = psycopg2.connect(host="193.200.45.38", database="testdb", user="xiuli", password="Abcd1234")
        #markov_transit_probality(con, size=1)
        #markov_transit_into_matrix(con)
        #sequence_generate(con, size=int(sys.argv[1]))
        count_activities_2()
    except Exception as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
