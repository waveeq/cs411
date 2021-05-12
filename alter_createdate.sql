ALTER table User add created_date DATE;
ALTER TABLE User add CONSTRAINT User_email UNIQUE (email,birth_date);
ALTER TABLE User add CONSTRAINT User_username UNIQUE (user_name, birth_date);

