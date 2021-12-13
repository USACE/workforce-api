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
    ('c5fbbb80-3cb5-4407-a8b0-d5fd105714fc', '552e59f7-c0cc-4689-8a4d-e791c028430a', 'Water Resources', 'water-resources', 0),
    ('5db16a83-f38b-4a16-8aa1-ea1175c6003e', '552e59f7-c0cc-4689-8a4d-e791c028430a', 'Water Management', 'water-management', 0),
    ('8c44bda8-cbc7-4348-989d-e3eb2a0148c0', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', 'Water Management', 'water-management', 0),  -- Original
    ('3da14245-25d8-4149-baf9-560086968282', '1989e3fc-f12a-42da-a263-c3ae978e2c09', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('a5eb9397-5672-46e1-8cef-ac5d0897870a', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Hydraulics', 'hydraulics', 1),
    ('4d6ab9e8-bece-405c-bf8f-8deff53321ed', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Navigation Branch', 'navigation-branch', 1),
    ('357f0fd5-8792-4613-beb5-74837816df38', '81557734-7046-4c55-90ac-066dd882166a', 'Rock Island District', 'rock-island-district', 1),
    ('01bf17da-af64-4fae-ac62-049d3eef0808', '17fa25b8-44a0-4e6d-9679-bdf6b0ee6b1a', 'Buffalo District', 'buffalo-district', 1),
    ('602bcf70-f609-4cf0-8c5d-448d8dc59d8e', 'ab99f33f-836e-4788-a931-33e0376d1406', 'CW Integration Division', 'cw-integration-division', 1),
    ('2b345e7a-e419-4382-b9ea-b20abe541982', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Water Management Section', 'water-management-section', 1),
    ('cdf92a44-c9ff-4da3-9b67-e42d23a7b410', '973ad07b-7df3-4a95-9e43-7bc25930f7a8', 'North Atlantic Division', 'north-atlantic-division', 1),
    ('40fc3945-aec1-42dd-8068-f213e3e8bacb', 'b4f45596-70e5-4a12-a894-a64300648244', 'Hydrologic Modeling Section', 'hydrologic-modeling-section', 1),
    ('969fb46c-917e-462e-b584-eba320641746', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'River Engineering and Restoration', 'river-engineering-and-restoration', 1),
    ('1e05fcb6-3aa3-4443-96dc-4e6259666874', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('d683725c-21cb-4410-8d8e-216787fa57d8', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydraulics', 'hydraulics', 1),
    ('00a8eeff-c285-4a8a-8fcf-549bf49f5f43', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Hydrology, Hydraulics and Coastal', 'hydrology-hydraulics-and-coastal', 1),
    ('8f77f7bb-a796-4486-a45e-0547f12cdcad', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Hydrology', 'hydrology', 1),
    ('e30c4ce6-6252-4821-aff8-1c1a3759179a', '30cb06ee-bd94-4c49-a945-e92735e7bdc1', 'Water Management', 'water-management', 1),
    ('16c6d131-e5dc-47d5-8758-6841f0262661', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Flood/Coastaland Nav', 'flood-coastaland-nav', 1),
    ('fc4abc32-cea3-4454-b1c6-c313f0d7e380', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Water Management', 'water-management', 1),
    ('fe3f69d2-ce8c-46ae-8151-478bea7da383', '2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26', 'Ice Engineering', 'ice-engineering', 1),
    ('b49b43c9-eebd-4813-a008-ea01e4b9d787', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydrology', 'hydrology', 1),
    ('011c2b76-425b-4264-b113-8b2362970fe5', '91cf44dc-6384-4622-bd9f-0f36e4343413', 'Great Lakes/Ohio River Division', 'great-lakes-ohio-river-division', 1),
    ('fcd83add-8dbf-484a-9f23-e19cde85bacf', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydraulics Design', 'hydraulics-design', 1),
    ('db7155d4-657d-4b5e-91ae-42a9c6a33d73', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Water Management', 'water-management', 1),
    ('089d9299-ae93-44d7-9f73-9830f8e15fd0', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Eco System', 'eco-system', 1),
    ('34c293d3-5c3a-4653-84e3-1eb39c3ecb19', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Water Management', 'water-management', 1),
    ('09ee7072-28db-40c1-8c95-494dedc2d7a9', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Water Management', 'water-management', 1),
    ('73339b8d-9444-4182-8db6-83b90acd8b99', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Water Resources Branch', 'water-resources-branch', 1),
    ('3e4bc218-d75b-4aed-9e22-e0fce2bd37b6', '7ed4821f-9e37-4c56-8baf-05c1b5bcc84c', 'Water Management', 'water-management', 1),
    ('f9aefb04-6a32-425d-aa45-aa28bec3d5c3', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Field Data and Analysis', 'field-data-and-analysis', 1),
    ('b82fe5dc-2be6-4ae9-b8ae-e9ca5fa4e38a', '11b5fe49-fe36-4a06-a0da-d55b1b62b1fb', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('90b080d7-2e40-437f-bc9e-0e7d25776bc8', '11b5fe49-fe36-4a06-a0da-d55b1b62b1fb', 'Water Management', 'water-management', 1),
    ('b674d692-ae9e-46b4-a881-e3714581d02c', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Coastal', 'coastal', 1),
    ('c5f65734-a151-493c-a2fa-f94bea5fbc76', 'b4f45596-70e5-4a12-a894-a64300648244', 'Interagency Modeling Section', 'interagency-modeling-section', 1),
    ('0228c09b-36b8-4c8b-a1d1-579d2a774857', 'ba1f7846-43d9-4a21-9876-27c59510d9c0', 'Hydrology', 'hydrology', 1),
    ('87cacc99-2c26-479a-8028-f23d1ffc5eeb', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal Processes', 'coastal-processes', 1),
    ('29b4a5da-d9de-4aa6-bceb-620b73a730c6', '485d800d-a30d-4fcb-af43-0bea2ce11adb', 'Mississippi Value Division', 'mississippi-value-division', 1),
    ('1dabccf5-67d4-4283-8466-c12bd2d70d47', '2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26', 'Water Resources-GIS', 'water-resources-gis', 1),
    ('ca761f02-4827-44f0-9387-f8adfe14e81a', '61291eaf-d62f-4846-ad95-87cc86b56851', 'Pittsburgh District', 'pittsburgh-district', 1),
    ('05dd4473-cbc9-4c13-af58-9b8f1b648797', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'HandH Branch', 'handh-branch', 1),
    ('cdfe3bcc-b849-4343-830f-fd005966d841', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('558c2198-3ac4-499b-950a-11a44e28af02', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Executive Office', 'executive-office', 1),
    ('7f41f9fa-99cb-40d5-86b8-47f8e9151f18', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Technical Programs', 'technical-programs', 1),
    ('9832a0c2-cf5e-4416-895b-d528afd3c954', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Hydraulics and Hydrology Section', 'hydraulics-and-hydrology-section', 1),
    ('034a272e-726a-45fe-9283-5ec8c5c76d8c', '665ffb00-ccba-488c-83c5-2083543cacd7', 'River and Reservoir', 'river-and-reservoir', 1),
    ('140fa540-d5bb-4608-9e70-071f8bb16b61', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Water Management', 'water-management', 1),
    ('8e02d41d-bff9-4deb-ba69-bdd0efc71e5c', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Branch Chief', 'branch-chief', 1),
    ('749180e4-a71c-4169-94b7-0f1556818110', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydrology', 'hydrology', 1),
    ('213db880-a95a-493b-9e32-325c3ebc7896', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'Water Management Section', 'water-management-section', 1),
    ('a0b87dec-41a8-4083-8bc2-d7d8da056e72', 'be0614bf-1461-4993-9ce7-8d1d17606be9', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('0aae52ba-42cf-4250-838f-79de700e4a83', '1989e3fc-f12a-42da-a263-c3ae978e2c09', 'Northern Area Office', 'northern-area-office', 1),
    ('75482c5a-2735-44a4-833a-bdb829f686c7', 'ba1f7846-43d9-4a21-9876-27c59510d9c0', 'Hydraulics', 'hydraulics', 1),
    ('af7dbe0d-d0a9-4da2-8942-c0eeb0b11c1a', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydraulic Analysis', 'hydraulic-analysis', 1),
    ('4aa2c0bb-cd04-440b-8551-7d41fd99bf1e', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Hydraulics', 'hydraulics', 1),
    ('1d0f6152-dd38-414d-a53a-be2da279ae06', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal Observations and Analysis', 'coastal-observations-and-analysis', 1),
    ('9ea212dc-d739-44b8-a132-56c40b0137b5', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Flood and Storm Protection Division', 'flood-and-storm-protection-division', 1),
    ('fb46b221-5620-4dd7-8e5e-2489efc556f3', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Harbors, Entrances and Structures', 'harbors-entrances-and-structures', 1),
    ('b3308ec5-6851-427f-b82c-51963919ea32', 'e046baab-c0b6-4dcf-8cc7-cbab155dddc0', 'Hydraulics andHydrology', 'hydraulics-andhydrology', 1),
    ('dfc73b45-1e2a-4a37-b81d-b384c3cb256f', '552e59f7-c0cc-4689-8a4d-e791c028430a', 'Nashville District', 'nashville-district', 1),
    ('21262a30-f690-4bca-9b72-e234a8293dbc', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydrology and Hydraulics Branch', 'hydrology-and-hydraulics-branch', 1),
    ('8a09ce8e-0989-4d13-8243-d8decf69d6fa', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Coastal', 'coastal', 1),
    ('676380f4-dc5c-41d7-b100-6e77d3352d8c', 'cf9b1f4d-1cd3-4a00-b73d-b6f8fe75915e', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('3f6b8508-63cd-4b6b-a31b-6bfb99619a59', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Regional Business Technical (EandC)', 'regional-business-technical-eandc', 1),
    ('769dff3d-0260-4c0c-9d7e-dfba0d4abc30', 'c9079091-7554-4008-bb9c-2e9b9f414472', 'Modeling, Mapping, and Consequence', 'modeling-mapping-and-consequence', 1),
    ('2733f672-9b50-4816-a6b1-c594503b1854', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Hydraulics', 'hydraulics', 1),
    ('69aae85e-58ed-404a-a01d-0fecdef6b1fb', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Hydrologic Engineering and Power', 'hydrologic-engineering-and-power', 1),
    ('3363255e-3572-4c76-8ea5-4817b6849936', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Water Management', 'water-management', 1),
    ('909d3d2a-6c06-498a-ba0d-6fc5dedad35a', 'e687330e-3890-4a2f-b666-faf55929dc64', 'Headquarters', 'headquarters', 1),
    ('4ec14f70-6c6a-499d-920c-3ed41aba10b1', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Hydrology', 'hydrology', 1),
    ('ee5a3259-f06c-4261-be61-0aa2d5915b3a', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Water Resources Branch', 'water-resources-branch', 1),
    ('c6624d9e-869a-4684-8fee-421514fa1890', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Columbia River Water Management', 'columbia-river-water-management', 1),
    ('f2f10c33-a827-4401-8d48-463618388c4e', 'cd7a8f3b-fb86-413e-8a74-103295d72bce', 'Risk Management Center', 'risk-management-center', 1),
    ('28f40d11-ba55-45f4-b6ea-9ba257d67f76', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Missouri River Water Management', 'missouri-river-water-management', 1),
    ('fb7c5f24-3b92-42cc-8f16-e92cffea76d8', 'b9cca282-eb91-4ea1-b075-d067b4420184', 'Vicksburg District', 'vicksburg-district', 1),
    ('f1b21f43-cfd8-4885-a441-e956fbf6840c', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'HH and C Branch', 'hh-and-c-branch', 1),
    ('45e18bc7-322d-4240-854e-2b7dedbc1ab6', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Water Management Section', 'water-management-section', 1),
    ('614f1ecb-5ea0-46d9-a458-8196bd23f065', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Hydrology', 'hydrology', 1),
    ('a93db621-185f-4223-85c6-e78912a8f041', '90dc9bd7-8360-420a-aaa2-a056e09f54ad', 'Environmental Laboratory', 'environmental-laboratory', 1),
    ('9f77d2ba-9e00-4ec7-a630-1c76f056b1d8', 'f81f5659-ce57-4c87-9c7a-0d685a983bfd', 'New Orleans District', 'new-orleans-district', 1),
    ('92b4e639-9e9d-4ca2-9594-9db1ff728536', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Hydrologic Systems', 'hydrologic-systems', 1),
    ('86be8df8-ea26-482c-b21e-304a0bc3f8f3', '433a554d-7b27-4046-89eb-906788eb4046', 'Louisville District', 'louisville-district', 1),
    ('d2983888-a0bd-4bd9-b909-f50e7ea5fe40', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Hydraulic and Coastal', 'hydraulic-and-coastal', 1),
    ('e002c3f1-1791-4626-82f6-fcf62e48e178', 'a8192ad1-206c-4da6-b19e-b7ba7a67aa1f', 'Detroit District', 'detroit-district', 1),
    ('6ff98b77-81c9-4a47-834a-86269f2c2345', 'b4f45596-70e5-4a12-a894-a64300648244', 'Hydraulic Design Section', 'hydraulic-design-section', 1),
    ('2d9a6f7d-f461-4396-8959-e6f398562330', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydrology and Hydraulics Branch', 'hydrology-and-hydraulics-branch', 1),
    ('73a176aa-eb77-49bb-a5a5-15972c5c4ba4', '7ed4821f-9e37-4c56-8baf-05c1b5bcc84c', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('63636cb5-297a-4cdf-9ddf-c9fa23109d29', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Omaha District', 'omaha-district', 1),
    ('161684d4-892c-42bd-ab6a-1ac123a166d5', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Flood Risk and Floodplain', 'flood-risk-and-floodplain', 1),
    ('892c84f2-b11c-4970-abce-557733a14e45', 'b4f45596-70e5-4a12-a894-a64300648244', 'Water Management Section', 'water-management-section', 1),
    ('7c57ff61-1f77-4f47-9886-aa385f2d96c5', '565be474-0c68-44a6-8e66-b833a39685bd', 'St. Louis District', 'st-louis-district', 1),
    ('086dcadc-84c4-412f-8239-8b075919b8a6', 'f92cb397-2c8c-44f1-856d-a00ef9467224', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('0df5ede7-05ff-43b4-9b3a-76e0cfcac7ca', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Water Management Section', 'water-management-section', 1),
    ('9753efae-907c-4567-88f9-9c6ba5cbdb6c', '8b86f8cb-0594-4d69-a66c-e4e295c2b5af', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('9a2ea8c5-d284-48d4-bdd5-e5f5f9a86161', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Hydrologic and River Engineering', 'hydrologic-and-river-engineering', 1),
    ('d112d329-24ec-4bc6-b06e-f17cf625c7d4', '0154184e-2509-4485-b449-8eff4ab52eef', 'Hydrology and Hydraulics Branch', 'hydrology-and-hydraulics-branch', 1),
    ('30e732e1-15ed-408c-87a7-166ffd1684b2', '2822b938-f7c8-420b-89a2-201268cf472b', 'Hydrologic Engineering Center', 'hydrologic-engineering-center', 1),
    ('7bb4aef2-f443-49e0-b4db-4ec834650f0b', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Reservoir Regulation', 'reservoir-regulation', 1),
    ('153ee393-c618-4047-a1de-37a61693a119', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Navigation Division', 'navigation-division', 1),
    ('9e0682ad-7841-4234-9951-5835325e2bc7', 'd8f8934d-e414-499d-bd51-bc93bbde6345', 'Chicago District', 'chicago-district', 1),
    ('407855ad-d00b-41bc-b42f-be7c66702162', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal Engineering', 'coastal-engineering', 1),
    ('2850316e-d2bb-4e5e-b090-c9405ccdf68d', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Reservoir Control Center', 'reservoir-control-center', 1),
    ('63727fc9-1dce-41dd-b4cf-1c6148e99f19', 'c4cb9f2c-aadc-418f-802c-897797525a1a', 'Dam Safety Production Center', 'dam-safety-production-center', 1),
    ('c8c19f2a-ddc0-42ee-bac4-d7f0303f864d', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Coastal Section', 'coastal-section', 1),
    ('b7c73bf8-c78f-464f-87f4-2abab8fe6410', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('3ce1fa02-c933-49c2-805a-62ef0a5eb053', '1245e3c0-fc72-4621-86b2-24ff7de21f88', 'Memphis District', 'memphis-district', 1),
    ('afc2e0d9-54dc-4f73-bf42-28d864459521', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'River and Estuarine', 'river-and-estuarine', 1),
    ('b909b1b2-e5b5-4cfd-abe1-0be5ab5f4ffc', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Branch Chief', 'branch-chief', 1),
    ('532ce911-bc27-41b2-89d6-8a4221516a90', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', 'Huntington District', 'huntington-district', 1),
    ('b7969e23-eb3e-428f-b125-e00b014d4082', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Technical Services Section', 'technical-services-section', 1),
    ('cd7fa99c-9b8b-42be-b261-a5522480f288', '2cf60156-f22a-418a-bc9f-a28960ad0321', 'St. Paul District', 'st-paul-district', 1),
    ('9bfa3b30-6489-4d29-afa5-e377abbdfdb5', '30cb06ee-bd94-4c49-a945-e92735e7bdc1', 'Reservoir Regulation', 'reservoir-regulation', 1),
    ('29645513-1609-43ef-8048-d320f8cf94dd', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'HandH Branch', 'handh-branch', 1),
    ('7b4b9cab-fce6-47bd-b458-ab91ad1a1ecc', 'b4f45596-70e5-4a12-a894-a64300648244', 'Coastal Design Section', 'coastal-design-section', 1),
    ('e0998428-9c5d-4438-b3e6-189568404032', 'b4f45596-70e5-4a12-a894-a64300648244', 'Water Resources Engineering Branch', 'water-resources-engineering-branch', 1),
    ('8ec0798d-762b-4867-86ac-16e8f8ef1958', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'Hydraulics and Hydrology Section', 'hydraulics-and-hydrology-section', 1),
    ('bf0f3fb7-7026-4427-ac54-50bda64c97ca', '2176fa5b-7d6f-4f73-8dc3-18e2323aefbb', 'Watershed Team', 'watershed-team', 1),
    ('231a5f7b-b522-4f9f-a6a7-78e165b54518', 'a47f1ef4-1017-43c1-bf36-67f57376d163', 'Hydraulics and Hydrology', 'hydraulics-and-hydrology', 1),
    ('3fc833c3-8504-46be-afea-19622effea43', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'HHandC Branch', 'hhandc-branch', 1),
    ('6e5f6ee5-4b29-4329-9ea9-35ce610dc070', 'd4501358-1c48-45cb-86f3-f1a31e9bd93f', 'General Engineering', 'general-engineering', 1);


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