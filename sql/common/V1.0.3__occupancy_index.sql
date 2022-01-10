-- create index for occupancy position_id and end_date
CREATE UNIQUE INDEX i_current_occupancy on occupancy (position_id, (end_date is NULL)) WHERE end_date is NULL;
