/*Билет 4.4_2018 Определить цифры, которые максимальное количество раз
встречаются в столбце Phone_number таблицы Employees.

Пример результата:

MAX_CNT	NUM
212	1
212	4

*/

with
t1 as (
select 
regexp_count(phone_number, '0') "0",
regexp_count(phone_number, '1') "1",
regexp_count(phone_number, '2') "2",
regexp_count(phone_number, '3') "3",
regexp_count(phone_number, '4') "4",
regexp_count(phone_number, '5') "5",
regexp_count(phone_number, '6') "6",
regexp_count(phone_number, '7') "7",
regexp_count(phone_number, '8') "8",
regexp_count(phone_number, '9') "9"
from employees
)

, t2 as (
select 
sum("0") "0", sum("1") "1", sum("2") "2", 
sum("3") "3", sum("4") "4", sum("5") "5",
sum("6") "6", sum("7") "7", sum("8") "8",
sum("9") "9"
from t1 )

, t3 as (
select "0" cnt , '0' num from t2 union all
select "1", '1' from t2 union all
select "2", '2' from t2 union all
select "3", '3' from t2 union all
select "4", '4' from t2 union all
select "5", '5' from t2 union all
select "6", '6' from t2 union all
select "7", '7' from t2 union all
select "8", '8' from t2 union all
select "9", '9' from t2 
)

select cnt max_cnt, num
from t3
where cnt = (
select max(cnt) from t3
)
;
