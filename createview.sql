CREATE VIEW UserFavoriteView
AS
SELECT f.recipeid, r.main_image FROM User_Favorites_Recipe f, Recipe r
WHERE r.recipeid=f.recipeid
