#Java Solution
## Simple Query

**Replace** `Query query = null; //TODO...` with

    Query query = Query.simple("SELECT name AS beer FROM `beer-sample` ORDER BY name LIMIT 10");

**Replace** `QueryResult result = null; //TODO...` with

    QueryResult result = bucket.query(query);

That's it :)