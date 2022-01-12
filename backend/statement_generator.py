from faker import Faker
import random

fake = Faker()

num_clients = 50
num_photographers = 100
client_insert_statement = "insert into client (id, first_name, last_name, email, role, location) values ('{id}', '{first_name}', '{last_name}', '{email}', '{role}', {location});"
photographer_insert_statement = "insert into photographer (id, first_name, last_name, description, email, school, phone_number, instagram, location, s3_portfolio_uri) values ('{id}', '{first_name}', '{last_name}', '{description}', '{email}', '{school}', '{phone_number}', '{instagram}', {location}, '{s3_portfolio_uri}');"
package_insert_statement = "insert into package (package_id, photographer_id, payment_type, rate, editing, additional_info) values ('{package_id}', '{photographer_id}', '{payment_type}', {rate}, '{editing}', '{additional_info}');"

packages = []

'''
CREATE TABLE client (
    id UUID NOT NULL PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(50) NOT NULL,
    role varchar(100),
    location point);
'''
with open("insert_clients.sql", "w") as out:
    for _ in range(num_clients):
        client_statement = client_insert_statement.format(
            id= fake.uuid4(),
            first_name= fake.first_name(),
            last_name= fake.last_name(),
            email= fake.email(),
            role= fake.job(),
            location= 'point(' + str(fake.latitude()) + "," + str(fake.longitude()) + ")",
        )
        out.write(client_statement + "\n")



'''
CREATE TABLE photographer (
    id UUID NOT NULL PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    description varchar(300),
    email varchar(50) NOT NULL,
    school varchar(50),
    phone_number varchar(25),
    instagram varchar(25),
    location point,
    s3_portfolio_uri varchar(100));
'''
with open("insert_photographers.sql", "w") as out:
    for _ in range(50):
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
            location = 'point(' + str(fake.latitude()) + "," + str(fake.longitude()) + ")", 
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
    additional_info varchar(100));
'''
with open("insert_package.sql", "w") as out:
    out.writelines(packages)