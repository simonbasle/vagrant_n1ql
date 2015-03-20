#.Net Solution
##Simple Query
**At first TODO you should have:** 

```
//try to do a simple select of 10 name of beers (in alphabetical order) from the beer-sample
string simpleStatement = "SELECT name FROM `beer-sample` ORDER BY name LIMIT 10";
QueryRequest simple = new QueryRequest(simpleStatement);
IQueryResult<dynamic> simpleResult = beerBucket.Query<dynamic>(simple);
```