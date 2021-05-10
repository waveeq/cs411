DELIMITER $$

USE cs411$$

DROP PROCEDURE IF EXISTS sp_insertuser$$

CREATE PROCEDURE sp_insertuser(
IN  profile_image_param VARCHAR(255),
IN  user_name_param VARCHAR(255),
IN  email_param VARCHAR(255),
IN  first_name_param VARCHAR(255),
IN  last_name_param VARCHAR(255),
IN  password_param VARCHAR(255),
IN  birth_date_param DATE,
IN  country_param VARCHAR(255))
BEGIN

INSERT INTO USER (
profile_image,
user_name,
email,
first_name,
last_name,
password,
birth_date,
country
)
VALUES (
profile_image_param,
user_name_param,
email_param,
first_name_param,
last_name_param,
password_param,
birth_date_param,
country_param
);

END$$
# change the delimiter back to semicolon
DELIMITER ;
