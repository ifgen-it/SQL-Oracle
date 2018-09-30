/*Билет 6.5_2018 Определить список последовательностей подчиненности от сотрудников,
не имеющих начальника, до сотрудников, не имеющих подчиненных.
Если список состоит более, чем из трех фамилий, то выводить только две первые и
последнюю  фамилии, а вместо остальных фамилий поставить многоточие.
Результат должен быть отсортирован в порядке убывания количества букв в строке.
При одинаковом количестве букв – по алфавиту
Результат должен иметь вид:  

King (не имеет начальника) =>Kochhar=>……=>Popp (не имеет подчиненных) 

*/

with
t1 as (
select case when manager_id is null then last_name || ' (не имеет начальника)'
else last_name end id_l,
employee_id id, manager_id pid
from employees
order by 2 )

, t2 as (
select regexp_replace(
regexp_replace(
sys_connect_by_path(id_l, '=>') || ' (не имеет подчиненных)' ,
'^=>', ''),
'([^=>]+)=>([^=>]+)=>(\w+=>)+([^=>]+)',
'\1=>\2=>......=>\4')
path
from t1
where connect_by_isleaf = 1
start with pid is null
connect by prior id = pid 
)

select path
from t2
order by length(path) desc, path
;
