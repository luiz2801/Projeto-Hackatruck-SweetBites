### Banco de Dados
- Banco de Dados do Usuário.
- Banco de Dados das Receitas.

**Usuário:**
```
{
    "user_name" : String,
    "user_image_url" : String,
    "user_description" : String,
    "user_recipes" : [String] -> _id das receitas.,
    "save_recipes" : [String] _id das receitas.
}
```
**Receitas:**
```
{
    "recipe_name" : String,
    "user_name" : String,
    "recipe_image_url" : String,
    "recipe_description": String,
    "ingredients" : [String],
    "preparation_method" : String,
    "preparation_time" : Int, 
    "category" : [Int], 
    "upvotes" : Int,
    "downvote" : Int,
    "comments" : {
        "user_id" : "String" -> _id do usuário.,
        "comment" : String
    },
    "save_counter" : Int
}
```

TO-DO:

- [ ] Adicionar o campo tempo de preparo ao AddRecipesUI - Júlio. Coisa simples.
- [ ] Adicionar o campo Comentar.
