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
INSERT INTO occupation_code (id, code, name) VALUES
    ('9d06df4e-ff49-424c-968c-260cefd316c3', '0000', 'Miscellaneous'),
    ('65024666-bf40-448c-993e-4edb10c0fc38', '0099', 'General Student Trainee'),
    ('ba73a77c-61e4-4454-a096-6d1c8eb225ad', '0199', 'Social Science Student Trainee'),
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
    positions_allowed INTEGER NOT NULL DEFAULT 0,
    last_verified date,
    CONSTRAINT unique_office_slug UNIQUE(office_id, slug)
);

-- @todo
-- NEED TO ADD SECTION/GROUP FOR EACH OFFICE FROM SPREADSHEET

INSERT INTO office_group (id, office_id, name, slug, positions_allowed) VALUES
    ('924b819e-4bbb-41bf-a5d7-cbbb94ee2fe9', 'b4f45596-70e5-4a12-a894-a64300648244', 'Water Management Section', 'water-management-section', 8),
    ('cb4091a7-00f8-4178-9922-b23470e34ea9', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Water Management', 'water-management', 9),
    ('18f60b16-bff0-4241-9a72-cb2130aa3f8c', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Water Management', 'water-management', 15),
    ('c39474b9-f1ba-4235-9c0d-82e3f376918d', 'a47f1ef4-1017-43c1-bf36-67f57376d163', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 4),
    ('dc09da99-eccf-4374-941f-892281f36f4e', '7ed4821f-9e37-4c56-8baf-05c1b5bcc84c', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 6),
    ('be35e670-a336-4e9c-a60c-84644a3d1df5', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Water Management Section', 'water-management-section', 9),
    ('ffc8d69c-82d4-46d2-8afe-0d828b3bbc32', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Hydrologic Systems', 'hydrologic-systems', 28),
    ('8c2cc097-b60b-4244-b5b0-4d518314e212', '61291eaf-d62f-4846-ad95-87cc86b56851', 'Pittsburgh District', 'pittsburgh-district', 13),
    ('65617e09-75c8-40df-9d43-1f9385b8c8e2', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Hydrology', 'hydrology', 12),
    ('cbdb5caa-a9f4-4d3b-b9e5-2678877659f2', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Technical Services Section', 'technical-services-section', 12),
    ('e39f1fbd-3a31-491b-a6f8-98fb2a520086', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Hydraulics and Hydrology Section', 'hydraulics-and-hydrology-section', 11),
    ('40b45b50-9b0c-4a63-8c7f-b11bb4632308', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Water Resources Branch', 'water-resources-branch', 2),
    ('b02a2268-2b8c-4e4e-8757-11ad804834c2', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Flood Risk and Floodplain', 'flood-risk-and-floodplain', 8),
    ('0161a41c-c54d-4f2d-b825-c725e63c15a1', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydraulic Analysis', 'hydraulic-analysis', 12),
    ('6653250c-3bc8-4ee7-94cd-e8f81ce47bd8', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Hydrologic Engineering and Power', 'hydrologic-engineering-and-power', 16),
    ('c06cb41a-5fa8-4e8a-a46a-1c61039b5286', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Hydrologic and River Engineering', 'hydrologic-and-river-engineering', 14),
    ('1aace45c-72cd-430c-a0f9-e6c5b62bd29b', 'ba1f7846-43d9-4a21-9876-27c59510d9c0', 'Hydrology', 'hydrology', 8),
    ('b430e336-463d-460d-9a98-9b91dc04421d', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 11),
    ('7c3b3706-c1ca-404c-a4bf-3093a0b063d1', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Water Management Section', 'water-management-section', 3),
    ('e206c1eb-076a-449c-abe5-12d29bf88a9b', 'cf9b1f4d-1cd3-4a00-b73d-b6f8fe75915e', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 3),
    ('77cc3671-0c61-464b-918f-99e66f0af657', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Water Management', 'water-management', 16),
    ('368efb2f-cf48-4fd3-8187-1c6b79492c5e', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydrology and Hydraulics Branch', 'hydrology-and-hydraulics-branch', 2),
    ('580106e4-1ae2-47db-b6c5-42ef1f359041', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Branch Chief', 'branch-chief', 1),
    ('d67b250d-dbd2-49fe-9eb0-09b179798402', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Reservoir Regulation', 'reservoir-regulation', 14),
    ('24f4879f-7899-48a4-8b60-3ff85fa064d9', '2822b938-f7c8-420b-89a2-201268cf472b', 'Hydrologic Engineering Center', 'hydrologic-engineering-center', 38),
    ('410f174b-65e7-44e9-ab34-1a2b00a60989', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydrology', 'hydrology', 8),
    ('1673cc50-e107-4fe1-b412-05b206b6cb8b', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Water Management', 'water-management', 12),
    ('16427d2c-b3f8-4062-8a97-cddf0cbd609e', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Flood and Storm Protection Division', 'flood-and-storm-protection-division', 2),
    ('f22bc941-dd12-4605-831a-1bdbcaa1ea94', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Flood/Coastaland Nav', 'flood-coastaland-nav', 4),
    ('4f9b7577-6f91-480d-9d34-8c614580ca80', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Executive Office', 'executive-office', 6),
    ('d20b3127-ae9a-45cf-864d-38dd4a069f4c', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydraulics', 'hydraulics', 16),
    ('c3fbe4c6-e7e6-4ad3-ae03-868e3df94f78', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'HH and C Branch', 'hh-and-c-branch', 3),
    ('1e68eb34-9706-4f5e-95de-0a0ea99cb913', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Navigation Branch', 'navigation-branch', 21),
    ('0c5a7161-62e9-4d65-91e1-7158ebe70e5b', '7ed4821f-9e37-4c56-8baf-05c1b5bcc84c', 'Water Management', 'water-management', 7),
    ('12e8d207-c355-4b0f-a370-9bfef8817527', '81557734-7046-4c55-90ac-066dd882166a', 'Rock Island District', 'rock-island-district', 29),
    ('eb6e92f6-706e-4c7c-8af3-f6da18d394b0', '433a554d-7b27-4046-89eb-906788eb4046', 'Louisville District', 'louisville-district', 19),
    ('3c22a93a-3cec-4484-92a1-65288950b816', '973ad07b-7df3-4a95-9e43-7bc25930f7a8', 'North Atlantic Division', 'north-atlantic-division', 1),
    ('7109734e-c6ab-4fef-9e40-29718ebe3841', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Eco System', 'eco-system', 4),
    ('f0e4186b-e4f0-4198-829c-26803d502794', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Hydraulic and Coastal', 'hydraulic-and-coastal', 12),
    ('8584268d-6eb5-4bbe-958d-65c86031efab', 'c4cb9f2c-aadc-418f-802c-897797525a1a', 'Dam Safety Production Center', 'dam-safety-production-center', 5),
    ('62dbe466-4591-4d75-b9f3-0a3e518e2254', '485d800d-a30d-4fcb-af43-0bea2ce11adb', 'Mississippi Value Division', 'mississippi-value-division', 9),
    ('47bbcc4a-16e9-4955-b802-bc6938d51051', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal Engineering', 'coastal-engineering', 22),
    ('2dc31c72-6bb2-4d6b-8171-7922e07d2be5', '665ffb00-ccba-488c-83c5-2083543cacd7', 'River and Reservoir', 'river-and-reservoir', 9),
    ('929f86ac-fa35-49d1-a247-d06be0541f5f', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Harbors, Entrances and Structures', 'harbors-entrances-and-structures', 25),
    ('d07c0e7c-7649-461c-86b4-61c5553a0b68', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Coastal', 'coastal', 3),
    ('14fb6f46-4ef0-41aa-9523-1ffa77875402', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'HandH Branch', 'handh-branch', 1),
    ('2d3704cb-b51b-40bc-a3a0-a444c0436847', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Coastal', 'coastal', 4),
    ('2812dfb5-0a5a-4b55-ae6f-371970a211d0', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Water Management', 'water-management', 7),
    ('e535b8b2-1df8-4a14-bc07-d4172e628893', '1245e3c0-fc72-4621-86b2-24ff7de21f88', 'Memphis District', 'memphis-district', 29),
    ('d13e26e0-b4a1-48bb-bd59-1a5c2c2790b9', 'c9079091-7554-4008-bb9c-2e9b9f414472', 'Modeling, Mapping, and Consequence', 'modeling-mapping-and-consequence', 5),
    ('5a0c240f-c12c-455c-8001-ba7071a5388c', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Hydrology', 'hydrology', 3),
    ('8278a2c8-3f2c-45d0-8c0e-4bf00949883c', 'b9cca282-eb91-4ea1-b075-d067b4420184', 'Vicksburg District', 'vicksburg-district', 37),
    ('fccdeded-3e90-4ef0-84c5-fb4a3829e2af', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Coastal Section', 'coastal-section', 9),
    ('831ed52a-8d9e-4eb7-85b2-ac275814dcfd', 'b4f45596-70e5-4a12-a894-a64300648244', 'Coastal Design Section', 'coastal-design-section', 6),
    ('35ee30f7-dc61-4aed-86b8-394d68fd2485', 'b4f45596-70e5-4a12-a894-a64300648244', 'Interagency Modeling Section', 'interagency-modeling-section', 5),
    ('e9ecb67c-1fc4-4cf3-8c02-02ac20081d37', '2cf60156-f22a-418a-bc9f-a28960ad0321', 'St. Paul District', 'st-paul-district', 39),
    ('04a699ed-c9ef-4a3b-bba7-0db2821a52af', '30cb06ee-bd94-4c49-a945-e92735e7bdc1', 'Water Management', 'water-management', 9),
    ('26242078-6191-4ccc-8f1b-68fc9e9bfbd4', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Hydrology', 'hydrology', 10),
    ('8f59656c-c756-4732-9be7-1d348c30c37e', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('0d016f36-e2ad-42ee-911b-747e270df464', 'a8192ad1-206c-4da6-b19e-b7ba7a67aa1f', 'Detroit District', 'detroit-district', 24),
    ('2ec65aa3-f4ec-40e2-b05f-74b6b80d87f4', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Hydraulics', 'hydraulics', 9),
    ('a68a006b-ca6c-4005-998a-5a8921318258', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Regional Business Technical (EandC)', 'regional-business-technical-eandc', 1),
    ('e28ba7e3-ccc7-44ad-b570-e050d5009978', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydraulics Design', 'hydraulics-design', 9),
    ('2de54f1c-4d97-4ed6-a15c-075f4324caa7', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Water Resources Branch', 'water-resources-branch', 3),
    ('739eb72b-7081-4ece-bf75-0c9165299ab9', '565be474-0c68-44a6-8e66-b833a39685bd', 'St. Louis District', 'st-louis-district', 37),
    ('a96cdf2c-9d2d-4877-a8bc-0887a1c7cc6b', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Branch Chief', 'branch-chief', 1),
    ('8eb1840c-aa87-423e-9a6f-f9f4d0384d70', 'b4f45596-70e5-4a12-a894-a64300648244', 'Water Resources Engineering Branch', 'water-resources-engineering-branch', 6),
    ('fba1d489-4f30-4433-851d-4ce3e1ed1217', 'e046baab-c0b6-4dcf-8cc7-cbab155dddc0', 'Hydraulics andHydrology', 'hydraulics-andhydrology', 2),
    ('b7b91942-72b6-432e-9195-3222d7d2aaf7', '1989e3fc-f12a-42da-a263-c3ae978e2c09', 'Northern Area Office', 'northern-area-office', 1),
    ('fb250933-2702-473e-beff-4b9d8f2bdeac', '2176fa5b-7d6f-4f73-8dc3-18e2323aefbb', 'Watershed Team', 'watershed-team', 3),
    ('0cd689a7-02d9-4684-afc0-2c9b89a0e4b4', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Missouri River Water Management', 'missouri-river-water-management', 11),
    ('dc3d43ad-5f01-4064-a723-5576056cb144', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Hydraulics', 'hydraulics', 10),
    ('91513ef4-b58b-4cd6-82b1-e0a84abc616a', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'HHandC Branch', 'hhandc-branch', 1),
    ('d4a95ea1-47de-40b4-acc6-deb334fa23c0', 'd4501358-1c48-45cb-86f3-f1a31e9bd93f', 'General Engineering', 'general-engineering', 1),
    ('f2f77e69-e1fd-4bc7-93d3-d694a649a0b3', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'River and Estuarine', 'river-and-estuarine', 31),
    ('c17373bb-67ad-4b61-82aa-79bcacfb0826', '2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26', 'Ice Engineering', 'ice-engineering', 4),
    ('e4693588-6c47-4da0-9144-42b03b760cac', 'ba1f7846-43d9-4a21-9876-27c59510d9c0', 'Hydraulics', 'hydraulics', 1),
    ('52a059a3-e02a-4629-8ae4-9b9bcd123848', 'f92cb397-2c8c-44f1-856d-a00ef9467224', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('47cc9bfd-3da4-4053-a469-290b0c53a8b5', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 10),
    ('c94192a8-a07f-4476-ba06-00180759f488', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'Hydraulics and Hydrology Section', 'hydraulics-and-hydrology-section', 7),
    ('50ce6db3-12cc-47bb-bd27-3fec30078113', '552e59f7-c0cc-4689-8a4d-e791c028430a', 'Nashville District', 'nashville-district', 25),
    ('bc31f3f9-8109-4fe5-a129-76238732e18e', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal Observations and Analysis', 'coastal-observations-and-analysis', 24),
    ('5afa0b92-4867-48e9-9730-5c664fa018d5', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', 'Huntington District', 'huntington-district', 20),
    ('a2ec991e-7d95-4dd4-a6f0-72034c9eb2fa', 'f81f5659-ce57-4c87-9c7a-0d685a983bfd', 'New Orleans District', 'new-orleans-district', 32),
    ('97222fc1-f040-4270-bab2-d713bed18ea6', 'b4f45596-70e5-4a12-a894-a64300648244', 'Hydrologic Modeling Section', 'hydrologic-modeling-section', 11),
    ('bb2c0d3e-2622-42c7-bb43-e1a0896f6d8f', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Water Management Section', 'water-management-section', 15),
    ('342fc32c-2e1b-4f86-9694-470f089b2fde', '11b5fe49-fe36-4a06-a0da-d55b1b62b1fb', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 11),
    ('5af968e9-8228-46d5-bf37-1454a07e7cec', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Reservoir Control Center', 'reservoir-control-center', 13),
    ('8cfcd018-8e8b-4e4b-8025-a815ddf21ed7', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Columbia River Water Management', 'columbia-river-water-management', 4),
    ('f79df5ca-403a-48e2-a8b6-ea9d6e276bb4', 'be0614bf-1461-4993-9ce7-8d1d17606be9', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 6),
    ('adc92cb4-90a0-4fb3-982e-88196cb67e7c', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal Processes', 'coastal-processes', 27),
    ('d547a43e-7fc9-44f0-a58c-78c562e21766', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'River Engineering and Restoration', 'river-engineering-and-restoration', 12),
    ('5b16bc39-b601-4322-ab69-d327b7f7d4f9', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydrology', 'hydrology', 10),
    ('88d9c769-9a86-4eff-991d-f93bad287244', 'ab99f33f-836e-4788-a931-33e0376d1406', 'CW Integration Division', 'cw-integration-division', 3),
    ('fbbff588-6ba7-4055-8879-0fb0c9a9dbe0', '0154184e-2509-4485-b449-8eff4ab52eef', 'Hydrology and Hydraulics Branch', 'hydrology-and-hydraulics-branch', 9),
    ('ba79fe24-f832-4f9f-a54c-4e585124f951', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'Water Management Section', 'water-management-section', 8),
    ('28a5061b-1a2f-4d86-bda3-d216e8ebadaa', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Hydrology, Hydraulics and Coastal', 'hydrology-hydraulics-and-coastal', 13),
    ('67dd8f50-940e-4b7a-a96c-8edbac53b20b', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'HandH Branch', 'handh-branch', 1),
    ('c5c1b16a-d5fd-4d23-9a5e-05e646d9bb8b', '1989e3fc-f12a-42da-a263-c3ae978e2c09', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 12),
    ('d2833004-e2ec-45af-b066-824e4bedd00b', 'cd7a8f3b-fb86-413e-8a74-103295d72bce', 'Risk Management Center', 'risk-management-center', 14),
    ('b22ddc81-026a-44c8-b64f-a9eb3cbc3965', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Water Management', 'water-management', 8),
    ('cb3f989e-dd7f-43d4-91dd-24d4b518ece0', 'd8f8934d-e414-499d-bd51-bc93bbde6345', 'Chicago District', 'chicago-district', 7),
    ('8d359bab-588d-48a4-b448-494b387e7c66', '8b86f8cb-0594-4d69-a66c-e4e295c2b5af', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 10),
    ('ed4942bc-756c-4559-8183-da070cd28e37', '30cb06ee-bd94-4c49-a945-e92735e7bdc1', 'Reservoir Regulation', 'reservoir-regulation', 6),
    ('fe29642b-6367-49e2-b010-cde9eca8ec99', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Hydraulics', 'hydraulics', 9),
    ('0d0bb738-6c29-4aef-8b09-706cbb65c080', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Omaha District', 'omaha-district', 4),
    ('408fcad5-c6e6-4c30-8802-0b85a1ed35b5', '90dc9bd7-8360-420a-aaa2-a056e09f54ad', 'Environmental Laboratory', 'environmental-laboratory', 33),
    ('6108a7b8-a80b-400a-9e69-2d66c462e12b', '91cf44dc-6384-4622-bd9f-0f36e4343413', 'Great Lakes/Ohio River Division', 'great-lakes-ohio-river-division', 10),
    ('ecae9af9-2364-4353-a0ed-e62850bdfc4a', 'b4f45596-70e5-4a12-a894-a64300648244', 'Hydraulic Design Section', 'hydraulic-design-section', 9),
    ('29a619e7-4685-4cc8-8dac-f4a6358caf89', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Technical Programs', 'technical-programs', 9),
    ('a6ac4311-83c8-4ce4-a398-e25c194a69a5', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Field Data and Analysis', 'field-data-and-analysis', 25),
    ('12c009e2-8bc6-464e-8128-d65bdeddb0b1', '17fa25b8-44a0-4e6d-9679-bdf6b0ee6b1a', 'Buffalo District', 'buffalo-district', 14),
    ('8c4e3ccb-06fd-486f-988c-8d083712199c', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydrology and Hydraulics Branch', 'hydrology-and-hydraulics-branch', 1),
    ('b94907e8-e428-40d4-8ac3-df211ca67712', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Navigation Division', 'navigation-division', 1),
    ('bc3f4fa6-2968-4463-befa-4eb898b72b92', '11b5fe49-fe36-4a06-a0da-d55b1b62b1fb', 'Water Management', 'water-management', 12),
    ('7ccebe88-5166-4755-baab-089b4d3131ef', 'e687330e-3890-4a2f-b666-faf55929dc64', 'Headquarters', 'headquarters', 4),
    ('58c0b5b4-8b18-450f-883a-84b9e093cd4e', '2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26', 'Water Resources-GIS', 'water-resources-gis', 12);


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