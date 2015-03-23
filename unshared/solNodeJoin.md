#Node.JS Solution
## Join Query
**As query3 you should have:**

```
var query3 = 'SELECT beers.name AS beer, favorites.stars AS brewery_stars FROM `beer-sample` AS beers ' +
    'JOIN default AS favorites ON KEYS to_string("favorite_" || beers.brewery_id);
```