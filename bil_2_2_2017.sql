/*Билет 2.2_2017 В заданной последовательности целых чисел найти максимально длинную подпоследовательность чисел такую,
что каждый последующий элемент подпоследовательности делился нацело на предыдущий.
Последовательность задается в виде списка целых чисел, разделенных запятыми.
*/

with
t1 as (
select '3, 9, 6, 7, 14, 28, 1, 2, 4, 8, 10'
n1
from dual )
, t2 as (
select 
regexp_substr(n1,
'\d+', 1, level ) n2
from t1
connect by level <= 
regexp_count(n1, '\d+',1)
)
, t3 as (
select n2, rownum r
from t2
)
, t4 as (
select orig.n2, orig.r,
(
select helper.n2
from t3 helper
where helper.r = orig.r +1
) n3
from t3 orig
)
, t5 as (
select r, n2, n3, 
case
when n3/n2 = trunc(n3/n2) then 1
else 0
end res
from t4
)
, t6 as (
select r, n2, n3 , res,
lag(res, 1, 0) over(order by r)
res_prev
from t5
)
, t7 as (
select sys_connect_by_path(n2, ' ') seq
from t6
where connect_by_isleaf = 1
start with res = 1 and res_prev = 0
connect by prior n3 = n2 and res_prev = 1
)
, t8 as (
select seq, regexp_count( seq,
'\d+', 1) num
from t7
)
, t9 as (
select seq max_seq
from t8
where num  = (
select max(num)
from t8 )
)
select 
(select n1 from t1 ) as source_string,
(select max_seq from t9) as max_sequence
from dual

;
