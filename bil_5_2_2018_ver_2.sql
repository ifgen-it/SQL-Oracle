/*Билет 5.2_2018 Создать запрос для разделения  "задвоенных" данных. Например, из

CODE      ID            
--------- --------------
1000 1100 841000 841100 
2000      6700 8967 5500

сделать:

RN                                       CNT                                      CODE_OPER ID_CLIENT     
---------------------------------------- ---------------------------------------- --------- --------------
1                                        0                                        1000 1100 841000 841100 
                                         1                                        1000      841000        
                                         2                                        1100      841100        
2                                        0                                        2000      6700 8967 5500
                                         1                                        2000      6700          
                                         2                                                  8967          
                                         3                                                  5500          
*/

with
t1 as (
select '1000 1100'  code,
'841000 841100'  id
from dual
union all
select '2000',
'6700 8967 5500'
from dual )

,t2 as (
select code, id, rownum r1
from t1 )

, t_c1 as (
select distinct r1, level r2,
regexp_substr(code, '\d+', 1, level ) c1
from t2
connect by level <= regexp_count(code, '\d+')
order by 1 )

, t_id1 as (
select distinct r1, level r2,
regexp_substr(id, '\d+', 1, level ) id1
from t2
connect by level <= regexp_count(id, '\d+')
order by 1 )

,t3 as (
select a.r1 ar1, a.r2 ar2, a.c1, b.id1, b.r1 br1, b.r2 br2
from t_c1 a
full outer join t_id1 b
on (
a.r1 = b.r1 and a.r2 = b.r2 )
)

, t4 as (
select c1, id1, 
case 
when ar1 is not null then ar1
else br1 end r1,
case 
when ar2 is not null then ar2
else br2 end r2,
null rn
from t3

union 

select 
code, id, r1, 0, r1

from t2

order by r1, r2 )

select nvl(to_char(rn), ' ') rn, 
r2 cnt, 
nvl(to_char(c1),' ') code, 
nvl(to_char(id1),' ') id
from t4
;
