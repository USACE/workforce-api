CREATE TABLE IF NOT EXISTS role_request_status (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name VARCHAR NOT NULL
);
INSERT INTO role_request_status (id, name) VALUES
    ('fa7bb4bc-a1bc-4123-bb18-de45ac1d27d3', 'RECEIVED'),
    ('887c19f5-2902-43da-8645-33680523963a', 'APPROVED'),
    ('cd09313b-8540-4b4b-9d69-5bc74b705f41', 'DENIED');

CREATE TABLE IF NOT EXISTS role_request (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    sub UUID NOT NULL,
    office_id UUID NOT NULL REFERENCES office(id),
    request_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_id UUID NOT NULL DEFAULT 'fa7bb4bc-a1bc-4123-bb18-de45ac1d27d3' REFERENCES role_request_status(id),
    response_date TIMESTAMPTZ,
    responder UUID,
    CONSTRAINT unique_sub_office UNIQUE(sub,office_id)
);
