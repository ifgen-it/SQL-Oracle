/*Билет 6.1_2018 Для произвольной команды SELECT определить список входящих в нее таблиц
(через запятую) с указанием имени схемы. Задачу решить одной командой SELECT.
Например, для команды:

WITH "СР ПО ОТД" AS (
SELECT DEPARTMENT_ID,AVG(SALARY) AS ASAL
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID),
"НАИБ БЛИЗ" AS (
SELECT DEPARTMENT_ID, MIN(ABS(SALARY - ASAL)) AS MINSAL
FROM EMPLOYEES JOIN "СР ПО ОТД" USING (DEPARTMENT_ID)
GROUP BY DEPARTMENT_ID)
SELECT EMPLOYEE_ID AS "Номер",LAST_NAME AS "Фамилия",JOB_ID AS "Должность",
DEPARTMENT_ID AS "Отдел",SALARY AS "Оклад", TRUNC(ASAL) AS "Средний оклад"
FROM EMPLOYEES JOIN "MY JOBS" USING (JOB_ID)
JOIN "СР ПО ОТД" USING (DEPARTMENT_ID) JOIN "НАИБ БЛИЗ"
USING (DEPARTMENT_ID)
WHERE (DEPARTMENT_ID, ABS(SALARY - ASAL)) IN
(SELECT DEPARTMENT_ID, MINSAL FROM "НАИБ БЛИЗ")
ORDER BY DEPARTMENT_ID, SALARY, LAST_NAME;

*/

with
t1 as (
select 'WITH "СР ПО ОТД" AS (
SELECT DEPARTMENT_ID,AVG(SALARY) AS ASAL
FROM hr.EMPLOYEES 
GROUP BY DEPARTMENT_ID),
"НАИБ БЛИЗ" AS (
SELECT DEPARTMENT_ID, MIN(ABS(SALARY - ASAL)) AS MINSAL
FROM EMPLOYEES JOIN "СР ПО ОТД" USING (DEPARTMENT_ID)
GROUP BY DEPARTMENT_ID)
SELECT EMPLOYEE_ID AS "Номер",LAST_NAME AS "Фамилия",JOB_ID AS "Должность",
DEPARTMENT_ID AS "Отдел",SALARY AS "Оклад", TRUNC(ASAL) AS "Средний оклад"
FROM EMPLOYEES JOIN "MY JOBS" USING (JOB_ID)
JOIN "СР ПО ОТД" USING (DEPARTMENT_ID) JOIN "НАИБ БЛИЗ"
USING (DEPARTMENT_ID)
WHERE (DEPARTMENT_ID, ABS(SALARY - ASAL)) IN
(SELECT DEPARTMENT_ID, MINSAL FROM "НАИБ БЛИЗ")
ORDER BY DEPARTMENT_ID, SALARY, LAST_NAME;'
as text
from dual )

,t2 as (
select regexp_substr(
(select text from t1),'("(\w| )+"\s+AS(\s*\())|((\w)+\s+AS(\s*\())',1,level,'i') tabs_as
from dual
connect by level <= regexp_count(
(select text from t1),'("(\w| )+"\s+AS(\s*\())|((\w)+\s+AS(\s*\())',1,'i')
)

,t3 as (
select distinct regexp_replace(tabs_as,
'\s+AS\s*\(','',1,1,'i') tabs_as_good
from t2 )

,t4 as (
select regexp_substr(
(select text from t1),'((from|join)\s+"(\w| )+")|((from|join)\s+\w+\.?\w+)',1,level,'i') all_tabs
from dual
connect by level <= regexp_count(
(select text from t1),'((from|join)\s+"(\w| )+")|((from|join)\s+\w+\.?\w+)',1,'i')
)

,t5 as (
select distinct regexp_replace(all_tabs,
'^(from|join)\s+','',1,1,'i') all_tabs_good
from t4 )

,t6 as (
select all_tabs_good real_tabs
from t5
minus
select tabs_as_good
from t3 )

,t7 as (
select case
when regexp_instr(real_tabs, '[^\.]+\.[^\.]+',1,1) > 0 then real_tabs
else 'os.' || real_tabs end tabs_with_schema
from t6
order by 1 )

select distinct listagg(tabs_with_schema, ', ') within group (order by tabs_with_schema) over() as tables_list
from t7
;
