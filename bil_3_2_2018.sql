/*Билет 3.2_2018_1.3_2017 Используя словарь данных, получить информацию о первичных ключах и
подчиненных таблицах всех таблиц в схеме HR:

Имя таблицы	| Список столбцов первичного ключа | Список подчиненных таблиц 

В списках имена столбцов и таблиц вывести через запятую. 
Задачу решить без использования функций Listagg и Wm_concat.
*/

with
t1 as (
select constraint_name pk,
constraint_type, table_name pk_tab
from user_constraints
where constraint_type = 'P'
)

, t2 as (
select constraint_name fk,
constraint_type, table_name fk_tab,
r_constraint_name
from user_constraints
where constraint_type = 'R'
)


, t3 as (
select t1.pk_tab, t1.pk, b.column_name col
from t1
left join user_cons_columns b
on (t1.pk = b.constraint_name )
order by 1,2,3
)

, t4 as (
select pk_tab, pk, col,
row_number() over (partition by pk order by col ) r1
from t3 )

, t5 as (
select pk_tab, pk,
regexp_replace(
sys_connect_by_path( col, ', ' ), 
'^,\s', '' )
 pk_col_list
from t4
where connect_by_isleaf = 1
start with r1 = 1
connect by prior r1 + 1 = r1
and
prior pk = pk
order by 1,2,3 )

, t6 as (
select t5.pk_tab, t5.pk_col_list, t2.fk_tab
from t5
left join t2
on (t5.pk = t2.r_constraint_name)
order by 1, 2 )

,t7 as (
select pk_tab, pk_col_list, fk_tab,
row_number() over (partition by pk_tab order by fk_tab) r1 
from t6 )

select pk_tab, pk_col_list,
regexp_replace(
sys_connect_by_path (fk_tab, ', '), '^,\s', '' )
fk_tab_list

from t7
where connect_by_isleaf = 1
start with r1 = 1
connect by prior r1 +1 = r1 
and
prior pk_tab = pk_tab
order by 1,2

;
