/*Билет 2.3_2017 Получить информацию о подчиненности таблиц в схеме в виде:

        ИмяТаблицы1[ИмяFK1(список_столбцов) ссылается на ИмяТаблицы2/ИмяKлюча2(список_столбцов)]
        ИмяТаблицы2[ИмяFK2(список_столбцов) ссылается на ИмяТаблицы3/ИмяКлюча3(список_столбцов)]

*/

with
t1 as (select table_name fk_tab, constraint_name fk,
r_constraint_name pk
from user_constraints
where constraint_type = 'R'
order by 1,2 )

, t2 as (
select fk_tab, fk, pk, a.table_name pk_tab
from t1
left join user_constraints a
on (t1.pk = a.constraint_name)
)

,t3 as (
select constraint_name con,
column_name col
from user_constraints
left join user_cons_columns
using ( constraint_name)
where constraint_type in ('P', 'R')
order by constraint_type, 1
)

,t4 as (
select distinct con,
listagg(col, ', ') within group (order by col) over (partition by con) col_list
from t3
order by 1 )

, t5 as (
select fk_tab , a.col_list fk_col_list, fk, pk, b.col_list pk_col_list, pk_tab
from t2
left join t4 a
on (fk = a.con)
left join t4 b
on (pk = b.con)
order by 1, 3 )

select
fk_tab ||' [' || fk || ' (' || fk_col_list || ') ссылается на ' || pk_tab || '/' || pk || ' (' || pk_col_list || ')]' "Подчиненность таблиц в схеме"
from t5

;
