/*Билет 4.5_2018 Создать запрос, который выведет из символьного столбца таблицы
всю информацию за исключением значений, которые могут быть получены из другого
значения столбца за счет циклической перестановки символов.

Например, для столбца со значениями:

acghjk
rtrtr
ghjkac
agchjk

результат должен быть:

acghjk
rtrtr
agchjk

*/

with
input as (
select 'acghjk' text from dual union all
select 'basedata' from dual union all
select 'database' from dual union all
select 'rooot' from dual union all
select 'tabaseda' from dual union all
select 'tabaseda' from dual union all
select 'ghjkac' from dual union all
select 'otroo' from dual union all
select 'agchjk' from dual
)

,t1 as (
select text t, rownum r
from input
)

,recur ( r, t, lev) as (
select  r, t, 1 lev
from t1 
union all
select r, 
substr(t, 2 , length(t) - 1) ||
substr(t, 1,  1 )
, lev +1
from recur
where lev < length(t)
)

,t3 as (
select a.r r1, a.t t1, b.t t2,  b.r r2
from recur a
cross join t1 b
where a.r <> b.r and a.t = b.t
order by 1 )

, twins as (
select distinct case 
when r1 > r2 then r1
else r2 end r_max
from t3 )

, res as (
select t
from t1
where r not in (
select r_max from twins
) )

select *
from res
;
