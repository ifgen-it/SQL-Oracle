/*Билет 1.1_2018 Создать запрос, который позволит получить информацию о таблицах Вашей схемы:
Имя таблицы	Имя столбца 1	Значение по умолчанию 1	Имя столбца 2	Значение по умолчанию 2	Всего значений по умолчанию

*/

with
t1 as (
select table_name, column_id, column_name, data_default
from user_tables
join user_tab_columns
using (table_name)
order by 1,2 )

,t2 as(
select table_name, count(column_name) max_def
from t1
where data_default is not null
group by table_name )

select table_name "Имя таблицы"
, a.column_name "Имя столбца 1"
, a.data_default "Значение по умолчанию 1"
,b.column_name "Имя столбца 2"
, b.data_default "Значение по умолчанию 2"
, nvl(max_def, 0) "Всего значений по умолчанию"
from t1 a
join t1 b using (table_name)
left join t2 using (table_name)
where a.column_id = 1 and b.column_id = 2
order by 1
;
