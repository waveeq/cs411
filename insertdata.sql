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
INSERT INTO FRIEND(first_uid,second_uid) VALUES ((SELECT uid FROM User WHERE user_name = 'claire molens'),(SELECT uid FROM User WHERE user_name = 'spencer boojah'));
INSERT INTO FRIEND(first_uid ,second_uid ) VALUES ((SELECT uid FROM User WHERE user_name = 'spencer boojah'),(SELECT uid FROM User WHERE user_name = 'claire molens'));
