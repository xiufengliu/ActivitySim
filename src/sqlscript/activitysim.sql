-- http://sqlformat.darold.net/
﻿
-- Table: public.cc_activity_real

-- DROP TABLE public.cc_activity_real;

CREATE TABLE public.cc_activity_real
(
  fid integer,
  obs_id integer,
  ts_no integer,
  state integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_activity_real
  OWNER TO xiuli;

CREATE TABLE public.cc_activity_types
(
  id integer NOT NULL,
  abbr character varying(1),
  name character varying(26),
  power_consumption double precision,
  CONSTRAINT cc_activity_types_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_activity_types
  OWNER TO xiuli;


CREATE TABLE public.cc_activity_subtypes
(
  id integer NOT NULL,
  name character varying(36),
  parent integer,
  CONSTRAINT cc_activity_subtypes_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_activity_subtypes
  OWNER TO xiuli;

CREATE TABLE public.cc_activity_syn
(
  fid integer,
  obs_id integer,
  ts_no integer,
  state integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_activity_syn
  OWNER TO xiuli;


CREATE TABLE public.cc_activity_transit_1
(
  fid integer,
  obs_id integer,
  ts_no integer,
  cur_state integer,
  next_state integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_activity_transit_1
  OWNER TO xiuli;

CREATE TABLE public.cc_makov_transition_matrix
(
  id integer,
  i integer,
  j integer,
  count integer,
  prob numeric
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_makov_transition_matrix
  OWNER TO xiuli;

CREATE TABLE public.cc_start_activities_all
(
  hour integer,
  activity integer,
  "time" numeric
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_start_activities_all
  OWNER TO xiuli;

CREATE TABLE public.cc_start_activities_summary
(
  hour integer,
  activity integer,
  row_count bigint,
  distinct_values bigint,
  mean double precision,
  variance double precision,
  min double precision,
  max double precision,
  first_quartile double precision,
  median double precision,
  third_quartile double precision,
  most_frequent_values text[]
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_start_activities_summary
  OWNER TO xiuli;

CREATE TABLE public.cc_transition
(
  fid integer,
  obs_id integer,
  ts_no1 integer,
  ts_no2 integer,
  activity1 integer,
  activity2 integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_transition
  OWNER TO xiuli;

CREATE TABLE public.cc_families
(
  fid integer,
  ip_age integer,
  p1_age integer,
  p2_age integer,
  p3_age integer,
  p4_age integer,
  p5_age integer,
  p6_age integer,
  family_size integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_families
  OWNER TO xiuli;


CREATE TABLE public.cc_background
(
  fid integer,
  ip_alder integer,
  ip_koen integer,
  ip_aktivitetsstatus integer,
  p1_alder integer,
  p1_koen integer,
  p1_aktivitetsstatus integer,
  p1_ip_relation integer,
  p2_alder integer,
  p2_koen integer,
  p2_aktivitetsstatus integer,
  p2_ip_relation integer,
  p3_alder integer,
  p3_koen integer,
  p3_aktivitetsstatus integer,
  p3_ip_relation integer,
  p4_alder integer,
  p4_koen integer,
  p4_aktivitetsstatus integer,
  p4_ip_relation integer,
  p5_alder integer,
  p5_koen integer,
  p5_aktivitetsstatus integer,
  p5_ip_relation integer,
  p6_alder integer,
  p6_koen integer,
  p6_aktivitetsstatus integer,
  p6_ip_relation integer,
  antalboernuskole integer,
  antaldeleboern integer,
  antalhjbboern integer,
  antalpersoner integer,
  defantalboern integer,
  defipaktstatus integer,
  defsamlaktstatus integer,
  spm10 integer,
  spm11ip integer,
  spm11sam integer,
  spm12aip integer,
  spm12asam integer,
  spm12ip integer,
  spm12sam integer,
  spm13ip integer,
  spm13sam integer,
  spm14ip integer,
  spm14sam integer,
  spm15ip integer,
  spm15sam integer,
  spm15y_ip integer,
  spm15y_sam integer,
  spm16ip integer,
  spm16sam integer,
  spm17ip integer,
  spm17sam integer,
  spm18ip integer,
  spm18sam integer,
  spm19ip integer,
  spm19sam integer,
  spm20fraip integer,
  spm20frasam integer,
  spm20tilip integer,
  spm20tilsam integer,
  spm21ip integer,
  spm21sam integer,
  spm22ip integer,
  spm22sam integer,
  spm23ip integer,
  spm23sam integer,
  spm24ip integer,
  spm24sam integer,
  spm25ip integer,
  spm25sam integer,
  spm26ip integer,
  spm26sam integer,
  spm27ip integer,
  spm27sam integer,
  spm28ip integer,
  spm28sam integer,
  spm29 integer,
  spm30 integer,
  spm31 integer,
  spm32 integer,
  spm33fle integer,
  spm33min integer,
  spm34ip integer,
  spm34sam integer,
  spm35_ip integer,
  spm35_sam integer,
  spm36_ip integer,
  spm36_sam integer,
  spm37 integer,
  spm381 integer,
  spm382 integer,
  spm383 integer,
  spm384 integer,
  spm385 integer,
  spm38_elm_1 integer,
  spm38_elm_2 integer,
  spm38_elm_3 integer,
  spm38_elm_4 integer,
  spm38_elm_5 integer,
  spm39a1 integer,
  spm39a2 integer,
  spm39a3 integer,
  spm39a4 integer,
  spm39a5 integer,
  spm39a_elm_1 integer,
  spm39a_elm_2 integer,
  spm39a_elm_3 integer,
  spm39a_elm_4 integer,
  spm39a_elm_5 integer,
  spm39b1 integer,
  spm39b2 integer,
  spm39b3 integer,
  spm39b4 integer,
  spm39b5 integer,
  spm39b_elm_1 integer,
  spm39b_elm_2 integer,
  spm39b_elm_3 integer,
  spm39b_elm_4 integer,
  spm39b_elm_5 integer,
  spm39c1 integer,
  spm39c2 integer,
  spm39c3 integer,
  spm39c4 integer,
  spm39c5 integer,
  spm39c_elm_1 integer,
  spm39c_elm_2 integer,
  spm39c_elm_3 integer,
  spm39c_elm_4 integer,
  spm39c_elm_5 integer,
  spm39d1 integer,
  spm39d2 integer,
  spm39d3 integer,
  spm39d4 integer,
  spm39d5 integer,
  spm39d_elm_1 integer,
  spm39d_elm_2 integer,
  spm39d_elm_3 integer,
  spm39d_elm_4 integer,
  spm39d_elm_5 integer,
  spm39e1 integer,
  spm39e2 integer,
  spm39e3 integer,
  spm39e4 integer,
  spm39e5 integer,
  spm39e_elm_1 integer,
  spm39e_elm_2 integer,
  spm39e_elm_3 integer,
  spm39e_elm_4 integer,
  spm39e_elm_5 integer,
  spm39f1 integer,
  spm39f2 integer,
  spm39f3 integer,
  spm39f4 integer,
  spm39f5 integer,
  spm39f_elm_1 integer,
  spm39f_elm_2 integer,
  spm39f_elm_3 integer,
  spm39f_elm_4 integer,
  spm39f_elm_5 integer,
  spm39g1 integer,
  spm39g2 integer,
  spm39g3 integer,
  spm39g4 integer,
  spm39g5 integer,
  spm39g_elm_1 integer,
  spm39g_elm_2 integer,
  spm39g_elm_3 integer,
  spm39g_elm_4 integer,
  spm39g_elm_5 integer,
  spm39h1 integer,
  spm39h2 integer,
  spm39h3 integer,
  spm39h4 integer,
  spm39h5 integer,
  spm39h_elm_1 integer,
  spm39h_elm_2 integer,
  spm39h_elm_3 integer,
  spm39h_elm_4 integer,
  spm39h_elm_5 integer,
  spm39i1 integer,
  spm39i2 integer,
  spm39i3 integer,
  spm39i4 integer,
  spm39i5 integer,
  spm39i_elm_1 integer,
  spm39i_elm_2 integer,
  spm39i_elm_3 integer,
  spm39i_elm_4 integer,
  spm39i_elm_5 integer,
  spm39j1 integer,
  spm39j2 integer,
  spm39j3 integer,
  spm39j4 integer,
  spm39j5 integer,
  spm39j_elm_1 integer,
  spm39j_elm_2 integer,
  spm39j_elm_3 integer,
  spm39j_elm_4 integer,
  spm39j_elm_5 integer,
  spm39k1 integer,
  spm39k2 integer,
  spm39k3 integer,
  spm39k4 integer,
  spm39k5 integer,
  spm39k_elm_1 integer,
  spm39k_elm_2 integer,
  spm39k_elm_3 integer,
  spm39k_elm_4 integer,
  spm39k_elm_5 integer,
  spm3ip integer,
  spm3ip_antal integer,
  spm3sam integer,
  spm3sam_antal integer,
  spm40a integer,
  spm40b integer,
  spm40c integer,
  spm40d integer,
  spm41_andre_barn1 integer,
  spm41_andre_barn2 integer,
  spm41_andre_barn3 integer,
  spm41_ipselv_barn1 integer,
  spm41_ipselv_barn2 integer,
  spm41_ipselv_barn3 integer,
  spm41_samlever_barn1 integer,
  spm41_samlever_barn2 integer,
  spm41_samlever_barn3 integer,
  spm41_stboern_barn1 integer,
  spm41_stboern_barn2 integer,
  spm41_stboern_barn3 integer,
  spm42a integer,
  spm42a_betalt integer,
  spm42a_timer integer,
  spm42b integer,
  spm42b_betalt integer,
  spm42b_timer integer,
  spm42c integer,
  spm42c_betalt integer,
  spm42c_timer integer,
  spm43ip integer,
  spm43ip_timer integer,
  spm43sam integer,
  spm43sam_timer integer,
  spm44 integer,
  spm45 integer,
  spm46a integer,
  spm46b integer,
  spm46c integer,
  spm47a integer,
  spm47b integer,
  spm47c integer,
  spm48 integer,
  spm49a integer,
  spm49b integer,
  spm49c integer,
  spm49d integer,
  spm4_barn1 integer,
  spm4_barn2 integer,
  spm4_barn3 integer,
  spm5 integer,
  spm50 integer,
  spm51 integer,
  spm52 integer,
  spm53 integer,
  spm54_ip integer,
  spm54_sam integer,
  spm55_ip integer,
  spm55_sam integer,
  spm56 integer,
  spm6 integer,
  spm7 integer,
  spm801 integer,
  spm802 integer,
  spm803 integer,
  spm804 integer,
  spm805 integer,
  spm806 integer,
  spm807 integer,
  spm808 integer,
  spm809 integer,
  spm810 integer,
  spm811 integer,
  spm812 integer,
  spm813 integer,
  spm814 integer,
  spm815 integer,
  spm8_elm_1 integer,
  spm8_elm_10 integer,
  spm8_elm_11 integer,
  spm8_elm_12 integer,
  spm8_elm_13 integer,
  spm8_elm_14 integer,
  spm8_elm_15 integer,
  spm8_elm_2 integer,
  spm8_elm_3 integer,
  spm8_elm_4 integer,
  spm8_elm_5 integer,
  spm8_elm_6 integer,
  spm8_elm_7 integer,
  spm8_elm_8 integer,
  spm8_elm_9 integer,
  spm8bil integer,
  spm8mobil integer,
  spm8pc integer,
  spm8tlfvar1 integer,
  spm8tlfvar10 integer,
  spm8tlfvar11 integer,
  spm8tlfvar12 integer,
  spm8tlfvar13 integer,
  spm8tlfvar14 integer,
  spm8tlfvar15 integer,
  spm8tlfvar2 integer,
  spm8tlfvar3 integer,
  spm8tlfvar4 integer,
  spm8tlfvar5 integer,
  spm8tlfvar6 integer,
  spm8tlfvar7 integer,
  spm8tlfvar8 integer,
  spm8tlfvar9 integer,
  spm8tv integer,
  spm9 integer
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.cc_background
  OWNER TO xiuli;
  
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
