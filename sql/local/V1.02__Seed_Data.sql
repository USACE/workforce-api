
-- position
INSERT INTO position (id, occupation_code_id, title, office_id, pay_plan_id, grade, is_supervisor) VALUES
    ('a25c9ec2-fc14-4f7e-bde3-177fa9de4208', 'dc091470-ccc2-4f12-b3cf-6a9bf71f8238', 'Supervisory Hydraulic Engineer', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', '24533fd9-6158-422f-b1bc-94d5779bd2aa', 13, TRUE),
    ('45eefa59-a7d8-4c24-b509-0bc752ef6a2b', 'dc091470-ccc2-4f12-b3cf-6a9bf71f8238', 'Hydraulic Engineer', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', '24533fd9-6158-422f-b1bc-94d5779bd2aa', 12, FALSE),
    ('d485b403-20c9-4651-b78d-4a08d0a5f5ba', 'dc091470-ccc2-4f12-b3cf-6a9bf71f8238', 'Hydraulic Engineer', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', '24533fd9-6158-422f-b1bc-94d5779bd2aa', 9,  FALSE),
    ('0097ee0f-428c-4fd0-9782-8a6e36d47e60', 'dc091470-ccc2-4f12-b3cf-6a9bf71f8238', 'Hydraulic Engineer', '2f160ba7-fd5f-4716-8ced-4a29f75065a6', '24533fd9-6158-422f-b1bc-94d5779bd2aa', 11, FALSE);


-- occupancy
INSERT INTO occupancy (id, position_id, title, start_date, end_date, service_start_date, service_end_date, dob) VALUES
('a119ad8a-2b94-4d8f-a3c9-b985904e6f69', 'a25c9ec2-fc14-4f7e-bde3-177fa9de4208', NULL, '2005-10-20', NULL, '2001-10-20', NULL, '1990-03-01'),
('f3a3cd1a-97c5-47a0-840a-3be45fae2bc7', '45eefa59-a7d8-4c24-b509-0bc752ef6a2b', NULL, '2001-10-20', '2020-04-01', '1990-04-16', NULL, '1970-07-01'),
('868c4d93-9597-4b5e-9165-ffe6fed4eb6a', '45eefa59-a7d8-4c24-b509-0bc752ef6a2b', NULL, '2020-05-20', NULL, '2020-05-20', NULL, '1970-07-01'),
('2adfdf26-9f07-45e7-9dd6-cb86e92fc0c6', 'd485b403-20c9-4651-b78d-4a08d0a5f5ba', NULL, '2020-01-01', '2020-09-20', '2020-01-01', '2020-09-20', '1990-03-15');

--occupant_credentials
INSERT INTO occupant_credentials VALUES
('a119ad8a-2b94-4d8f-a3c9-b985904e6f69', 'e4e8cf08-7571-47c8-8451-ff4a010e0056'),
('f3a3cd1a-97c5-47a0-840a-3be45fae2bc7', '73fe40cf-3f9c-4def-9285-4825ba98cccf');
