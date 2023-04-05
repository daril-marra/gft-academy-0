WITH CTE AS(
   SELECT A.*,
       RN = ROW_NUMBER()OVER(PARTITION BY ID, MONITORING_PLAN_ID, UPDATE_TIMESTAMP ORDER BY ID, MONITORING_PLAN_ID, UPDATE_TIMESTAMP)
   FROM DBO.MONITOR_MONITORING_ELEMENT A
   where monitoring_plan_id in 
	(	select 
		covenant.monitoring_plan_id from dbo.monitor_covenant covenant 
		join dbo.monitor_monitoring_element element 
		on 
		covenant.monitoring_plan_id = element.monitoring_plan_id and 
		element.due_date = '9999-12-31' 
		group by covenant.id, covenant.monitoring_plan_id having count(*) > 1
	) 
	and due_date = '9999-12-31'
)
/*DELETE*/
SELECT *   FROM CTE WHERE RN > 1;