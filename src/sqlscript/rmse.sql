drop table cc_ids;
create table cc_ids as 
select 
 row_number() over() as id, 
 C.*
FROM (
	select B.* 
	FROM (
	SELECT	
	  A.* from 
	 (select distinct fid, obs_id from cc_activity_all) A
	  order by random()
	) B
)C;

drop table cc_activity_real;
create table cc_activity_real as 
select A.fid, A.obs_id, A.ts_no, A.state 
from cc_activity_all A, cc_ids B 
where A.fid=B.fid and A.obs_id=B.obs_id and B.id<12084;

drop table cc_activity_syn;
create table cc_activity_syn as 
select A.fid, A.obs_id, A.ts_no, A.state 
from cc_activity_all A, cc_ids B 
where A.fid=B.fid and A.obs_id=B.obs_id and B.id>12083;



drop table cc_rmse_real;
create table cc_rmse_real as select 
 ts_no,
 count(*) filter (where state=1) as cn1,
 count(*) filter (where state=2) as cn2,
 count(*) filter (where state=3) as cn3,
 count(*) filter (where state=4) as cn4,
 count(*) filter (where state=5) as cn5,
 count(*) filter (where state=6) as cn6,
 count(*) filter (where state=7) as cn7,
 count(*) filter (where state=8) as cn8
from cc_activity_real
group by 1
order by 1;

drop table cc_rmse_syn;
create table cc_rmse_syn as select 
 ts_no,
 count(*) filter (where state=1) as cn1,
 count(*) filter (where state=2) as cn2,
 count(*) filter (where state=3) as cn3,
 count(*) filter (where state=4) as cn4,
 count(*) filter (where state=5) as cn5,
 count(*) filter (where state=6) as cn6,
 count(*) filter (where state=7) as cn7,
 count(*) filter (where state=8) as cn8
from cc_activity_syn 
group by 1
order by 1;


select 
 sqrt(sum(C.t)/(8*144))
FROM (
select 
	A.ts_no,
	power((A.cn1-B.cn1),2) +
	power((A.cn2-B.cn2),2) +
	power((A.cn3-B.cn3),2) +
	power((A.cn4-B.cn4),2) +
	power((A.cn5-B.cn5),2) +
	power((A.cn6-B.cn6),2) +
	power((A.cn7-B.cn7),2) +
	power((A.cn8-B.cn8),2) as t
from cc_rmse_syn A, cc_rmse_real B
where A.ts_no=B.ts_no
order by 1
) C;


