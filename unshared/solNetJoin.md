#.Net Solution
## Join Query
**At third TODO you should have:**

```
string joinStatement = "SELECT * FROM `beer-sample` AS beers "
            + "JOIN default AS favorites "
            + "ON KEYS to_string(\"favorite_\" || beers.brewery_id)";
QueryRequest join = new QueryRequest(joinStatement);
IQueryResult<dynamic> joinResult = beerBucket.Query<dynamic>(join);
```