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
)