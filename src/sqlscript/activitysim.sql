-- http://sqlformat.darold.net/
﻿
create table tmp_test as
       select hour||'-'||activity as hc,
              time
       from cc_start_activities_all;

select madlib.summary('tmp_test', 'output_table', 'time', 'hc');


create table cc_transition as
        select fid, obs_id,
        ts_no as ts_no1,
        lead(ts_no) over (partition by fid, obs_id order by ts_no) as ts_no2,
        activity as activity1,
        lead(activity) over (partition by fid, obs_id order by ts_no) as activity2
from cc_activity_merge;

create table cc_transition_count as
select
    ts_no1 as id,
    activity1,
    activity2,
    count
from (select
        ts_no1,
        ts_no2,
        activity1,
        activity2,
        count(*) as count
      from cc_transition
      group by 1,2,3,4
      order by 1,2,3,4) A
where activity1 is not null and
      activity2 is not null;


create table cc_makov_transition_matrix as
    select c.id,
    e.i,
    e.j,
    0 as count
    from generate_series(0, 143) c(id),
        (select a.i,  b.j from generate_series(1, 10) a(i), generate_series(1, 10) b(j)) e
    order by 1,2,3;


update cc_makov_transition_matrix
set count=B.count
from  cc_transition_count B
where cc_makov_transition_matrix.id=B.id and
        i=B.activity1 and
        j=B.activity2;

create table cc_makov_transition_matrix_1 as
       select A.id,
              A.i,
              A.j,
              A.count,
              (A.count)*1.0/total as prob
              from cc_makov_transition_matrix A,
              (select
                    id,
                    i,
                    sum(count) as total
                from cc_makov_transition_matrix
                group by 1, 2 having sum(count)>0) B
       where A.id=B.id and A.i=B.i
       order by 1,2,3;

drop table cc_makov_transition_matrix;

alter table cc_makov_transition_matrix_1 rename to cc_makov_transition_matrix;


select fid,
        obs_id,
        array_agg(B.abbr order by ts_no1 asc)
from cc_transition, cc_activity_types B
where activity2=B.id and activity2 is not null
group by 1,2
order by 1,2


select  fid,
        obs_id,
        array_agg(b.abbr order by ts_no) as activities
from cc_activity_merge, cc_activity_types b
where activity=b.id
group by 1,2
order by 1,2


-------
DROP TABLE cc_ids;

CREATE TABLE cc_ids AS
SELECT
    row_number() OVER () AS id,
    C.*
FROM (
    SELECT
        B.*
    FROM (
        SELECT
            A.*
        FROM ( SELECT DISTINCT
                fid,
                obs_id
            FROM
                cc_activity_all) A
        ORDER BY
            random()) B) C;

DROP TABLE cc_activity_real;

CREATE TABLE cc_activity_real AS
SELECT
    A.fid,
    A.obs_id,
    A.ts_no,
    A.state
FROM
    cc_activity_all A,
    cc_ids B
WHERE
    A.fid = B.fid
    AND A.obs_id = B.obs_id
    AND B.id < 12084;

DROP TABLE cc_activity_syn;

CREATE TABLE cc_activity_syn AS
SELECT
    A.fid,
    A.obs_id,
    A.ts_no,
    A.state
FROM
    cc_activity_all A,
    cc_ids B
WHERE
    A.fid = B.fid
    AND A.obs_id = B.obs_id
    AND B.id > 12083;

DROP TABLE cc_rmse_real;

CREATE TABLE cc_rmse_real AS
SELECT
    ts_no,
    count(*) FILTER (WHERE state = 1) AS cn1,
    count(*) FILTER (WHERE state = 2) AS cn2,
    count(*) FILTER (WHERE state = 3) AS cn3,
    count(*) FILTER (WHERE state = 4) AS cn4,
    count(*) FILTER (WHERE state = 5) AS cn5,
    count(*) FILTER (WHERE state = 6) AS cn6,
    count(*) FILTER (WHERE state = 7) AS cn7,
    count(*) FILTER (WHERE state = 8) AS cn8
FROM
    cc_activity_real
GROUP BY
    1
ORDER BY
    1;

DROP TABLE cc_rmse_syn;

CREATE TABLE cc_rmse_syn AS
SELECT
    ts_no,
    count(*) FILTER (WHERE state = 1) AS cn1,
    count(*) FILTER (WHERE state = 2) AS cn2,
    count(*) FILTER (WHERE state = 3) AS cn3,
    count(*) FILTER (WHERE state = 4) AS cn4,
    count(*) FILTER (WHERE state = 5) AS cn5,
    count(*) FILTER (WHERE state = 6) AS cn6,
    count(*) FILTER (WHERE state = 7) AS cn7,
    count(*) FILTER (WHERE state = 8) AS cn8
FROM
    cc_activity_syn
GROUP BY
    1
ORDER BY
    1;

SELECT
    sqrt(sum(C.t) / (8 * 144))
FROM (
    SELECT
        A.ts_no,
        power((A.cn1 - B.cn1), 2) + power((A.cn2 - B.cn2), 2) + power((A.cn3 - B.cn3), 2) + power((A.cn4 - B.cn4), 2) + power((A.cn5 - B.cn5), 2) + power((A.cn6 - B.cn6), 2) + power((A.cn7 - B.cn7), 2) + power((A.cn8 - B.cn8), 2) AS t
    FROM
        cc_rmse_syn A,
        cc_rmse_real B
    WHERE
        A.ts_no = B.ts_no
    ORDER BY
        1) C;

-- Export data for auto-correlation study

COPY
(
    SELECT
        readings
    FROM (
        SELECT
            fid,
            obs_id,
            array_agg(1.0 * state ORDER BY ts_no) AS readings
        FROM
            cc_activity_real
        WHERE
            state IS NOT NULL
        GROUP BY
            1,
            2) A
    WHERE
        array_length(A.readings, 1) = 144
        ORDER BY random()
    LIMIT 50) TO '/tmp/real.csv'

COPY
(
    SELECT
        readings
    FROM (
        SELECT
            fid,
            obs_id,
            array_agg(1.0 * state ORDER BY ts_no) AS readings
        FROM
            cc_activity_syn
        WHERE
            state IS NOT NULL
        GROUP BY
            1,
            2) A
    WHERE
        array_length(A.readings, 1) = 144
        ORDER BY random()
    LIMIT 50) TO '/tmp/syn.csv'
