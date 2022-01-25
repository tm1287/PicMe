from faker import Faker
import random

fake = Faker()

num_clients = 50
num_photographers = 1000
client_insert_statement = "insert into client (id, first_name, last_name, email, role) values ('{id}', '{first_name}', '{last_name}', '{email}', '{role}');"
photographer_insert_statement = "insert into photographer (id, first_name, last_name, description, email, school, phone_number, instagram, latitude, longitude, s3_portfolio_uri) values ('{id}', '{first_name}', '{last_name}', '{description}', '{email}', '{school}', '{phone_number}', '{instagram}', {latitude}, {longitude}, '{s3_portfolio_uri}');"
package_insert_statement = "insert into package (package_id, photographer_id, payment_type, rate, editing, additional_info) values ('{package_id}', '{photographer_id}', '{payment_type}', {rate}, '{editing}', '{additional_info}');"

packages = []

'''
CREATE TABLE client (
    id UUID NOT NULL PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    role text);
    '''
with open("insert_clients.sql", "w") as out:
    for _ in range(num_clients):
        client_statement = client_insert_statement.format(
            id= fake.uuid4(),
            first_name= fake.first_name(),
            last_name= fake.last_name(),
            email= fake.email(),
            role= fake.job(),
        )
        out.write(client_statement + "\n")



'''
CREATE TABLE photographer (
    id UUID NOT NULL PRIMARY KEY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    description text,
    email text NOT NULL,
    school text,
    phone_number text,
    instagram text,
    latitude double precision,
    longitude double precision,
    s3_portfolio_uri text);
'''
with open("insert_photographers.sql", "w") as out:
    with open("coords.txt") as coords:
        for coord in coords.readlines():
            for _ in range(5):
                coord = eval(str(coord))

                client_uuid = fake.uuid4()
                client_statement = photographer_insert_statement.format(
                    id = client_uuid, 
                    first_name = fake.first_name(), 
                    last_name = fake.last_name(), 
                    description = fake.sentence(), 
                    email = fake.email(), 
                    school = fake.company(), 
                    phone_number = fake.phone_number(), 
                    instagram = "@" + fake.word(),
                    latitude = random.uniform(-0.05, 0.05) + coord[0],
                    longitude = random.uniform(-0.05, 0.05) + coord[1],
                    s3_portfolio_uri = "https://s3.us-east-1.amazonaws.com/bucket-name/key-name"
                )
                out.write(client_statement + "\n")

                for i in range(random.randint(2, 5)):
                    packages.append(
                        package_insert_statement.format(
                            package_id = fake.uuid4(), 
                            photographer_id = client_uuid, 
                            payment_type = random.choice(["hourly", "bulk", "per-shot"]), 
                            rate = round(random.uniform(10.5, 75.5), 2), 
                            editing = random.choice(["true", "false"]), 
                            additional_info = fake.sentence()
                        ) + "\n"
                    )





'''
CREATE TYPE payment_enum AS ENUM ('bulk', 'hourly', 'per-shot');
CREATE TABLE package (
    package_id UUID NOT NULL PRIMARY KEY,
    photographer_id UUID NOT NULL REFERENCES photographer (id),
    payment_type payment_enum NOT NULL,
    rate money NOT NULL,
    editing boolean NOT NULL,
    additional_info text);
'''
with open("insert_package.sql", "w") as out:
    out.writelines(packages)