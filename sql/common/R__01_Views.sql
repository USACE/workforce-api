-- THIS IS NOT FINAL, JUST A PLACEHOLDER INITIAL START

CREATE OR REPLACE VIEW v_office_positions AS (
    SELECT DISTINCT 
    p.id AS position_id,
    p.title AS position_title,
    oc.code AS occupation_code,
    oc."name" AS occupation_name,
    p.is_active,
    p.is_supervisor,
    pp.code,
    p.grade,
    og.slug AS group_slug,
    (SELECT count(id) FROM occupancy o2 WHERE o2.position_id = p.id) AS all_occupants,
    CASE WHEN 
        (SELECT count(id) 
            FROM occupancy o2 
            WHERE o2.position_id = p.id 
            AND o2.end_date IS null) = 0 
        THEN 'VACANT' ELSE 'OCCUPIED' END AS status,
    o3.symbol AS office_symbol
    FROM "position" p 
    LEFT JOIN occupancy o ON o.position_id = p.id
    JOIN occupation_code oc ON oc.id  = p.occupation_code_id 
    JOIN pay_plan pp ON pp.id  = p.pay_plan_id
    JOIN office_group og ON og.id = p.office_group_id 
    JOIN office o3 ON o3.id = og.office_id
    ORDER BY status, p.title
);

-- VIEW FOR OFFICE OCCUPANCY
CREATE OR REPLACE VIEW v_office_occupancy AS (
SELECT
    o.id,
    o.position_id,
    o.title,
    o.start_date,
    o.end_date,
    o.service_start_date,
    o.service_end_date,
    o.dob,
    p.title AS position_title,
    p.grade AS position_grade,
    p.is_supervisor,
    p.is_active,
    p.last_updated AS last_updated,
    oc.code AS occupation_code,
    oc.name AS occupation_name,
    pp.code AS pay_plan_code,
    pp.name AS pay_plan_name,
    og.name AS group_name,
    og.slug AS group_slug,
    og.last_verified AS last_verified,
    o2.name AS office_name,
    o2.symbol AS office_symbol,
    o3.name AS parent_name,
    o3.symbol AS parent_symbol
FROM
    "position" AS p
JOIN occupancy AS o ON p.id = o.position_id
JOIN occupation_code AS oc ON p.occupation_code_id = oc.id
JOIN pay_plan AS pp ON p.pay_plan_id = pp.id
JOIN office_group AS og ON p.office_group_id = og.id
JOIN office AS o2 ON o2.id = og.office_id
JOIN office AS o3 ON o2.parent_id = o3.id 
ORDER BY office_symbol, occupation_code
);

-- VIEW FOR OCCUPATION METRICS
CREATE OR REPLACE VIEW v_occupation_metrics AS (
    WITH all_positions AS (

	SELECT 
	oc.name, 
	count(oc.name) AS name_cnt,
	count(p.id) filter (where p.is_allocated) AS allocated_cnt,
	count(o.id) filter (where o.end_date IS null) AS filled_cnt
	FROM position p
	JOIN occupation_code oc ON oc.id = p.occupation_code_id 
	LEFT JOIN occupancy o ON o.position_id = p.id AND o.end_date IS null
	GROUP BY oc.name
	ORDER BY name_cnt DESC , allocated_cnt DESC
),
	top_positions AS (
	
	SELECT name, name_cnt, allocated_cnt, filled_cnt 
	FROM all_positions
	LIMIT 6
),
	other_positions AS (

	SELECT name, name_cnt, allocated_cnt, filled_cnt 
	FROM all_positions 
	WHERE name NOT IN (SELECT name FROM top_positions)
	
)

-- Get the top x number of positions (ordered by count)
SELECT 
	name, name_cnt, 
	0 AS sort_field, 
	allocated_cnt, 
	filled_cnt
FROM top_positions
UNION 
-- Get the rest and sum into 'Other'
SELECT 
	'Other' AS name, 
	sum(name_cnt) AS name_cnt, 
	1 AS sort_field, 
	sum(allocated_cnt) AS allocated_cnt, 
	sum(filled_cnt) AS filled_cnt
FROM other_positions 
ORDER BY sort_field, name_cnt DESC
);