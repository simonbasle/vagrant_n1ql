#N1QL Hands-On Server

##Description
This project uses `Vagrant` and `Puppet` to create a virtual machine that can be used as a server for a Hands-On on N1QL in Java, .Net and Node.js.

The server has a Couchbase server running, with N1QL enabled. A `cbq client` is available and attendees can connect and use it via `ssh` using the `cbq` alias.

The VM also serves static HTML pages with instructions, zip files to bootstrap the hands-on (under `/sources`), solution pages for the steps of the hands-on and a `maven repository` (under `/maven`) with SDK snapshots.

##How to Use
You'll just need to customize the `Vagrantfile` and at least customize the `ip_base` and decide to activate `public_lan` or not (probably yes).

After first provisionning, you'll have to execute the install procedure by navigating to `http://VM_IP:8091`. Make sure to create `default` bucket and load the `beer-sample` sample.

Then the solution for java join query expects some favorite brewery documents, with keys like `favorite_`*brewery_id* and a `stars` int value. For example, create a `favorite_abbaye_de_leffe` document and put the following content:

    { "stars": 5, "comment": "very good beers" }

##Contents

`unshared` contains markdown sources for static pages.

`prov` will be created on first provisionning of the VM. Puppet will use this folder to download sources, packages, etc... and won't reprovision if they are alread present there.

`resources` is mounted as is in the vm under `/vagrant/resources`.

`resources/www/`
> contains static pages served by `nginx`: a `maven` repository, welcome page, solutions, zipped skeletons for the 3 languages.

`resources/nginxvagrant`
> a `nginx` configuration file used by puppet.

The html pages (welcome and sol*) can be generated from the markdown files in unshared.

The maven repo can just be copied from your local `.m2` repository (just the artifacts that are needed and not on Maven Central).

Welcome page also expects `sources/javaSkeleton.zip`, sources/netSkeleton.zip and sources/nodeSkeleton.zip files (to serve as bootstrap for the hands-on).

