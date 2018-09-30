/*Билет 3.3_2018 Определить, сколько раз каждая из цифр от 0 до 9 встречается в столбце Phone_number таблицы Employees.
Пример результата:

Цифра       0   1   2   3   4   5   6   7   8   9
Количество  15  12  23  45  24  33  45  12  30  15

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

select 'Количество' "Цифра",
sum("0") "0", sum("1") "1", sum("2") "2", 
sum("3") "3", sum("4") "4", sum("5") "5",
sum("6") "6", sum("7") "7", sum("8") "8",
sum("9") "9"

from t1
;
