/*Билет 2.3_2018 Имеется  таблица D_V с первым столбцом Dat типа DATE (первичный ключ)
и вторым столбцом Val типа NUMBER. Пример ( строки упорядочены по первому столбцу): 

DAT             VAL 
01-08-08        232 
02-08-08 
10-08-08        182 
11-08-08 
21-08-08        240 
22-08-08 
23-08-08

Требуется написать запрос  для получения на основе таблицы D_V следующей таблицы: 

DAT         MAX_VAL
01-08-08        232
02-08-08        232
10-08-08        182
11-08-08        182
21-08-08        240
22-08-08        240
23-08-08        240

Данная результирующая таблица должна быть упорядочена по Dat, но вместо пустых значений,
которые присутствовали в столбце VAL отсортированной по DAT исходной таблицы, в столбце
MAX_VAL результирующей таблицы, должны присутствовать значения столбца из предыдущей строки.

*/

with 
inf1 as ( 
select to_date('01-08-08', 'DD-MM-YY')
dat, 232 val 
from dual 
union 
select to_date('02-08-08', 'DD-MM-YY'),
 null 
from dual 
union 
select to_date('10-08-08', 'DD-MM-YY'), 182 
from dual 
union 
select to_date('11-08-08', 'DD-MM-YY')
, null 
from dual 
union 
select to_date('21-08-08', 'DD-MM-YY')
, 240 
from dual 
union 
select to_date('22-08-08', 'DD-MM-YY')
, null 
from dual 
union 
select to_date('23-08-08', 'DD-MM-YY')
, null 
from dual) , 

inf as
(select dat, val, rownum rn from inf1),

not_null as
(select dat, val, rn from inf where val is not null),

recur (dat, val, rn) as
(select dat, val, rn from not_null
union all

select n.dat, r.val, n.rn
from recur r 
join inf n
 on(r.rn +1 = n.rn )

where n.val is null)

select to_char(dat, 'DD-MM-YY') dat, val max_val
from recur
order by 1
;
