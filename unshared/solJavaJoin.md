#Java Solution
## Join Query

**Replace** `Statement joinPredicate = null; //TODO...` with

    Statement joinPredicate = select(x("beers.name").as("beer"),
                x("favorites.stars").as("brewery_stars"))
                .from(i("beer-sample").as("beers"))
                .join("default").as("favorites")
                .keys(tostring(s("favorite_"), x("beers.brewery_id")))
                .join("`beer-sample`").as("brewery")
                .keys(x("beers.brewery_id"));

**Replace** `Query query = null; //TODO...` with

    Query query = Query.simple(joinPredicate);

**Replace** `QueryResult result = null; //TODO...` with

    QueryResult result = bucket.query(query);

That's it :)

The `String` version of the DSL predicate is:

    SELECT beers.name AS beer, favorites.stars AS brewery_stars
    FROM `beer-sample` AS beers 
    JOIN default AS favorites
      ON KEYS to_string("favorite_" || beers.brewery_id) 
    JOIN `beer-sample` AS brewery
      ON KEYS beers.brewery_id
