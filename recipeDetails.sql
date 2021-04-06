SELECT 
CASE WHEN EXISTS 
(SELECT * fROM User_Favorites_Recipe favorites
WHERE favorites.uid = t.uid
AND favorites.recipeid = t.recipeid) THEN 1
ELSE 0
END as isFavorited,
note.note as user_note,
t.title as title , t.cookingTime as cookingTime, t.recipe_text as recipe_text, t.summary as summary,
t.ingredients as ingredients, t.directions as directions, t.main_image as main_image, t.nutritional_calories as nutritional_calories,
rating.value as user_rating
FROM
(SELECT
*
FROM 
Recipe r,
USER u
WHERE
u.uid = 2
AND r.recipeid = 10
) t
LEFT JOIN User_Notes_Recipe note ON note.uid = t.uid AND note.recipeid = t.recipeid
LEFT JOIN User_Rates_Recipe rating ON rating.uid = t.uid AND rating.recipeid = t.recipeid;
