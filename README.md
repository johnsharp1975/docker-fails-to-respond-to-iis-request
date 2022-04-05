Docker is failing to properly respond to some requests
====================================================== 

**TL;DR** - I'm not expecting anyone to pull this repo, I'm adding the code so that I can try and explain the problem. These files are fairly simple changes to the default web project templates of Visual Studio. They run nicely on all machines they've been tested on. They're cut down version of production code that reflect the problem space. Windows + IIS in a docker container seems to happily serve files but somewhere something is stopping some large requests from fully making it back to the browser.

Longer version
--------------
I'm trying to create a container version of some production code. Constructing it works well. Using it is mostly good but the bug is that some responses don't make it back to the caller.

Container
---------
The DOCKERFILE is what I've used to construct this test and for the most part is failing in the same way as the production version. I'm running the container like this:

```
docker build -t iis48 .
docker run -ti --rm --name iis -p 2020:2020 -p 2021:2021 -p 2022:2022 --network=nat --ip="172.17.48.65" iis48:latest
```
I've forced the IP so that I don't have to keep reconnecting with IIS manager.

The container should have 4 things added to it, on top of a Framework 4.8 image. Dotnet 5.0.14 hosting bundle and three websites, files, web1 and web2.

Files
-----
This is the first thing I tried - a bunch of big files from IIS. It's the same file really but with different extensions.

Web1
----
This is the Framework 4.8 project. All of the tests I've thought to try with this work as expected.

Web2
----
This is the .Net 5.0 project. When the project first starts up you should be directed to a Swagger page. Refresh the page a couple of times and the response JSON object will not get returned. Refresh it a few more times and it might. Opening Fiddler shows that the response has been received by the caller but there is no end to the connection which causes the caller to assume theres a timeout.

Problem definition
------------------
Why are some of the calls in the Web2 application being made successfully but the response isn't getting back to the caller correctly.
