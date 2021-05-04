-- drop constraint on friend
alter table Friend DROP FOREIGN KEY  `Friend_ibfk_1`;
alter table Friend DROP FOREIGN KEY  `Friend_ibfk_2`;

-- drop constraint Favorite
alter table User_Favorites_Recipe DROP FOREIGN KEY `User_Favorites_Recipe_ibfk_2`;

-- drop constraint User_Notes_Recipe
alter table User_Notes_Recipe DROP FOREIGN KEY `User_Notes_Recipe_ibfk_2`;

-- drop constraint Recipe Rate

alter table User_Rates_Recipe DROP FOREIGN KEY `User_Rates_Recipe_ibfk_2`;

-- drop constraint Recipie View
alter table User_Views_Recipe drop FOREIGN KEY `User_Views_Recipe_ibfk_2`;


-- create partition
alter table User DROP PRIMARY KEY, ADD PRIMARY KEY (uid, birth_date) ;


ALTER TABLE User PARTITION BY HASH( MONTH(birth_date)) PARTITIONS 12;


