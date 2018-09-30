/*Лаба 9.7 Вывести список из трех или менее сотрудников, получающих один из трех максимальных окладов по отделу.
Если четыре человека получают одинаковый – самый максимальный – оклад, в ответ не должно выдаваться ни одной строки.
Если два сотрудника имеют максимальный оклад, а два – следующий по значению, ответ будет предполагать две строки
(два сотрудника с максимальным окладом).                        
*/


with
t1 as (
select department_id, last_name, salary,
dense_rank() over(partition by department_id order by salary desc ) d_rank,
row_number() over (partition by department_id order by salary desc) r_num
from employees )

, t2 as (
select *
from t1
where d_rank <= 3 )

, t3 as (
-- убраем с 4 одинак зп
select * 
from t2 
where department_id not in
(select department_id 
from t2
where d_rank = 1 and r_num = 4 ) )
,
t4 as (
-- находим 4го с зп, как у 3го
select department_id, last_name, salary,
d_rank, r_num,
case 
when d_rank = 3 and r_num = 4
then 1
else 0
end waste1 
from t3 )
,
t5 as (
-- пометили лишних с пом. 1
select department_id, last_name, salary, d_rank, r_num, waste1,
lead(waste1,1,0) over(order by department_id, r_num) waste2
from t4 )

select department_id, last_name, salary, r_num cnt
from t5
where waste1 =0 and waste2 = 0
;
