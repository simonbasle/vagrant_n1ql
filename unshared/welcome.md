#N1QL Demo Server - Welcome!

##Querying in the Command Line
You can use cbq to query the N1QL server via the command line.

 1. Connect to this server via ssh: `ssh vagrant@SERVERIP`, password is `vagrant`.
 2. Enter CBQ client: `cbq`
 3. Query away! Example: ```SELECT * FROM `beer-sample` LIMIT 10;```
 
##Querying in Java
This server is also a Maven repository. You can use it to retrieve version 2.1.2-cblive of the Java SDK.

Add the following to your `pom.xml`:

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

Then maybe try to do a join? I have defined some favorite breweries in `default` bucket, their keys are the concatenation of "`favorite_`" and the `brewery_id`. ([solution](solJavaJoin.html))

##Querying in .Net
**TODO**
Use this [skeleton](sources/netSkeleton.zip) application.

##Querying in Node.js
**TODO**
Use this [skeleton](sources/nodeSkeleton.zip) application.