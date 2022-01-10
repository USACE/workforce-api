-- occupancy
INSERT INTO occupancy (id,position_id,title,start_date,end_date,service_start_date,service_end_date,dob) VALUES
('a119ad8a-2b94-4d8f-a3c9-b985904e6f69','6ce9f21b-3722-4fdf-b72c-a028d7201ec6','Occupancy Title','2005-10-20',NULL,'2001-10-20',NULL,'1990-03-01'),
('f3a3cd1a-97c5-47a0-840a-3be45fae2bc7','6ce9f21b-3722-4fdf-b72c-a028d7201ec6','Occupancy Title','2020-04-01','2021-04-01','1990-04-16',NULL,'1970-07-01'),
('868c4d93-9597-4b5e-9165-ffe6fed4eb6a','6ce9f21b-3722-4fdf-b72c-a028d7201ec6','Occupancy Title','2020-05-20','2021-04-01','2020-05-20',NULL,'1970-07-01'),
('2adfdf26-9f07-45e7-9dd6-cb86e92fc0c6','6ce9f21b-3722-4fdf-b72c-a028d7201ec6','Occupancy Title','2020-01-01','2020-09-20','2020-01-01','2020-09-20','1990-03-15');

--occupant_credentials
INSERT INTO occupant_credentials VALUES
('2adfdf26-9f07-45e7-9dd6-cb86e92fc0c6','00f6fa8a-c7d9-4ddf-9bc6-7d1ef6f1272f'),
('a119ad8a-2b94-4d8f-a3c9-b985904e6f69','e4e8cf08-7571-47c8-8451-ff4a010e0056'),
('a119ad8a-2b94-4d8f-a3c9-b985904e6f69','73fe40cf-3f9c-4def-9285-4825ba98cccf'),
('a119ad8a-2b94-4d8f-a3c9-b985904e6f69','d0fa88f2-72df-4d30-a5c4-a7db416d0ede'),
('f3a3cd1a-97c5-47a0-840a-3be45fae2bc7','73fe40cf-3f9c-4def-9285-4825ba98cccf'),
('f3a3cd1a-97c5-47a0-840a-3be45fae2bc7','6418cc3c-954b-482f-95d5-a57049e5f718');
