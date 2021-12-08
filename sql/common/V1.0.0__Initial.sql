CREATE extension IF NOT EXISTS "uuid-ossp";
------------
-- CONFIG
------------

-- application config variables
CREATE TABLE IF NOT EXISTS config (
    config_name VARCHAR UNIQUE NOT NULL,
    config_value VARCHAR NOT NULL
);

------------
-- OFFICE
------------

CREATE TABLE IF NOT EXISTS office (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name VARCHAR UNIQUE NOT NULL,
    symbol VARCHAR UNIQUE NOT NULL,
    parent_id UUID references office(id)
);

INSERT INTO office (id, name, symbol, parent_id) VALUES
    ('e687330e-3890-4a2f-b666-faf55929dc64', 'Headquarters', 'HQ', NULL),
    ('91cf44dc-6384-4622-bd9f-0f36e4343413','Great Lakes and Ohio River Division','LRD',Null),
    ('17fa25b8-44a0-4e6d-9679-bdf6b0ee6b1a','Buffalo District','LRB','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('d8f8934d-e414-499d-bd51-bc93bbde6345','Chicago District','LRC','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('a8192ad1-206c-4da6-b19e-b7ba7a67aa1f','Detroit District','LRE','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('2f160ba7-fd5f-4716-8ced-4a29f75065a6','Huntington District','LRH','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('433a554d-7b27-4046-89eb-906788eb4046','Louisville District','LRL','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('552e59f7-c0cc-4689-8a4d-e791c028430a','Nashville District','LRN','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('61291eaf-d62f-4846-ad95-87cc86b56851','Pittsburgh District','LRP','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('306a2636-a5c0-4961-a0ba-eb7acb2e3e42', 'Southwestern Division', 'SWD', NULL),
    ('a6557ea2-2e4b-48e9-be22-40d6ff2715c3', 'Tulsa District', 'SWT', '306a2636-a5c0-4961-a0ba-eb7acb2e3e42'),
    ('c73dc03a-361e-4f8a-a9e6-4013917817f5', 'Little Rock District', 'SWL', '306a2636-a5c0-4961-a0ba-eb7acb2e3e42'),
    ('b1eebe5a-a376-4b5f-b402-b6a1d12334fa', 'Galveston District', 'SWG', '306a2636-a5c0-4961-a0ba-eb7acb2e3e42'),
    ('1b29c4c6-df89-4242-9c00-e24b7fbc8776', 'Fort Worth District', 'SWF', '306a2636-a5c0-4961-a0ba-eb7acb2e3e42'),
    ('535e039f-b564-4e7c-a308-c811cf5168ae', 'South Pacific Division', 'SPD', NULL),
    ('6a5c4c22-86d8-4134-acf1-a9126652cac4', 'San Francisco District', 'SPN', '535e039f-b564-4e7c-a308-c811cf5168ae'),
    ('66cb410c-690a-4fb6-9c5a-2c22c0cef11h', 'Los Angeles District', 'SPL', '535e039f-b564-4e7c-a308-c811cf5168ae'),
    ('75d39ad5-428a-439a-a9ff-cca5801514ca', 'Sacramento District', 'SPK', '535e039f-b564-4e7c-a308-c811cf5168ae'),
    ('1496194a-7794-4186-88d3-80dfeb2993a6', 'Albuquerque District', 'SPA', '535e039f-b564-4e7c-a308-c811cf5168ae'),
    ('cd40112c-bfa4-4a6e-86f4-7c0967e2f622', 'South Atlantic Division', 'SAD', NULL),
    ('bf00d4a5-76f9-40ad-ab3a-6be3dc21409h', 'Wilmington District', 'SAW', 'cd40112c-bfa4-4a6e-86f4-7c0967e2f622'),
    ('eff7715a-90bd-4488-9ae8-c9a8da68843e', 'Savannah District', 'SAS', 'cd40112c-bfa4-4a6e-86f4-7c0967e2f622'),
    ('f45e7e4b-6df8-48a4-a91a-9ea1afcb8f3e', 'Mobile District', 'SAM', 'cd40112c-bfa4-4a6e-86f4-7c0967e2f622'),
    ('eeb49643-8c35-4869-a693-53fb9461d8db', 'Jacksonville District', 'SAJ', 'cd40112c-bfa4-4a6e-86f4-7c0967e2f622'),
    ('b9efc224-6a43-44c4-9362-bb3ce24a03c6', 'Charleston District', 'SAC', 'cd40112c-bfa4-4a6e-86f4-7c0967e2f622'),
    ('9133108c-e582-47df-bbc5-7ad9d7d0e60c', 'Pacific Ocean Division', 'POD', NULL),
    ('91a4ce71-a897-49ed-9983-fb935fe3da62', 'Honolulu District', 'POH', '9133108c-e582-47df-bbc5-7ad9d7d0e60c'),
    ('ee4702b4-fa57-492e-bcfe-eb5295b8bed4', 'Alaska District', 'POA', '9133108c-e582-47df-bbc5-7ad9d7d0e60c'),
    ('62aa245d-44bd-43b3-89c7-daf5b3b07e01', 'Northwestern Division', 'NWD', NULL),
    ('f53781c7-9eff-464d-8c85-9c6796557c0u', 'Walla Walla District', 'NWW', '62aa245d-44bd-43b3-89c7-daf5b3b07e01'),
    ('138bb5f0-3436-4237-8958-57683eeaab47', 'Seattle District', 'NWS', '62aa245d-44bd-43b3-89c7-daf5b3b07e01'),
    ('7410bebf-fa5c-4321-aa26-489799e361bf', 'Portland District', 'NWP', '62aa245d-44bd-43b3-89c7-daf5b3b07e01'),
    ('6b857ff6-b5c1-4234-af6e-9e5936ef3b54', 'Omaha District', 'NWO', '62aa245d-44bd-43b3-89c7-daf5b3b07e01'),
    ('12a7f1dn-1d41-4006-9e44-a9c45ad78927', 'Kansas City District', 'NWK', '62aa245d-44bd-43b3-89c7-daf5b3b07e01'),
    ('457e5181-10d2-44fb-bb18-42a549550e32', 'North Atlantic Division', 'NAD', NULL),
    ('5c7bb3f5-a040-48ac-856a-fba3866f866f', 'Philadelphia District', 'NAP', '457e5181-10d2-44fb-bb18-42a549550e32'),
    ('5358e2a9-cd7y-45fd-8508-daa5685ab12f', 'Norfolk District', 'NAO', '457e5181-10d2-44fb-bb18-42a549550e32'),
    ('82d8cf28-a51q-4dbf-b7dc-8cde19c17db7', 'New York District', 'NAN', '457e5181-10d2-44fb-bb18-42a549550e32'),
    ('5accc677-a8de-4e04-9e51-38953cf00f79', 'New England District', 'NAE', '457e5181-10d2-44fb-bb18-42a549550e32'),
    ('b333fbcb-5143-47eb-ae2f-da90e940b9fa', 'Baltimore District', 'NAB', '457e5181-10d2-44fb-bb18-42a549550e32'),
    ('bca38692-ee23-43ab-9706-411c5ff4dd81', 'Mississippi Value Division', 'MVD', NULL),
    ('c34516e5-4a9b-4cce-bb5f-a13b4f885ac4', 'St. Louis District', 'MVS', 'bca38692-ee23-43ab-9706-411c5ff4dd81'),
    ('a0672b34-37ec-4ad6-8fdc-b55eedec9681', 'Rock Island District', 'MVR', 'bca38692-ee23-43ab-9706-411c5ff4dd81'),
    ('605e9bb6-1bd3-4a8a-ab55-1a1cd6be37ad', 'St. Paul District', 'MVP', 'bca38692-ee23-43ab-9706-411c5ff4dd81'),
    ('b41d8961-a941-4e00-aa91-1a08e2efa180', 'New Orleans District', 'MVN', 'bca38692-ee23-43ab-9706-411c5ff4dd81'),
    ('fc7af35b-fe31-4e2e-8bc4-a073b016c019', 'Memphis District', 'MVM', 'bca38692-ee23-43ab-9706-411c5ff4dd81'),
    ('3e7439ae-45bd-4083-83eb-4a7e22f35b0a', 'Vicksburg District', 'MVK', 'bca38692-ee23-43ab-9706-411c5ff4dd81'),
    ('ad667c3d-59de-47cc-81f0-7d55eae779d9', 'Engineering Research and Development Center', 'ERDC', NULL),
    ('9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal and Hydraulics Laboratory', 'CHL', 'ad667c3d-59de-47cc-81f0-7d55eae779d9'),
    ('2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26', 'Cold Regions Research and Engineering Laboratory', 'CRREL', 'ad667c3d-59de-47cc-81f0-7d55eae779d9'),
    ('58a876a5-8122-49c4-bc99-73f22ccd661h', 'Environmental Laboratory', 'EL', 'ad667c3d-59de-47cc-81f0-7d55eae779d9'),
    ('2fc76e25-707b-4d4b-a745-186e9fa4ba40', 'Institute for Water Resources', 'IWR', NULL),
    ('2822b938-f7c8-420b-89a2-201268cf472b', 'Hydrologic Engineering Center', 'HEC', '2fc76e25-707b-4d4b-a745-186e9fa4ba40'),
    ('cd7a8f3b-fb86-413e-8a74-103295d72bce', 'Risk Management Center', 'RMC', '2fc76e25-707b-4d4b-a745-186e9fa4ba40'),
    ('c9079091-7554-4008-bb9c-2e9b9f414472', 'Modeling, Mapping, and Consequence', 'MMC', NULL),
    ('c4cb9f2c-aadc-418f-802c-897797525a1a', 'Dam Safety Production Center', 'DSPC', NULL);

------------------
-- OCCUPATION_CODE
------------------

-- occupation_code table (ex: 0801, 2210)
CREATE TABLE IF NOT EXISTS occupation_code (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    code VARCHAR UNIQUE NOT NULL,
    name VARCHAR NOT NULL
);

-- occupation_codes
INSERT INTO occupation_code VALUES
    ('f2227f88-0a44-4348-b26b-b021fa1589dc', '0110', 'Economist'),
    ('b724fb8c-3481-411b-9e86-8e6339d4ba7e', '0150', 'Geography'),
    ('d28d9edb-a5ff-48ae-a255-316c774d1f5d', '0401', 'Biology'),
    ('a7be0118-a4ef-4dad-a79a-6b0d03004ea3', '0404', 'Biological Science Technician'),
    ('9a6b9dae-ddbd-40ae-b550-c00db9fa413b', '0408', 'Ecology'),
    ('81b65c51-4f0f-4efb-9736-479e30a09648', '0410', 'Zoology'),
    ('72997931-f483-40c5-82c7-90529bd5a54d', '0482', 'Fish Biology'),
    ('3de69520-f4f4-48fb-830b-65cddb2a1802', '0486', 'Wildlife Biology'),
    ('67712172-2c82-43bb-93ea-8d3235f4fe86', '0499', 'Biological Science Student Trainee'),
    ('f22dcb77-eef3-4dbb-8a21-baaae76a0a66', '0801', 'General Engineering'),
    ('fe1c966b-76c1-4b80-89c5-43a3d4198f6f', '0802', 'Engineering Technical'),
    ('dc091470-ccc2-4f12-b3cf-6a9bf71f8238', '0810', 'Civil Engineering'),
    ('fcb0b6fe-b5d1-43e8-9a3e-4c3dc7ad1a9f', '0817', 'Survey Technical'),
    ('001c540d-1b08-4b62-a41c-4b1387430811', '0819', 'Environmental Engineering'),
    ('461202f2-ed95-498e-aa63-c86d83291bc0', '0830', 'Mechanical Engineering'),
    ('a4d0a8bb-e950-4e9c-bb82-b5c36aff6136', '0850', 'Electrical Engineering'),
    ('868558e8-5145-4849-ada8-f05df57d0347', '0899', 'Engineering and Architecture Student Trainee'),
    ('7bebbf6c-1ff7-4bcb-8827-49854735aafe', '1301', 'General Physical Science'),
    ('cad51b25-25b7-4a7e-b28f-e5337e21ff16', '1311', 'Physical Science Technician'),
    ('8302e976-2efd-41c7-abcd-d0e7c8bc5994', '1315', 'Hydrology'),
    ('4cf0d83f-c560-481e-89f0-c641a77fcb9d', '1316', 'Hydrologic Technician'),
    ('1f58e23d-fb44-43f2-bd8b-522518805b46', '1340', 'Meteorology'),
    ('326d414a-1ac3-4abc-8f9b-9766f65c43f0', '1341', 'Meteorological Technician'),
    ('defefe34-4cd6-415c-942b-2b8e56838940', '1350', 'Geology'),
    ('86ab9305-ebc1-4b44-b2ce-6fa3e3c18d0b', '1360', 'Oceanography'),
    ('2051a246-ef4a-48bc-a76a-242436cf3d5b', '1373', 'Land Surveying'),
    ('836d8ac0-6b5e-4d02-abaa-d142a99b36f0', '1399', 'Physical Science Student Trainee'),
    ('aa647087-5a29-4a30-85d5-d8c38e6854a9', '1501', 'General Mathematics and Statistics'),
    ('d17bcd6e-2d7d-462d-a6dd-d05aac0d4008', '1520', 'Mathematics'),
    ('5e81810d-90c6-4e27-aed5-ad9003abebed', '1521', 'Mathematics Technician'),
    ('a8dd7e80-2730-4681-8f4f-50f81893e534', '1529', 'Mathematical Statistics'),
    ('d05d8232-830e-418b-800b-3a18efd051ff', '1550', 'Computer Science'),
    ('e006a6ba-8018-437e-884a-284e0845f3b7', '2210', 'IT Specialist'),
    ('ef27b702-1cc9-47cd-b6ab-0fa5ee7ceba7', '2299', 'Information Technology Student Trainee');


------------------
-- PAY PLAN
------------------

-- pay plans
CREATE TABLE IF NOT EXISTS pay_plan (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    code VARCHAR UNIQUE NOT NULL,
    name VARCHAR UNIQUE NOT NULL
);

/* https://dw.opm.gov/datastandards/referenceData/1497/current */
INSERT INTO pay_plan (id, code, name) VALUES
    ('10d910f3-75d5-4e74-855e-906ffebb30f6', 'SES', 'Senior Executive Service'),
    ('3a4823a1-44f1-48bc-9b1c-e52c25dee0b0', 'DB', 'Demonstration Engineers and Scientists'),
    ('4a8fb820-0f8d-457e-af9c-1aca86923a33', 'DJ', 'Demonstration Administrative'),
    ('ed1c3145-465f-4399-abe6-a7db4f096fa7', 'DE', 'Demonstration Engineers and Scientists Technicians'),
    ('24533fd9-6158-422f-b1bc-94d5779bd2aa', 'GS', 'General Schedule');

------------------
-- CREDENTIALS
------------------

-- credential_type
CREATE TABLE IF NOT EXISTS credential_type (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name VARCHAR UNIQUE NOT NULL
);

INSERT INTO credential_type (id, name) VALUES
    ('9e1aeb76-5b84-42f9-ac66-9aa9e6074ca0', 'Advanced Degree'),
    ('b867b808-7ca2-4442-8173-e5e1aec2919d', 'Professional Registration'),
    ('3c4a0953-cdf3-49c2-b0a0-2f85906e9214', 'Certification');

-- certifications/professional creds/degrees
CREATE TABLE IF NOT EXISTS credential (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    abbrev VARCHAR UNIQUE NOT NULL,
    name VARCHAR UNIQUE NOT NULL,
    credential_type_id UUID NOT NULL REFERENCES credential_type(id)
);

INSERT INTO credential (id, abbrev, name, credential_type_id) VALUES
    ('e4e8cf08-7571-47c8-8451-ff4a010e0056', 'PE', 'Professional Engineer', 'b867b808-7ca2-4442-8173-e5e1aec2919d'),
    ('73fe40cf-3f9c-4def-9285-4825ba98cccf', 'PH', 'Professional Hydrologist', 'b867b808-7ca2-4442-8173-e5e1aec2919d'),
    ('535ba415-6be5-410d-b53c-8759c23c62cf', 'PhD', 'Doctor of Philosophy', '9e1aeb76-5b84-42f9-ac66-9aa9e6074ca0');


CREATE TABLE IF NOT EXISTS office_group (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    office_id UUID NOT NULL REFERENCES office(id),
    name VARCHAR NOT NULL,
    slug VARCHAR NOT NULL,
    last_verified date,
    CONSTRAINT unique_office_slug UNIQUE(office_id, slug)
);

-- @todo
-- NEED TO ADD SECTION/GROUP FOR EACH OFFICE FROM SPREADSHEET

INSERT INTO office_group (id, office_id, name, slug) VALUES
    ('c5fbbb80-3cb5-4407-a8b0-d5fd105714fc', '552e59f7-c0cc-4689-8a4d-e791c028430a', 'Water Resources', 'water-resources'),
    ('5db16a83-f38b-4a16-8aa1-ea1175c6003e', '552e59f7-c0cc-4689-8a4d-e791c028430a', 'Water Management', 'water-management'),
    ('8c44bda8-cbc7-4348-989d-e3eb2a0148c0', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', 'Water Management', 'water-management');


------------------
-- POSITION
------------------

CREATE TABLE IF NOT EXISTS position (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    occupation_code_id UUID REFERENCES occupation_code(id),
    spreadsheet_series VARCHAR,
    title VARCHAR,
    office_group_id UUID NOT NULL REFERENCES office_group(id),
    pay_plan_id UUID NOT NULL REFERENCES pay_plan(id),
    grade SMALLINT,
    is_supervisor BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_updated date NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--------------------
-- OCCUPANCY
--------------------

CREATE TABLE IF NOT EXISTS occupancy ( 
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    position_id UUID NOT NULL REFERENCES position(id),
    title VARCHAR,
    start_date date NOT NULL,
    end_date date,
    service_start_date date,
    service_end_date date,
    dob date,
    CONSTRAINT unique_occupancy UNIQUE(position_id, start_date)
);

-- position_credentials
CREATE TABLE IF NOT EXISTS occupant_credentials (
    occupancy_id UUID NOT NULL REFERENCES occupancy(id),
    credential_id UUID NOT NULL REFERENCES credential(id),
    CONSTRAINT unique_occupant_credential UNIQUE(occupancy_id, credential_id)
);

--------------------
-- DATA CALL
--------------------
CREATE TABLE IF NOT EXISTS data_call (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    title VARCHAR NOT NULL,
    description TEXT,
    start_date date NOT NULL,
    due_date date NOT NULL,
    CONSTRAINT unique_data_call UNIQUE(title, due_date)
);

CREATE TABLE IF NOT EXISTS data_call_completed (
    data_call_id UUID NOT NULL REFERENCES data_call(id),
    office_group_id UUID NOT NULL REFERENCES office_group(id),
    completion_date date NOT NULL,
    sub UUID NOT NULL
);