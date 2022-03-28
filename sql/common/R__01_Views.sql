CREATE OR REPLACE VIEW v_position_report AS (

    WITH current_occupant as (

	SELECT
	id,
	position_id,
	title,
	start_date,
	service_start_date,
	DATE_PART('year', now()) - DATE_PART('year', service_start_date) AS service_time,	
	DATE_PART('year', now()) - DATE_PART('year', dob) AS age
FROM
	occupancy
WHERE
	(end_date IS NULL
		OR end_date > NOW())
	AND (service_end_date IS NULL
		OR service_end_date > NOW())

)

SELECT
	CASE WHEN o3.symbol IS NULL THEN
		o2.symbol 
	ELSE o3.symbol
	END AS parent_office_symbol,
	CASE WHEN o3.name IS NULL THEN
		o2.name 
	ELSE o3.name
	END AS parent_office_name,
		
	--o3.symbol AS parent_office_symbol,
	--o3."name" AS parent_office_name,
	o2.symbol AS office_symbol,
	o2."name" AS office_name,	
	og."name" AS group_name,
	og.last_verified AS group_last_verified,
	oc.code AS occupation_code,
	oc.name AS occupation_name,	
	p.title,
	pp.code AS pay_plan_code,
	p.target_grade,
	concat(pp.code, '-', p.target_grade) AS pay_plan_grade,
	CASE WHEN co.id IS NULL THEN TRUE ELSE FALSE END AS is_vacant,
	p.is_supervisor,
	p.is_allocated,
	p.last_updated,
	CASE WHEN age IS NULL THEN
		'not available'
		WHEN age < 25 THEN
	    'Under 25'
	    WHEN age >= 25 AND age <= 35 THEN
	    '25-35'
	    WHEN age >= 35 AND age <= 45 THEN
	    '35-45'
	    WHEN age >= 45 AND age <= 55 THEN
	    '45-55'
	    ELSE 'Over 55'
	END AS age_range,
	    CASE WHEN service_time IS NULL THEN 
	    'not available'
	    WHEN service_time < 5 THEN
	    'Less than 5 years'
	    WHEN service_time >= 5 AND service_time <= 10 THEN
	    '5-10 years'
	    WHEN service_time >= 10 AND service_time <= 15 THEN
	    '10-15 years'
	    WHEN service_time >= 15 AND service_time <= 20 THEN
	    '15-20 years'
	    WHEN service_time >= 20 AND service_time <= 30 THEN
	    '20-30 years'
	    ELSE 'Over 30 years'
	END AS service_range
FROM
	position p
LEFT JOIN occupation_code oc ON oc.id = p.occupation_code_id
LEFT JOIN pay_plan pp ON pp.id = p.pay_plan_id 
LEFT JOIN current_occupant co ON co.position_id = p.id
LEFT JOIN office_group og ON og.id = p.office_group_id
LEFT JOIN office o2 ON o2.id  = og.office_id
LEFT JOIN office o3 ON o3.id = o2.parent_id
WHERE
	p.is_active --AND o2.symbol = 'LRN'
ORDER BY parent_office_symbol, office_symbol, group_name, occupation_code

	


);