/*Билет 1.2_2018 Определить даты последних пятниц ближайших
к заданной дате четырех високосных годов.

*/

with
input as (
select '26.12.2020' d from dual )

, input1 as (
select to_date((select d from input), 'dd.mm.yyyy' ) d from dual )
,
t1 as (
select to_number(to_char(
(select d from input1 )
,'yyyy'))
d1
from dual )

, t2 as (
select d1 + level -1 as d2
from t1
connect by level < 32 )

, t3 as (
select 
case 
when (mod(d2,4)=0 and not mod(d2, 100)=0) or mod(d2, 400)=0 then d2
end d3
from t2
)

, t4 as (
select d3
from t3
where d3 is not null
)

, t5 as (
select 
next_day(to_date( '31.12.'|| to_char(d3) , 'dd.mm.yyyy') - 7, 'friday' ) d4 
from t4
)

,t6 as (
select d4, rownum r
from t5
where d4 > (select d from input1 ))

select to_char(d4, 'dd-mm-yyyy')
"4 next leap years's fridays"
from t6
where r <= 4

;
