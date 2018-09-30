/*Лаба 9.9 Вывести из таблицы EMPLOYEES информацию о сотрудниках отделов с номерами 10,30,50,90.
Вывод должен быть оформлен в таблицу, содержащую столбцы:

  1. Сквозной порядковый номер сотрудника (1…n). 
  2. Порядковый номер сотрудника внутри отдела (1…n).
  3. Номер отдела для данного сотрудника (Department_id).
  4. Должность сотрудника (Job_id).
  5. Фамилия сотрудника (Last_name).
  6. Оклад (Salary).
  7. Ранг зарплаты сотрудника в отделе (1-самый высокооплачиваемый).
  
Строки в выводимой таблице должны удовлетворять следующим условиям:
 1. Строки, представляющие сотрудников одного отдела должны  располагаться друг за другом.
 2. Строки, представляющие сотрудников одного отдела должны располагаться в порядке убывания окладов. При совпадении рангов оклада строки должны располагаться в порядке увеличения идентификатора сотрудника.

*/

select employee_id,
row_number() over (partition by department_id order by employee_id) dep_num,
 department_id,
job_id, last_name, salary, 
dense_rank() over (partition by department_id order by salary desc ) dep_rank
from employees
where department_id in (10, 30, 50, 90 )
order by department_id, salary desc, dep_num
;
