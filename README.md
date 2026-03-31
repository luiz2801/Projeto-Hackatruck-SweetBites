### Banco de Dados
- Banco de Dados do Usuário.
- Banco de Dados das Receitas.

**Usuário:**

{
    "userimage-url" : String,
    "username" : String,
    "userdescription" : String,
    "user-recipes" : [String] -> _id das receitas.,
    "rt-recipes" : [String] _id das receitas.,
    "save-recipes" : [String] _id das receitas.
}

**Receitas:**

{
    "recipename" : String,
    "username" : String,
    "recipeimage-url" : String,
    "ingredients" : [String],
    "preparation-method" : String,
    "preparation-time" : Int,
    "category" : [Int],
    "upvotes" : Int,
    "downvote" : Int,
    "comments" : {
        "user-id" : "String" -> _id do usuário.,
        "comment" : String
    },
    "rt-counter" : Int,
    "save-counter" : Int
}
