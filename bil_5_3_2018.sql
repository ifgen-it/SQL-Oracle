/*Билет 5.3_2018 Используя словарь данных, получить информацию об ограничениях CHECK схемы:
В списках имена столбцов вывести через запятую.  Имя таблицы не должно повторяться.
Задачу решить без использования функций Listagg и Wm_concat.
*/

with
t1 as (
select constraint_name cons,
table_name tab,
search_condition_vc cond
from user_constraints
where constraint_type = 'C'  )

, t2 as (
select constraint_name cons, table_name tab, column_name col, position pos
from user_cons_columns
)

, t3 as (
select cons, t2.col, t2.pos, t1.tab, t1.cond
from t1
left join t2
using (cons)
order by 1, 2 )

, t4 as (
select cons, 
col,
row_number() over(partition by cons order by col ) rn
from t3 )

,t5 as (
select cons, col, rn,
lag(rn) over (partition by cons order by rn) rn2
from t4
)

, t6 as (
select cons, 
regexp_replace(
sys_connect_by_path(col, ', '), '^,\s', '') col_list

from t5
where connect_by_isleaf =1
start with rn = 1
connect by prior rn = rn2
and 
prior cons = cons )

select b.tab "Имя таблицы",
 cons "Имя ограничения",
a.col_list "Столбцы, входящие в огр",
b.cond "Ограничение CHECK"
from t6 a
left join t1 b
using (cons)
;
