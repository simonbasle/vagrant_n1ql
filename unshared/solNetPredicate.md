#.Net Solution
##Predicate Query
**At second TODO you should have:**

```
string predicateStatement = "SELECT name FROM `beer-sample` WHERE type = \"beer\" ORDER BY name LIMIT 10";
QueryRequest predicate = new QueryRequest(predicateStatement);
IQueryResult<dynamic> predicateResult = beerBucket.Query<dynamic>(predicate);
```