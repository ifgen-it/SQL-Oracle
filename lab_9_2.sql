/*Лаба 9.2 Вычислить разницу между двумя следующими друг за другом зарплатами сотрудников.

*/


select employee_id, last_name, job_id,
 salary,
lag(salary,1,0) over(order by salary desc)
as salary_prev,
salary - 
lag(salary,1,0) over(order by salary desc)
as sal_dif

from employees;
