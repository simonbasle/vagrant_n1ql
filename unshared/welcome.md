#N1QL Demo Server - Welcome!

##Querying in the Command Line
You can use cbq to query the N1QL server via the command line.

 1. Connect to this server via ssh: `ssh vagrant@SERVERIP`, password is `vagrant`.
 2. Enter CBQ client: `cbq`
 3. Query away! Example: ```SELECT * FROM `beer-sample` LIMIT 10;```
 
##The Queries
The idea of this tutorial is to make you use your favorite language (among Java, .Net and Node.js) to play with N1QL.

We'll work with 3 queries on the beer-sample bucket:

 * A simple query to select the `name` of `10` `beer`s, in alphabetical order
 * An intermediate query to correct the fact that the first one would also show brewery names (by making sure of the correct `type`)
 * An advanced query that joins beers to the default bucket, in which some breweries have been marked as favorite. The joining key is constructed by taking the beer's `brewery_id` and prefixing it with `favorite_`, giving a document id in `default` bucket.
 
**ToC**

 * [Querying in Java](#java)
 * [Querying in .Net](#net)
 * [Querying in Node.js](#node)

##<a id="java"></a>Querying in Java
This server is also a Maven repository. You can use it to retrieve version 2.1.2-cblive of the Java SDK with the following snippet inside `pom.xml`:

```
<repositories>
    <repository>
      <id>couchbase-cblive</id>
      <name>couchbase repo for cblive</name>
      <url>http://192.168.5.111/maven</url>
      <snapshots><enabled>false</enabled></snapshots>
    </repository>
  </repositories>

  <dependencies>
    <dependency>
      <groupId>com.couchbase.client</groupId>
      <artifactId>java-client</artifactId>
      <version>2.1.2-cblive</version>
    </dependency>
    <!-- LOGGING -->
    <dependency>
      <groupId>log4j</groupId>
      <artifactId>log4j</artifactId>
      <version>1.2.17</version>
    </dependency>
  </dependencies>
```

You can use this [skeleton](sources/javaSkeleton.zip) for a Maven application.

Once you've obtained a reference to the `Cluster` and `Bucket`, you can start querying using `bucket.query(Query.simple("A N1QL STATEMENT")))`. Try it out! ([solution](solJavaSimple.html))

After that, you can try to use the DSL to create a statement with a WHERE clause (start with `select(x("SOME FIELD"))`). ([solution](solJavaPredicate.html))

Then maybe try to do a join? I have defined some favorite breweries in `default` bucket, their keys are the concatenation of "`favorite_`" and the `brewery_id`. 

So select some beers, using their `brewery_id` foreign key join them onto the favorite documents. You can construct the key in N1QL using the `to_string()` function and the `||` concatenation operator.
([solution](solJavaJoin.html))

##<a id="net"></a>Querying in .Net
The following nuget packages are necessary:

```
  <package id="Common.Logging" version="3.0.0" targetFramework="net45" />
  <package id="Common.Logging.Core" version="3.0.0" targetFramework="net45" />
  <package id="Common.Logging.Log4Net1213" version="3.0.0" targetFramework="net45" />
  <package id="CouchbaseNetClient" version="2.0.3" targetFramework="net45" />
  <package id="Newtonsoft.Json" version="6.0.8" targetFramework="net45" />
```
Use this [skeleton](sources/netSkeleton.zip) application and follow the TODO instructions after importing the solution in Visual Studio.

**Important**: don't forget to correct the IP address in `App.config`.

You will have to do a simple query ([solution](solNetSimple.html)), a query with WHERE clause ([solution](solNetPredicate.html)) and finally a join query ([solution](solNetJoin.html)).

##<a id="node"></a>Querying in Node.js
Use this [skeleton](sources/nodeSkeleton.zip) application and edit `routes/query.js`. Replace the occurrences of the IP adress by the correct one for the hands on.

You then just have to fill the `queryX` strings at the top.

You will have to do a simple query ([solution](solNodeSimple.html)), a query with WHERE clause ([solution](solNodePredicate.html)) and finally a join query ([solution](solNodeJoin.html)).