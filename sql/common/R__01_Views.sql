CREATE OR REPLACE VIEW v_position_report AS (

  WITH 

current_occupant AS (
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

),
occupant_creds AS (
	SELECT
		oc.occupancy_id,
		c.abbrev,
		c.name AS cred_name,
		ct.name AS cred_type_name
	FROM
		occupant_credentials oc
		--JOIN occupancy o ON o.id = oc.occupancy_id 
	JOIN credential c ON
		c.id = oc.credential_id
	JOIN credential_type ct ON
		ct.id = c.credential_type_id
),
occupant_exp AS (
	SELECT
		oe.occupancy_id,
		e.name AS exp_name
	FROM
		occupant_expertise oe
	JOIN expertise e ON
		e.id = oe.expertise_id	
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
	CASE WHEN co.id IS NULL THEN 1 ELSE 0 END AS is_vacant,
	p.is_supervisor::int,
	p.is_allocated::int,
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
	END AS service_range,
	(SELECT count(ocr.occupancy_id) FROM occupant_creds ocr 
		WHERE ocr.occupancy_id = co.id AND ocr.cred_type_name = 'Professional Registration') AS prof_registration_count,
	(SELECT count(ocr.occupancy_id) FROM occupant_creds ocr 
		WHERE ocr.occupancy_id = co.id AND ocr.cred_type_name = 'Advanced Degree') AS adv_degree_count,
	(SELECT count(ocr.occupancy_id) FROM occupant_creds ocr 
		WHERE ocr.occupancy_id = co.id  AND ocr.cred_type_name = 'Certification') AS certification_count,	
	(SELECT count(oe.occupancy_id) FROM occupant_exp oe 
		WHERE oe.occupancy_id = co.id  AND oe.exp_name = 'Hydrology') AS expertise_hydrology,	
	(SELECT count(oe.occupancy_id) FROM occupant_exp oe 
		WHERE oe.occupancy_id = co.id  AND oe.exp_name = 'Hydraulics') AS expertise_hydraulics,
	(SELECT count(oe.occupancy_id) FROM occupant_exp oe 
		WHERE oe.occupancy_id = co.id  AND oe.exp_name = 'Coastal') AS expertise_coastal,
	(SELECT count(oe.occupancy_id) FROM occupant_exp oe 
		WHERE oe.occupancy_id = co.id  AND oe.exp_name = 'Water Management') AS expertise_wm,
	(SELECT count(oe.occupancy_id) FROM occupant_exp oe 
		WHERE oe.occupancy_id = co.id  AND oe.exp_name = 'Water Quality') AS expertise_wq
	
FROM
	position p
LEFT JOIN occupation_code oc ON oc.id = p.occupation_code_id
LEFT JOIN pay_plan pp ON pp.id = p.pay_plan_id 
LEFT JOIN current_occupant co ON co.position_id = p.id
LEFT JOIN office_group og ON og.id = p.office_group_id
LEFT JOIN office o2 ON o2.id  = og.office_id
LEFT JOIN office o3 ON o3.id = o2.parent_id
WHERE
	p.is_active
ORDER BY parent_office_symbol, office_symbol, group_name, occupation_code
);