
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