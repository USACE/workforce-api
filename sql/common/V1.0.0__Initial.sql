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
    ('e687330e-3890-4a2f-b666-faf55929dc64','Headquarters', 'HQ', NULL),
    ('91cf44dc-6384-4622-bd9f-0f36e4343413','Great Lakes and Ohio River Division','LRD',Null),
    ('17fa25b8-44a0-4e6d-9679-bdf6b0ee6b1a','Buffalo District','LRB','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('d8f8934d-e414-499d-bd51-bc93bbde6345','Chicago District','LRC','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('a8192ad1-206c-4da6-b19e-b7ba7a67aa1f','Detroit District','LRE','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('2f160ba7-fd5f-4716-8ced-4a29f75065a6','Huntington District','LRH','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('433a554d-7b27-4046-89eb-906788eb4046','Louisville District','LRL','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('552e59f7-c0cc-4689-8a4d-e791c028430a','Nashville District','LRN','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('61291eaf-d62f-4846-ad95-87cc86b56851','Pittsburgh District','LRP','91cf44dc-6384-4622-bd9f-0f36e4343413'),
    ('485d800d-a30d-4fcb-af43-0bea2ce11adb','Mississippi Valley Division','MVD',Null),
    ('1245e3c0-fc72-4621-86b2-24ff7de21f88','Memphis District','MVM','485d800d-a30d-4fcb-af43-0bea2ce11adb'),
    ('f81f5659-ce57-4c87-9c7a-0d685a983bfd','New Orleans District','MVN','485d800d-a30d-4fcb-af43-0bea2ce11adb'),
    ('81557734-7046-4c55-90ac-066dd882166a','Rock Island District','MVR','485d800d-a30d-4fcb-af43-0bea2ce11adb'),
    ('565be474-0c68-44a6-8e66-b833a39685bd','St. Louis District','MVS','485d800d-a30d-4fcb-af43-0bea2ce11adb'),
    ('2cf60156-f22a-418a-bc9f-a28960ad0321','St. Paul District','MVP','485d800d-a30d-4fcb-af43-0bea2ce11adb'),
    ('b9cca282-eb91-4ea1-b075-d067b4420184','Vicksburg District','MVK','485d800d-a30d-4fcb-af43-0bea2ce11adb'),
    ('973ad07b-7df3-4a95-9e43-7bc25930f7a8','North Atlantic Division','NAD',Null),
    ('7ed4821f-9e37-4c56-8baf-05c1b5bcc84c','Baltimore District','NAB','973ad07b-7df3-4a95-9e43-7bc25930f7a8'),
    ('bf99dc79-51d3-4abe-aba4-7e1781315766','Europe District','NAU','973ad07b-7df3-4a95-9e43-7bc25930f7a8'),
    ('30cb06ee-bd94-4c49-a945-e92735e7bdc1','New England District','NAE','973ad07b-7df3-4a95-9e43-7bc25930f7a8'),
    ('4ca9e255-8a88-44d3-8091-bb61931e600c','New York District','NAN','973ad07b-7df3-4a95-9e43-7bc25930f7a8'),
    ('a47f1ef4-1017-43c1-bf36-67f57376d163','Norfolk District','NAO','973ad07b-7df3-4a95-9e43-7bc25930f7a8'),
    ('1989e3fc-f12a-42da-a263-c3ae978e2c09','Philadelphia District','NAP','973ad07b-7df3-4a95-9e43-7bc25930f7a8'),
    ('ad713a67-37d6-444e-b6b6-e02c0858451f','Northwestern Division','NWD',Null),
    ('5b35ea7c-8d1b-481a-956b-b32939093db4','Kansas City District','NWK','ad713a67-37d6-444e-b6b6-e02c0858451f'),
    ('665ffb00-ccba-488c-83c5-2083543cacd7','Omaha District','NWO','ad713a67-37d6-444e-b6b6-e02c0858451f'),
    ('8b0a732d-d511-4332-b2e7-dd6943a597e9','Portland District','NWP','ad713a67-37d6-444e-b6b6-e02c0858451f'),
    ('007cbff5-6946-4b9b-a3f7-0bef4406f122','Seattle District','NWS','ad713a67-37d6-444e-b6b6-e02c0858451f'),
    ('30266178-d32a-4e07-aea1-1f7182ed245e','Walla Walla District','NWW','ad713a67-37d6-444e-b6b6-e02c0858451f'),
    ('ab99f33f-836e-4788-a931-33e0376d1406','Pacific Ocean Division','POD',Null),
    ('be0614bf-1461-4993-9ce7-8d1d17606be9','Alaska District','POA','ab99f33f-836e-4788-a931-33e0376d1406'),
    ('64cd2766-2586-4709-a4b9-f8a6029233ea','Far East District','POF','ab99f33f-836e-4788-a931-33e0376d1406'),
    ('8b86f8cb-0594-4d69-a66c-e4e295c2b5af','Honolulu District','POH','ab99f33f-836e-4788-a931-33e0376d1406'),
    ('f7300efc-ff48-44fd-b43f-b5373a42ba3e','Japan Engineer District','POJ','ab99f33f-836e-4788-a931-33e0376d1406'),
    ('e046baab-c0b6-4dcf-8cc7-cbab155dddc0','South Atlantic Division','SAD',Null),
    ('d4501358-1c48-45cb-86f3-f1a31e9bd93f','Charleston District','SAC','e046baab-c0b6-4dcf-8cc7-cbab155dddc0'),
    ('b4f45596-70e5-4a12-a894-a64300648244','Jacksonville District','SAJ','e046baab-c0b6-4dcf-8cc7-cbab155dddc0'),
    ('9ffc189c-ad40-4fbf-bc06-2098c6cb920e','Mobile District','SAM','e046baab-c0b6-4dcf-8cc7-cbab155dddc0'),
    ('0154184e-2509-4485-b449-8eff4ab52eef','Savannah District','SAS','e046baab-c0b6-4dcf-8cc7-cbab155dddc0'),
    ('ba1f7846-43d9-4a21-9876-27c59510d9c0','Wilmington District','SAW','e046baab-c0b6-4dcf-8cc7-cbab155dddc0'),
    ('f92cb397-2c8c-44f1-856d-a00ef9467224','South Pacific Division','SPD',Null),
    ('11b5fe49-fe36-4a06-a0da-d55b1b62b1fb','Albuquerque District','SPA','f92cb397-2c8c-44f1-856d-a00ef9467224'),
    ('b8cec5bc-f975-4bed-993d-8f913ca51673','Los Angeles District','SPL','f92cb397-2c8c-44f1-856d-a00ef9467224'),
    ('ff52a84b-356a-4173-a8df-89a1b408d354','Sacramento District','SPK','f92cb397-2c8c-44f1-856d-a00ef9467224'),
    ('cf9b1f4d-1cd3-4a00-b73d-b6f8fe75915e','San Francisco District','SPN','f92cb397-2c8c-44f1-856d-a00ef9467224'),
    ('2176fa5b-7d6f-4f73-8dc3-18e2323aefbb','Southwestern Division','SWD',Null),
    ('f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d','Fort Worth District','SWF','2176fa5b-7d6f-4f73-8dc3-18e2323aefbb'),
    ('72ee5695-cdaa-4182-b0c1-4d27f1a3f570','Galveston District','SWG','2176fa5b-7d6f-4f73-8dc3-18e2323aefbb'),
    ('131daa5c-49c2-4488-be6b-bd638a83a03f','Little Rock District','SWL','2176fa5b-7d6f-4f73-8dc3-18e2323aefbb'),
    ('fe29f6e2-e200-44a4-9545-a4680ab9366e','Tulsa District','SWT','2176fa5b-7d6f-4f73-8dc3-18e2323aefbb'),
    ('93d10e29-9833-4676-a447-1d2a20845ca3','Transatlantic Division','TAD',Null),
    ('22a14be1-c5ad-4ec8-9820-c2f0f09cc00f','Middle East District','TAM','93d10e29-9833-4676-a447-1d2a20845ca3'),
    ('ad667c3d-59de-47cc-81f0-7d55eae779d9','Engineering Research and Development Center', 'ERDC', Null),
    ('9f7be684-bd9e-4784-8282-2694a6e938a2','Coastal and Hydraulics Laboratory', 'CHL', 'ad667c3d-59de-47cc-81f0-7d55eae779d9'),
    ('2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26','Cold Regions Research and Engineering Laboratory', 'CRREL', 'ad667c3d-59de-47cc-81f0-7d55eae779d9'),
    ('90dc9bd7-8360-420a-aaa2-a056e09f54ad','Environmental Laboratory', 'EL', 'ad667c3d-59de-47cc-81f0-7d55eae779d9'),
    ('2fc76e25-707b-4d4b-a745-186e9fa4ba40','Institute for Water Resources', 'IWR', Null),
    ('2822b938-f7c8-420b-89a2-201268cf472b','Hydrologic Engineering Center', 'HEC', '2fc76e25-707b-4d4b-a745-186e9fa4ba40'),
    ('cd7a8f3b-fb86-413e-8a74-103295d72bce','Risk Management Center', 'RMC', '2fc76e25-707b-4d4b-a745-186e9fa4ba40'),
    ('c9079091-7554-4008-bb9c-2e9b9f414472','Modeling, Mapping, and Consequence', 'MMC', Null),
    ('c4cb9f2c-aadc-418f-802c-897797525a1a','Dam Safety Production Center', 'DSPC', Null);

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