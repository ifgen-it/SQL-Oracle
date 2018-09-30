/*Билет 3.5_2018 Задана произвольная символьная строка, состоящая из двух частей,
разделенных символами «=>». В левой и правой части выражения содержатся символьные строки,
разделенные запятыми. Требуется создать запрос, который будет выводить все возможные пары
комбинаций из левой и правой частей.

Пример результата для строки a, fgf,yy=>uu,gh:

PATH
a=>uu
a=>gh
fgf=>uu
fgf=>gh
yy=>uu
yy=>gh

*/

with
t1 as (
select 'a,fgf,yy=>uu,gh' str
from dual )

, left as (
select regexp_substr(str, '^[^=>]+',1,1) s1
from t1 )

, right as (
select regexp_substr(str, '[^=>]+$',1,1) s2
from t1 )

, left1 as (
select regexp_substr(s1, '\w+', 1, level ) c1
from left
connect by level <= regexp_count(s1, '\w+')
)

, right1 as (
select regexp_substr(s2, '\w+', 1, level ) c2
from right
connect by level <= regexp_count(s2, '\w+')
)

select c1 || '=>' || c2 path
from left1
cross join right1;
