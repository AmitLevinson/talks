
with recursive_payments  as 

(select from_user as origin,
	to_user as receiver,
	1 as Iteration
from ml_payments
where from_user = '7804'
union all
select from_user,
	to_user,
	Iteration + 1 as Iteration
from recursive_payments rp
JOIN ML_PAYMENTS ml on ml.from_user = rp.receiver
where Iteration <= 25
)

select * 
from recursive_payments