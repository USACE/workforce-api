-- additional certifications/professional creds/degrees
INSERT INTO credential (id, abbrev, name, credential_type_id) VALUES
    ('6418cc3c-954b-482f-95d5-a57049e5f718', 'SP', 'Security+', '3c4a0953-cdf3-49c2-b0a0-2f85906e9214'),
    ('04855e17-6d66-42db-856f-738ede71f8a8', 'NP', 'Network+', '3c4a0953-cdf3-49c2-b0a0-2f85906e9214'),
    ('3245a089-4693-4622-8e59-a28fe70e18fe', 'AP', 'A+', '3c4a0953-cdf3-49c2-b0a0-2f85906e9214'),
    ('00f6fa8a-c7d9-4ddf-9bc6-7d1ef6f1272f', 'GISP', 'Geographic Information Systems Professional', '3c4a0953-cdf3-49c2-b0a0-2f85906e9214'),
    ('f9360ad6-6ce8-40df-9def-24073ed7c03a', 'DWRE', 'Diplomate, Water Resources Engineer', '3c4a0953-cdf3-49c2-b0a0-2f85906e9214'),
    ('1a50bb8e-04fc-48fc-8219-cd50539117fe', 'PG', 'Professional Geologist', 'b867b808-7ca2-4442-8173-e5e1aec2919d'),
    ('a5926723-d870-45e6-839e-1bf13f20e6fb', 'PLS', 'Professional Land Surveyor', 'b867b808-7ca2-4442-8173-e5e1aec2919d'),
    ('d0fa88f2-72df-4d30-a5c4-a7db416d0ede', 'MS', 'Master of Science', '9e1aeb76-5b84-42f9-ac66-9aa9e6074ca0');

-- update PhD
UPDATE credential SET
    name = 'Doctorate' WHERE id = '535ba415-6be5-410d-b53c-8759c23c62cf'