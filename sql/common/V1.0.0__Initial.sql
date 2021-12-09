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
    ('8c44bda8-cbc7-4348-989d-e3eb2a0148c0', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', 'Water Management', 'water-management'),
    ('45756635-fb9d-4b88-9208-745439dfe1ef', '91cf44dc-6384-4622-bd9f-0f36e4343413', 'Great Lakes/Ohio River Division', 'great-lakes-ohio-river-division'),  -- Generated from spreadsheet this point forward
    ('dac665ad-e890-408a-890e-0a3386580bfb', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Eco System', 'eco-system'),
    ('d58dfa52-4be6-40cb-89cd-ee8c60262da7', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', 'Huntington District', 'huntington-district'),
    ('3db44372-ed02-4b29-8ef6-7695bad62e9f', '552e59f7-c0cc-4689-8a4d-e791c028430a', 'Nashville District', 'nashville-district'),
    ('c98d7593-39a6-404b-ba47-f2fbf6e75c62', '30cb06ee-bd94-4c49-a945-e92735e7bdc1', 'Water Management', 'water-management'),
    ('13451bfe-b414-4d09-ace8-1401751e5195', 'b4f45596-70e5-4a12-a894-a64300648244', 'Hydraulic Design Section', 'hydraulic-design-section'),
    ('f158fa6d-6cae-4a11-9f51-2ba2cd656a6c', '485d800d-a30d-4fcb-af43-0bea2ce11adb', 'Mississippi Value Division', 'mississippi-value-division'),
    ('5ab250de-8fa3-498e-baa4-162fbc1d5c7a', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Navigation Division', 'navigation-division'),
    ('bc393df9-7865-4006-a16c-89f7e0233212', 'f92cb397-2c8c-44f1-856d-a00ef9467224', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('f2c26071-43a3-40e1-968b-ba66f5afd1f4', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Water Management', 'water-management'),
    ('e0070a0a-e248-4d04-ac7f-f1f54cd3a519', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Hydraulic', 'hydraulic'),
    ('3aa351ee-919c-4c24-b4cd-ebd7f1146299', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('81b94919-5fff-4120-ba6b-fe0e729a65b3', 'a8192ad1-206c-4da6-b19e-b7ba7a67aa1f', 'Detroit District', 'detroit-district'),
    ('ac03ccaf-33d0-43de-ad0b-e6528ea0638d', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Branch Chief', 'branch-chief'),
    ('115f4a72-4982-497d-ab3d-199c11dd7184', 'b4f45596-70e5-4a12-a894-a64300648244', 'Jacksonville District', 'jacksonville-district'),
    ('6987b8fc-0457-4740-9205-5f3b2fb7afe8', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'Hydraulic and Hydrology Section', 'hydraulic-and-hydrology-section'),
    ('8c5e2564-5043-4870-8187-966da41ae83b', 'c4cb9f2c-aadc-418f-802c-897797525a1a', 'Dam Safety Production Center', 'dam-safety-production-center'),
    ('707a8ec1-212a-4e5d-9bff-65f972a34a6f', '17fa25b8-44a0-4e6d-9679-bdf6b0ee6b1a', 'Buffalo District', 'buffalo-district'),
    ('f60bfdb9-3e08-4236-a595-a888ffd6260c', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Water Management', 'water-management'),
    ('562a7361-fb9a-4724-96f5-fad8005df5f5', '2822b938-f7c8-420b-89a2-201268cf472b', 'Hydrologic Engineering Center', 'hydrologic-engineering-center'),
    ('c17739b5-3cf3-4bb7-ac95-29a6762769fc', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'MRWM', 'mrwm'),
    ('0657ad65-5d6c-46ef-a0cf-252c524c2d44', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Water Management', 'water-management'),
    ('3d109a0d-26e6-4fc0-8e29-5bff3508e972', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydrology and Hydraulic Branch', 'hydrology-and-hydraulic-branch'),
    ('874a5c38-3286-4885-b545-8d5946e21c9a', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'River and Estuarine', 'river-and-estuarine'),
    ('5913aeb7-2a7f-41eb-bc37-2ab65eaa1974', '1989e3fc-f12a-42da-a263-c3ae978e2c09', 'Northern Area Office', 'northern-area-office'),
    ('096a6bc9-9165-4b0e-987c-e702be77c3b5', 'e046baab-c0b6-4dcf-8cc7-cbab155dddc0', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('e4ac943d-83c5-4f15-b713-4fbedc5ced9e', '1245e3c0-fc72-4621-86b2-24ff7de21f88', 'Memphis District', 'memphis-district'),
    ('f4264446-202b-4728-bcea-aa09c7492430', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Hydrologic Systems', 'hydrologic-systems'),
    ('bddaf4b5-38c1-4cfb-b17c-eef014ad7384', 'b4f45596-70e5-4a12-a894-a64300648244', 'Hydrologic Modeling Section', 'hydrologic-modeling-section'),
    ('e212040b-151d-4eea-8922-2c89d08719e0', '2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26', 'Water Resources/GIS', 'water-resources-gis'),
    ('28677059-3000-42cb-a8ac-14d87c9ff0ec', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Hydraulic', 'hydraulic'),
    ('0b8e835d-c20d-4d1f-8053-3778d7d2299a', '007cbff5-6946-4b9b-a3f7-0bef4406f122', 'Hydrology and Hydraulic Branch', 'hydrology-and-hydraulic-branch'),
    ('5312e9ef-7fbb-44a8-8ce4-39499f9754d0', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Hydraulic and Hydrology Branch', 'hydraulic-and-hydrology-branch'),
    ('e786be38-b207-4322-8e3e-67357c3f5240', '2176fa5b-7d6f-4f73-8dc3-18e2323aefbb', 'Watershed Team', 'watershed-team'),
    ('bfbd716b-2193-46c6-a5e1-210028e7d80b', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'Water Management Section', 'water-management-section'),
    ('c007e796-4159-42e9-9be4-704537ffded8', '433a554d-7b27-4046-89eb-906788eb4046', 'Louisville District', 'louisville-district'),
    ('23d20816-15e0-4ba7-bf46-f281afe8bf2f', 'a47f1ef4-1017-43c1-bf36-67f57376d163', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('d79bee85-acf3-4edd-a985-f3620dced96e', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Water Management Section', 'water-management-section'),
    ('d7f754a2-e8be-4d96-a918-326dc93ea9b1', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydraulic Analysis', 'hydraulic-analysis'),
    ('41dc3189-b945-4331-b808-9a97afbd326f', '565be474-0c68-44a6-8e66-b833a39685bd', 'St. Louis District', 'st-louis-district'),
    ('d4687912-fed9-44ee-ad2d-2aad388dc8ef', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydraulic Design', 'hydraulic-design'),
    ('1bcb211f-a131-4de9-ad9d-85c2ace4f7ef', '7ed4821f-9e37-4c56-8baf-05c1b5bcc84c', 'Water Management', 'water-management'),
    ('e5d7c8a7-90bc-42ea-b7c3-b029f0b36f79', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Hydraulic and Hydrology Section', 'hydraulic-and-hydrology-section'),
    ('31414045-98a4-46cb-922a-02cc0def7c82', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Hydrology', 'hydrology'),
    ('e9fb6438-af48-4be7-b4c4-a33bf68699a1', 'b4f45596-70e5-4a12-a894-a64300648244', 'Water Resources Engineering Branch', 'water-resources-engineering-branch'),
    ('160736a4-b898-425a-a2d0-ed450d5a6504', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Reservoir Control Center', 'reservoir-control-center'),
    ('abaf7c3a-7143-4f79-8e3f-4b4e23be1408', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Water Management Section', 'water-management-section'),
    ('bfcf9125-7ee7-4ca9-ac11-fbe17abde234', 'f81f5659-ce57-4c87-9c7a-0d685a983bfd', 'New Orleans District', 'new-orleans-district'),
    ('5ab3c7a8-edd2-4c8c-adf8-89df129fe8f2', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Hydrology, Hydraulic and Coastal', 'hydrology-hydraulic-and-coastal'),
    ('b5a3a353-1e3f-488f-8650-9b44cb9c1984', '9ffc189c-ad40-4fbf-bc06-2098c6cb920e', 'Water Resources Branch', 'water-resources-branch'),
    ('4f6898b8-b714-4f19-98db-c2a89c4ef610', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Executive Office', 'executive-office'),
    ('14e7ea14-8fe9-4a83-a794-9d686cf5932b', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Hydrology', 'hydrology'),
    ('f8adf3f9-984b-46b8-9429-1410d4d008e7', '61291eaf-d62f-4846-ad95-87cc86b56851', 'Pittsburgh District', 'pittsburgh-district'),
    ('073e77c9-b2fd-4f20-8afc-a55faccdbb5a', '131daa5c-49c2-4488-be6b-bd638a83a03f', 'Hydraulic and Hydrology Branch', 'hydraulic-and-hydrology-branch'),
    ('d08e8aa6-1665-4188-a5d4-5872158bffbc', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('282f274d-1d2b-4991-b6b5-3dadbf0c2dee', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'Flood', 'flood'),
    ('962d8d2f-cce1-40c8-8796-0f6820ed6460', '0154184e-2509-4485-b449-8eff4ab52eef', 'Hydrology and Hydraulic Branch', 'hydrology-and-hydraulic-branch'),
    ('4f6dbbff-2481-4e2d-92c9-55b11c5fed29', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Hydrologic Engineering and Power Branch', 'hydrologic-engineering-and-power-branch'),
    ('82c57998-b4d0-44c6-b776-c1afbe40c971', 'e687330e-3890-4a2f-b666-faf55929dc64', 'Headquarters', 'headquarters'),
    ('2cebb9a1-0d88-4404-abee-b678688cbac4', '7ed4821f-9e37-4c56-8baf-05c1b5bcc84c', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('222841bc-2961-4d7f-9a41-634def716644', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydrology', 'hydrology'),
    ('66493baa-4869-4938-ac46-8ad090cabbfc', 'd4501358-1c48-45cb-86f3-f1a31e9bd93f', 'General Engineering', 'general-engineering'),
    ('969ebb66-8c32-406b-be95-e9912523fe94', 'b9cca282-eb91-4ea1-b075-d067b4420184', 'Vicksburg District', 'vicksburg-district'),
    ('0efd7e95-4ac4-4b17-9ccc-07ef9b224bbc', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Hydraulic and Coastal', 'hydraulic-and-coastal'),
    ('e30fd884-08ac-46ef-9b0b-aab1f5e8ee97', '973ad07b-7df3-4a95-9e43-7bc25930f7a8', 'North Atlantic Division', 'north-atlantic-division'),
    ('cc8cee9d-39a8-4df0-9ef0-7a0922ee815b', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Water Management', 'water-management'),
    ('d578517d-6e1a-48d7-aa41-27dad4bc40e9', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Technical Services Section', 'technical-services-section'),
    ('9b70b2e6-2945-49cf-88ea-851e819419e6', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Flood Risk and Floodplain', 'flood-risk-and-floodplain'),
    ('b597ae3f-50c5-4c51-9ee8-4f2ec9bc4b78', '4ca9e255-8a88-44d3-8091-bb61931e600c', 'New York District', 'new-york-district'),
    ('81f82f17-ac0f-410b-bd94-def745712bc2', '665ffb00-ccba-488c-83c5-2083543cacd7', 'River and Reservoir', 'river-and-reservoir'),
    ('4365be74-179e-4cb6-ae2e-ce90336eef90', 'cf9b1f4d-1cd3-4a00-b73d-b6f8fe75915e', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('0846d6b0-dd21-48be-a98a-27ef5ff6a933', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Flood and Storm Protection Division', 'flood-and-storm-protection-division'),
    ('a427e462-7d69-4067-83ba-d2cb09a51278', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Reservoir Regulation', 'reservoir-regulation'),
    ('c7defd51-ae86-4440-a24f-b9616a789f64', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'HH and C Branch', 'hh-and-c-branch'),
    ('daaff576-c4b7-4424-9074-2429c5b765f5', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Field Data and Analysis', 'field-data-and-analysis'),
    ('e9f43913-d42f-4f4b-8dca-1894fe24c768', 'b4f45596-70e5-4a12-a894-a64300648244', 'Interagency Modeling Section', 'interagency-modeling-section'),
    ('a82ff09d-82da-4046-9b35-98abb3dd6aa4', 'ab99f33f-836e-4788-a931-33e0376d1406', 'CW Integration Division', 'cw-integration-division'),
    ('bd850da4-9547-40d6-8ee5-e7a45d94eb4a', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Technical Programs', 'technical-programs'),
    ('dd145493-bb1c-40ef-99a4-0b27aa835c6e', 'b4f45596-70e5-4a12-a894-a64300648244', 'Water Management Section', 'water-management-section'),
    ('fe3eb2c8-420c-49cd-865d-0367db73f6a8', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('b9fb3a7d-e67c-42b5-97ea-3408f86c101e', '8b0a732d-d511-4332-b2e7-dd6943a597e9', 'Hydrologic and River Engineering', 'hydrologic-and-river-engineering'),
    ('5074c29b-447e-408f-96d4-1e55d9a53335', '1989e3fc-f12a-42da-a263-c3ae978e2c09', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('af12245a-420f-4702-a902-d3479f412b3c', 'be0614bf-1461-4993-9ce7-8d1d17606be9', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('9169c76d-a968-422a-b0c4-75fc979f000f', '2cf60156-f22a-418a-bc9f-a28960ad0321', 'St. Paul District', 'st-paul-district'),
    ('b0970149-4524-473b-9d2e-1b70412930c1', 'ba1f7846-43d9-4a21-9876-27c59510d9c0', 'Hydrology', 'hydrology'),
    ('4a901b60-4a05-4ef7-aaa4-adb0febee9e3', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydraulic', 'hydraulic'),
    ('258b7cd7-900d-4c17-998c-14880855040e', '30266178-d32a-4e07-aea1-1f7182ed245e', 'Hydrology and Hydraulic Branch', 'hydrology-and-hydraulic-branch'),
    ('3f8fff99-c521-4ce4-8d23-9e26d34916a7', '30cb06ee-bd94-4c49-a945-e92735e7bdc1', 'Reservoir Regulation', 'reservoir-regulation'),
    ('0e7c4151-0599-4c26-ac76-aa0c48214254', 'c9079091-7554-4008-bb9c-2e9b9f414472', 'Modeling, Mapping, and Consequence', 'modeling-mapping-and-consequence'),
    ('e46f9c07-064f-4129-997b-a92a62979d93', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Water Management', 'water-management'),
    ('e3c50114-0876-4f90-955b-1b0e19c9935b', '81557734-7046-4c55-90ac-066dd882166a', 'Rock Island District', 'rock-island-district'),
    ('ed0cd451-2c58-4553-8da2-b3f5ee7ad279', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'CBWM', 'cbwm'),
    ('7785b739-9572-4b60-a9d2-b6907ddd39d6', '72ee5695-cdaa-4182-b0c1-4d27f1a3f570', 'Galveston District', 'galveston-district'),
    ('7bd53c19-d8f8-4a7f-bc62-09ae39c67c5d', 'fe29f6e2-e200-44a4-9545-a4680ab9366e', 'Water Management Section', 'water-management-section'),
    ('05811915-c4ea-4ad6-97e2-c1cb53483a3e', '2f4ad9c7-4b82-4f29-ab4e-56c6458e9f26', 'Ice Engineering', 'ice-engineering'),
    ('2cf2a9e2-9358-4ae6-929b-56f2aab85064', 'd8f8934d-e414-499d-bd51-bc93bbde6345', 'Chicago District', 'chicago-district'),
    ('c2e5c0cd-0058-47c0-8827-d1f67fc76dfb', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'River Engineering and Restoration', 'river-engineering-and-restoration'),
    ('1604ca64-415e-48ea-9e1f-291bcb274533', '11b5fe49-fe36-4a06-a0da-d55b1b62b1fb', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('bc0b63fc-83ad-485a-a637-0918f3ae284d', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Hydrology', 'hydrology'),
    ('aa7a85d8-4b5f-46ba-b1bc-46cabe7132d0', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Coastal and Hydraulics Laboratory', 'coastal-and-hydraulics-laboratory'),
    ('1c28fdc3-8d3c-4a2c-a2e4-6d971bd58b00', '8b86f8cb-0594-4d69-a66c-e4e295c2b5af', 'Hydraulic and Hydrology', 'hydraulic-and-hydrology'),
    ('de3c4db9-9885-4675-b74f-fcbc4bd6ff9d', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Hydraulic', 'hydraulic'),
    ('c57c88a1-5256-48f7-89c2-4eb4d858fcf9', 'f3f0d7ff-19b6-4167-a3f1-5c04f5a0fe4d', 'Water Resources Branch', 'water-resources-branch'),
    ('72dc6f5c-4976-4fca-a91e-01b266faa64f', 'cd7a8f3b-fb86-413e-8a74-103295d72bce', 'Risk Management Center', 'risk-management-center'),
    ('60e842da-08f5-45f9-be9a-6ab368438d61', 'ad713a67-37d6-444e-b6b6-e02c0858451f', 'Regional Business Technical', 'regional-business-technical'),
    ('2210df16-7777-4c32-973a-a97c4e8e276e', '11b5fe49-fe36-4a06-a0da-d55b1b62b1fb', 'Water Management', 'water-management'),
    ('9e609d9c-cadc-4a81-9338-47a3cff60df6', 'ff52a84b-356a-4173-a8df-89a1b408d354', 'Hydrology', 'hydrology'),
    ('6538a924-285c-4652-9e46-c724d45cd018', '90dc9bd7-8360-420a-aaa2-a056e09f54ad', 'Environmental Laboratory', 'environmental-laboratory'),
    ('83e0dbda-92e4-4b11-b932-e3ec9a46c48c', '665ffb00-ccba-488c-83c5-2083543cacd7', 'Branch Chief', 'branch-chief'),
    ('efd72d0c-0922-4b5e-b08d-8962b683ca2c', 'b8cec5bc-f975-4bed-993d-8f913ca51673', 'Water Management', 'water-management'),
    ('e1f6bd25-27a1-443a-8f2f-1a4af770b011', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Navigation Branch', 'navigation-branch'),
    ('7cfc9b3c-0acd-4f87-9d6c-7893eec01ca9', '5b35ea7c-8d1b-481a-956b-b32939093db4', 'Branch Chief', 'branch-chief'),
    ('1fd867cf-2314-4e05-9550-0cb9131152c6', '9f7be684-bd9e-4784-8282-2694a6e938a2', 'Harbors, Entrances and Structures', 'harbors-entrances-and-structures');


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