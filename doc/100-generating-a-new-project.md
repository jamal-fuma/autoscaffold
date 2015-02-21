How do I use it?
============
1) clone the repo  		 > git checkout github.com/jamal-fuma/autoscaffold ./autoscaffold
2) generate an output directory  > cd ./autoscaffold; ./configure.sh
3) see the tests pass 		 > cd output; ./autogen.sh; ./configure; make; make distcheck;

Now make sure to copy the output directory somewhere as running ./configure.sh again will overwrite the output directory.
