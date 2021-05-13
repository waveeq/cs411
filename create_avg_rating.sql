CREATE TABLE AverageRatingRecipie (
    recipeid INT,
    average_rating DECIMAL(7,5),
    PRIMARY KEY (recipeid),
    FOREIGN KEY (recipeid) REFERENCES Recipe(recipeid) ON DELETE CASCADE
);


DELIMITER ;;
CREATE PROCEDURE `update_average_rating_for_recipie`(IN recipeid_param  INT)
BEGIN
	UPDATE AverageRatingRecipie set average_rating = (select avg(value) from User_Rates_Recipe where recipeid = recipeid_param) where recipeid = recipeid_param;
END;;


CREATE TRIGGER `update_average_rating_oninsert` AFTER INSERT ON `User_Rates_Recipe` FOR EACH ROW
BEGIN
	CALL update_average_rating_for_recipie(NEW.recipeid);
END;;

CREATE TRIGGER `update_average_rating_onupdate` AFTER UPDATE ON `User_Rates_Recipe` FOR EACH ROW
BEGIN
	CALL update_average_rating_for_recipie(NEW.recipeid);  
END;;
DELIMITER ;
