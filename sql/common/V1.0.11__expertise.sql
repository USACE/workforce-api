-- expertise
CREATE TABLE IF NOT EXISTS expertise (
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name VARCHAR UNIQUE NOT NULL
);
INSERT INTO expertise (id, name) VALUES
    ('81e4d6f4-bf94-4a34-88a2-aee4be19d3ef', 'Hydrology'),
    ('5ec1c2aa-baf8-4402-96c1-dd889373fbd5', 'Hydraulics'),
    ('1711ed15-6a87-40a9-b263-daf845022806', 'Coastal'),
    ('dc0cb138-5333-48c6-bb21-89aa2580a976', 'Water Management'),
    ('d8d31932-a39b-4e0b-933c-399f4c9325d8', 'Water Quality');

-- occupant_expertise
CREATE TABLE IF NOT EXISTS occupant_expertise (
    occupancy_id UUID NOT NULL REFERENCES occupancy(id) ON DELETE CASCADE,
    expertise_id UUID NOT NULL REFERENCES expertise(id),
    CONSTRAINT unique_occupant_expertise UNIQUE(occupancy_id, expertise_id)
);