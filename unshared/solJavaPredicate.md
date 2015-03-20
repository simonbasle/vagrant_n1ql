#Java Solution
## Predicate Query

**Replace** `Statement selectPredicate = null; //TODO...` with

    Statement selectPredicate = select(x("name").as("beer"))
                .from(i("beer-sample"))
                .where(x("type").eq(s("beer")))
                .orderBy(asc("name"))
                .limit(10);

**Replace** `Query query = null; //TODO...` with

        Query query = Query.simple(selectPredicate);

**Replace** `QueryResult result = null; //TODO...` with

    QueryResult result = bucket.query(query);

That's it :)