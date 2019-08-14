import numpy as np
import matplotlib.pyplot as plt
from pandas.compat import range, lrange, lmap, zip
from pandas import Series
from pandas.plotting import autocorrelation_plot

import json

plt.figure(figsize=(15,5))

def auto_corr(mydata):
    n = len(mydata)
    lags = n
    data = np.asarray(mydata)
    ax = plt.gca(xlim=(1, lags), ylim=(-1.0, 1.0))
    mean = np.mean(data)
    c0 = np.sum((data - mean) ** 2) / float(n)


    def r(h):
        return ((data[:n - h] - mean) *
                (data[h:] - mean)).sum() / float(n) / c0

    x = np.arange(lags) + 1
    y = lmap(r, x)
    z95 = 1.959963984540054
    z99 = 2.5758293035489004
    ax.axhline(y=z99 / np.sqrt(n), linestyle='--', color='grey')
    ax.axhline(y=z95 / np.sqrt(n), color='grey')
    ax.axhline(y=0.0, color='black')
    ax.axhline(y=-z95 / np.sqrt(n), color='grey')
    ax.axhline(y=-z99 / np.sqrt(n), linestyle='--', color='grey')
    ax.set_xlabel("Lag")
    ax.set_ylabel("Autocorrelation")
    ax.plot(x, y)
    ax.grid()
    plt.show()

if __name__ == '__main__':
    f = open('/tmp/real.csv', 'r')
    #f = open('/tmp/syn.csv', 'r')
    for line in f.readlines():
        line = line.rstrip('}\n').lstrip('{')
        values = [float(d) for d in line.split(',')]
        autocorrelation_plot(values[:130])
    plt.show()