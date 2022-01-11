from faker import Faker

fake = Faker()

num_clients = 50
insert_statement = "insert into client (id, first_name, last_name, email, role, location) values ('{id}', '{first_name}', '{last_name}', '{email}', '{role}', {location});"

with open("insert_clients.sql", "w") as out:
    for _ in range(50):
        statement = insert_statement.format(
            id= fake.uuid4(),
            first_name= fake.first_name(),
            last_name= fake.last_name(),
            email= fake.email(),
            role= fake.job(),
            location= 'point(' + str(fake.latitude()) + "," + str(fake.longitude()) + ")",
        )
        out.write(statement + "\n")