/*Лаба 9.6 Вывести список сотрудников отделов с тремя наибольшими зарплатами в виде столбцов.
Запрос должен возвращать ровно одну строку для каждого отела, причем в строке должно быть 4 столбца:
Номер отдела, Фамилия сотрудника с наивысшей зарплатой в отделе, Фамилия сотрудника со следующей зарплатой и т.д.

   DEPT_ID HIGHEST_SAL               SECOND_SAL                THIRD_SAL                
---------- ------------------------- ------------------------- -------------------------
        10 Whalen                                                                       
        20 Hartstein                 Fay                                                
        30 Raphaely                  Khoo                      Baida                    
        40 Mavris                                                                       
        50 Fripp                     Weiss                     Kaufling                 
        60 Hunold                    Ernst                     Austin                   
        70 Baer                                                                         
        80 Russell                   Partners                  Errazuriz                
        90 King                      De Haan                   Kochhar                  
       100 Greenberg                 Faviet                    Chen                     
       110 Higgins                   Gietz                          
*/

with
t1 as (
select department_id, last_name, salary,
row_number() over (partition by department_id order by salary desc , last_name ) r
from employees
)
, t2 as (
select *
from t1
where r <= 3
)
select distinct o.department_id dept_id,
nvl(
(
select i.last_name
from t2 i
where i.department_id = o.department_id
and i.r = 1
) , ' ') highest_sal,
nvl(
(
select i.last_name
from t2 i
where i.department_id = o.department_id
and i.r = 2
) , ' ') second_sal,
nvl(
(
select i.last_name
from t2 i
where i.department_id = o.department_id
and i.r = 3
) , ' ') third_sal

from t2 o
where o.department_id is not null
order by o.department_id
; 
