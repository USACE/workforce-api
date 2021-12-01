-- THIS IS NOT FINAL, JUST A PLACEHOLDER INITIAL START

CREATE OR REPLACE VIEW v_office_positions AS (
    SELECT DISTINCT 
    p.id AS position_id,
    p.title AS position_title,
    oc.code AS occupation_code,
    oc."name" AS occupation_name,
    p.is_supervisor,
    pp.code,
    p.grade,
    (SELECT count(id) FROM occupancy o2 WHERE o2.position_id = p.id) AS all_occupants,
    CASE WHEN 
        (SELECT count(id) 
            FROM occupancy o2 
            WHERE o2.position_id = p.id 
            AND o2.end_date IS null) = 0 
        THEN 'VACANT' ELSE 'OCCUPIED' END AS status,
    o3.symbol AS office_symbol
    FROM workforce."position" p 
    LEFT JOIN workforce.occupancy o ON o.position_id = p.id
    JOIN workforce.occupation_code oc ON oc.id  = p.occupation_code_id 
    JOIN workforce.pay_plan pp ON pp.id  = p.pay_plan_id
    JOIN workforce.office o3 ON o3.id = p.office_id 
    ORDER BY status, p.title
)