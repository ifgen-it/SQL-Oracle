/*Билет 8.3_2018 Создать таблицу, в которой содержится  информация об удачных и
неудачных попытках пользователей подключиться к серверу:

Логин пользователя	Дата и время подключения	Результат
User 1	            10.06.10 17:20	          Неудачно
User 1	            10.06.10 17:21	          Успешно
User 1	            10.06.10 17:25	          Неудачно
User 2	            10.06.10 17:28	          Успешно
User 1	            10.06.10 17:30	          Неудачно
User 1	            10.06.10 17:35	          Неудачно
User 2	            10.06.10 17:40	          Успешно
User 1	            10.06.10 17:42	          Неудачно
User 1	            10.06.10 17:45	          Неудачно
User 1	            10.06.10 17:55	          Неудачно

Создать запрос без использования аналитических функций, который будет выводить информацию о пользователях,
совершившие подряд три неудачные попытки подключения. После третьей неудачной попытки счет начинается сначала.
В рассмотренном случае результат должен выглядеть следующим образом:  

Логин пользователя	Дата и время подключения	Результат
User 1	            10.06.10 17:35	          Третья неудачная попытка
User 1	            10.06.10 17:55	          Третья неудачная попытка

*/

-- Создание таблицы

create table Connections (
"Логин пользователя" varchar2(20) not null
, "Дата и время подключения" date not null
, "Результат" varchar2(20) not null
)

desc connections;

insert into connections values ('User 1', to_date('10.06.10 17:20','dd.mm.yy hh24:mi'), 'Неудачно');
insert into connections values ('User 1', to_date('10.06.10 17:21','dd.mm.yy hh24:mi'), 'Успешно');
insert into connections values ('User 1', to_date('10.06.10 17:25','dd.mm.yy hh24:mi'), 'Неудачно');
insert into connections values ('User 2', to_date('10.06.10 17:28','dd.mm.yy hh24:mi'), 'Успешно');
insert into connections values ('User 1', to_date('10.06.10 17:30','dd.mm.yy hh24:mi'), 'Неудачно');
insert into connections values ('User 1', to_date('10.06.10 17:35','dd.mm.yy hh24:mi'), 'Неудачно');
insert into connections values ('User 2', to_date('10.06.10 17:40','dd.mm.yy hh24:mi'), 'Успешно');
insert into connections values ('User 1', to_date('10.06.10 17:42','dd.mm.yy hh24:mi'), 'Неудачно');
insert into connections values ('User 1', to_date('10.06.10 17:45','dd.mm.yy hh24:mi'), 'Неудачно');
insert into connections values ('User 1', to_date('10.06.10 17:55','dd.mm.yy hh24:mi'), 'Неудачно');
commit;

select "Логин пользователя",
to_char("Дата и время подключения", 'dd.mm.yy hh24:mi') "Дата и время подключения", "Результат"
from connections;

-- Решение задачи

with
t1 as (
select "Логин пользователя" login, "Дата и время подключения" time, "Результат" result
from connections
order by 1, 2 )

,t11 as (
select login, time , result, rownum r1
from t1 )

, h1 as (
select distinct login
from t1 order by 1 )

, h2 as (
select login, rownum g1
from h1 )

, t2 as (
select login, time , result, g1, r1
from t11
natural join h2 )

, h3 as (
select login, min( r1) m1
from t2
group by login order by 1 )

,t3 as (
select login l, time t,  result res, g1, r1 - m1 + 1 as r2
from t2
natural join h3
order by g1, r2 )

, recur (l, t, res, g1, r2, att  ) as (

select l, t, res, g1, r2, case
when res = 'Успешно' then 0
else 1 end att
from t3
where r2 = 1
union all

select t3.l, t3.t, t3.res, t3.g1, t3.r2, case
when t3.res = 'Успешно' then 0
when r.res = 'Успешно' then 1
when r.res = 'Неудачно' then r.att + 1
end 

from recur r
join t3
on (r.g1 = t3.g1 and r.r2 +1 = t3.r2 )

)

select l "Логин пользователя", to_char(t, 
'DD.MM.RR HH24:MI') "Дата и время подключения", 'Третья неудачная попытка' "Результат"
from recur
where att<>0 and mod(att,3)=0
order by 1, 2
;
