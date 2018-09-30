/*Лаба 9.1 Вычислить отношение зарплаты каждого служащего, работающего на должности  PU_CLERK,
к суммарной зарплате всех служащих PU_CLERK.

LAST_NAME                     SALARY RR         
------------------------- ---------- -----------
Khoo                            3100  .223021583
Baida                           2900  .208633094
Tobias                          2800  .201438849
Himuro                          2600  .187050360
Colmenares                      2500  .179856115

*/

select last_name, salary,
to_char( (ratio_to_report(salary) over() ),
'.999999999' )
as rr
from employees
where job_id = 'PU_CLERK'
order by salary desc;
