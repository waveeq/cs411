SELECT
r.title, r.cookingTime, r.recipe_text, r.summary,
r.ingredients, r.directions, r.main_image, r.nutritional_calories 


FROM 
Recipe r,
User_Favorites_Recipe favorites,
User_Notes_Recipe note,
User_Rates_Recipe rating,
WHERE 

