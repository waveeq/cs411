CREATE TABLE User (
    uid INT AUTO_INCREMENT,
    profile_image VARCHAR(255),
    user_name VARCHAR(255),
    email VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    password VARCHAR(255),
    birth_date DATE,
    country VARCHAR(255),
    PRIMARY KEY (uid),
    UNIQUE KEY (`user_name`),
    UNIQUE KEY (`email`)
);

CREATE TABLE Friend(
    first_uid INT,
    second_uid INT,
    PRIMARY KEY (first_uid, second_uid),
    FOREIGN KEY (first_uid) REFERENCES User(uid) ON DELETE CASCADE,
    FOREIGN KEY (second_uid) REFERENCES User(uid) ON DELETE CASCADE
);

CREATE TABLE Recipe (
    recipeid INT AUTO_INCREMENT,
    title VARCHAR(255),
    cookingTime TIME,
    recipe_text TEXT,
    summary TEXT,
    ingredients TEXT,
    directions VARCHAR(255),
    main_image VARCHAR(255),
    nutritional_calories INT,
    PRIMARY KEY (recipeid),
    INDEX (`title`),
    FULLTEXT(recipe_text),
    FULLTEXT(`summary`),
    FULLTEXT(`ingredients`)
);

CREATE TABLE Nutritional_Food_Group (
    name VARCHAR(255),
    daily_recommended_value INT,
    unit_of_measure VARCHAR(10),
    PRIMARY KEY (name)
);

CREATE TABLE Cuisine (
    name VARCHAR(255),
    PRIMARY KEY (name)
);

CREATE TABLE Category (
    name VARCHAR(255),
    PRIMARY KEY (name)
);

CREATE TABLE Recipe_Is_Part_Of_Category (
    name VARCHAR(255),
    recipeid INT,
    PRIMARY KEY (name, recipeid),
    FOREIGN KEY (name) REFERENCES Category(name) ON DELETE CASCADE,
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE
);

CREATE TABLE Recipe_Is_Part_Of_Cuisine (
    name VARCHAR(255),
    recipeid INT,
    PRIMARY KEY (name, recipeid),
    FOREIGN KEY (name) REFERENCES Cuisine(name) ON DELETE CASCADE,
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE
);

CREATE TABLE Recipe_Has_Nutrition_Food_Group (
    name VARCHAR(255),
    recipeid INT,
    nutritionalValue INT,
    PRIMARY KEY (name, recipeid),
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE,
    FOREIGN KEY (name) REFERENCES Nutritional_Food_Group(name) ON DELETE CASCADE
);

CREATE TABLE User_Favorites_Recipe (
    uid INT,
    recipeid INT,
    PRIMARY KEY (uid, recipeid),
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES User(uid) ON DELETE CASCADE
);

CREATE TABLE User_Views_Recipe (
    uid INT,
    recipeid INT,
    count INT,
    PRIMARY KEY (uid, recipeid),
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES User(uid) ON DELETE CASCADE
);

CREATE TABLE User_Rates_Recipe (
    uid INT,
    recipeid INT,
    value INT,
    PRIMARY KEY (uid, recipeid),
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES User(uid) ON DELETE CASCADE
);

Create TABLE User_Notes_Recipe (
    uid INT,
    recipeid INT,
    note TEXT,
    PRIMARY KEY (uid, recipeid),
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE,
    FOREIGN KEY (uid) REFERENCES User(uid) ON DELETE CASCADE
);
