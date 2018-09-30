/*Билет 5.2_2018 Создать запрос для разделения  "задвоенных" данных. Например, из

CODE      ID            
--------- --------------
1000 1100 841000 841100 
2000      6700 8967 5500

сделать

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

, t2 as (
select code, id, rownum r1,
regexp_count(code, '\d+') n1,
regexp_count(id, '\d+') n2
from t1 )

, t3 as (
select  r1, 
case 
when n1 > n2 then n1
else n2
end n,
code, id
from t2 )

, t4 as (
select distinct level lev,
regexp_substr(code, '\d+', 1, level) co1,
regexp_substr(id, '\d+', 1, level) id1,
 r1
 from t3
connect  by level <= 
(
select max ( n ) 
from t3
)
order by r1, level )

, t5 as (
select 0 cnt, code, id, r1
from t3
union 
select
lev, co1, id1, r1
from t4
order by r1, cnt )

, t6 as (
select cnt, code, id, r1
 from t5
minus
select *
 from t5
where code is null and id is null
order by r1, cnt
)

select case
when cnt = 0 then to_char( r1)
else ' '
end rn,
to_char(cnt) cnt,
 nvl(code, ' ') code_operation, 
nvl(id, ' ') id_client
from t6
;
