INSERT INTO User(profile_image,user_name,
email,first_name,last_name,password,birth_date,country) 
VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1oEqijEs3QbbwL6wCXlQTKWmgQ6CNTfhGJGazw34dxFRyLUlTkjmn56hsR7WPNmyagQQfTLgL&usqp=CAc',
'spencer boojah', 'spencer@gmail.com','spencer','boojah','password',STR_TO_DATE('03/08/1994', '%m/%d/%Y'),'United States'
);
INSERT INTO User(profile_image,user_name,
email,first_name,last_name,password,birth_date,country) 
VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1oEqijEs3QbbwL6wCXlQTKWmgQ6CNTfhGJGazw34dxFRyLUlTkjmn56hsR7WPNmyagQQfTLgL&usqp=CAc',
'claire molens', 'claire@gmail.com','claire','molens','12345 same password on my luggage',STR_TO_DATE('01/28/1994', '%m/%d/%Y'),'United States'
);
INSERT INTO User(profile_image,user_name,
email,first_name,last_name,password,birth_date,country) 
VALUES ('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1oEqijEs3QbbwL6wCXlQTKWmgQ6CNTfhGJGazw34dxFRyLUlTkjmn56hsR7WPNmyagQQfTLgL&usqp=CAc',
'admin', 'chris@gmail.com','chris','boojah','03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4',STR_TO_DATE('03/08/1994', '%m/%d/%Y'),'United States'
);
INSERT INTO FRIEND(first_uid,second_uid) VALUES ((SELECT uid FROM User WHERE user_name = 'claire molens'),(SELECT uid FROM User WHERE user_name = 'spencer boojah'));
INSERT INTO FRIEND(first_uid ,second_uid ) VALUES ((SELECT uid FROM User WHERE user_name = 'spencer boojah'),(SELECT uid FROM User WHERE user_name = 'claire molens'));
INSERT INTO Recipe(title, recipe_text, main_image) VALUES ("chocolate chip cookies","1. make dough 2. put in oven","https://kirbiecravings.com/wp-content/uploads/2020/10/no-bake-keto-choc-chip-cookies-3a.jpg");
INSERT INTO User_Notes_Recipe(uid, recipeid, note) VALUES ((SELECT uid FROM User WHERE user_name = 'spencer boojah'), (SELECT recipeid FROM Recipe WHERE title = "chocolate chip cookies"),"so goooooood");
INSERT INTO User_Rates_Recipe(uid, recipeid, value) VALUES ((SELECT uid FROM User WHERE user_name = 'spencer boojah'), (SELECT recipeid FROM Recipe WHERE title = "chocolate chip cookies"),4);
