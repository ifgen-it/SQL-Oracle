/*Билет 2.4_2017 Создать запрос, который выводит фамилию студента, стипендию и процент,
который составляет его стипендия от суммарной стипендии студентов,
обучающихся в той же группе, а также накопленную сумму стипендий по группе от наибольшей к наименьшей.
Задачу решить без  использования аналитических функций.

*/

with
t1 as (
select номер_группы груп, фамилия фам,  стипендия стип
from студенты
order by 1, 3 desc, 2)

, t2 as (
select груп, sum(стип) гр_сум
from t1
group by груп )

, t3 as (
select груп, фам, стип, to_char(стип * 100 / гр_сум, '990.0' ) проц, rownum r
from t1
natural join t2 )

, t4 as (
select a.груп, a.фам, a.стип, a.проц, b.стип нак_сум
from t3 a
join t3 b
on (a.груп = b.груп 
and a.r >= b.r)
order by 1, 3 desc, 2
)

select груп, фам, стип, проц, sum(нак_сум) нак_сум
from t4
group by (груп, фам, стип, проц )
order by груп, стип desc, фам
;
