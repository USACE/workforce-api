--------
-- ROLES
--------
-- For a production-ready deployment scenario, the role 'workforce_user' with a complicated selected password
-- should already exist, having been created when the database was stood-up.
-- The statement below is used to create database user for developing locally with Docker Compose with a
-- simple password ('workforce_pass'). https://stackoverflow.com/questions/8092086/create-postgresql-role-user-if-it-doesnt-exist
DO $$
BEGIN
  CREATE USER workforce_user WITH ENCRYPTED PASSWORD 'workforce_pass';
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role workforce_user -- it already exists';
END
$$;

-- Role workforce_reader;
DO $$
BEGIN
  CREATE ROLE workforce_reader;
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role workforce_reader -- it already exists';
END
$$;

-- Role workforce_writer
DO $$
BEGIN
  CREATE ROLE workforce_writer;
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role workforce_writer -- it already exists';
END
$$;

-- Role postgis_reader
DO $$
BEGIN
  CREATE ROLE postgis_reader;
  EXCEPTION WHEN DUPLICATE_OBJECT THEN
  RAISE NOTICE 'not creating role postgis_reader -- it already exists';
END
$$;

-- Role postgis_reader
-- GRANT SELECT ON geometry_columns TO postgis_reader;
-- GRANT SELECT ON geography_columns TO postgis_reader;
-- GRANT SELECT ON spatial_ref_sys TO postgis_reader;

-- Grant Permissions to workforce_user
GRANT postgis_reader TO workforce_user;
GRANT workforce_reader TO workforce_user;
GRANT workforce_writer TO workforce_user;

-- Set Search Path
ALTER ROLE workforce_user SET search_path TO workforce,topology,public;

-- Grant Schema Usage to workforce_user
GRANT USAGE ON SCHEMA workforce TO workforce_user;

-- Role workforce_reader
GRANT SELECT ON
    config,
    credential,
    credential_type,
    occupancy,
    occupation_code,
    occupant_credentials,
    office,
    office_group,
    pay_plan,
    position,
    v_office_positions,
    v_office_occupancy,
    v_occupation_metrics,
    data_call,
    data_call_completed
TO workforce_reader;

-- Role workforce_writer
GRANT INSERT,UPDATE,DELETE ON
    config,
    credential,
    credential_type,
    occupancy,
    occupation_code,
    occupant_credentials,
    office,
    office_group,
    pay_plan,
    position,
    data_call,
    data_call_completed
TO workforce_writer;
