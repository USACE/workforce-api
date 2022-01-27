-- Occupancy; Drop FK Constraint; Re-Add Constraint with ON CASCADE DELETE
ALTER TABLE occupancy DROP CONSTRAINT occupancy_position_id_fkey;
ALTER TABLE occupancy ADD CONSTRAINT occupancy_position_id_fkey FOREIGN KEY (position_id) REFERENCES position (id) ON DELETE CASCADE;

--occupant_credentials; Drop FK Constraint; Re-Add Constraint with ON CASCADE DELETE;
ALTER TABLE occupant_credentials DROP CONSTRAINT occupant_credentials_occupancy_id_fkey;
ALTER TABLE occupant_credentials ADD CONSTRAINT occupant_credentials_occupancy_id_fkey FOREIGN KEY (occupancy_id) REFERENCES occupancy (id) ON DELETE CASCADE;
