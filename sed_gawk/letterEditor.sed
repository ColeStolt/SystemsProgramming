0,/(\([0-9]\{3\}\))\s*\([0-9]\{3\}-[0-9]\{4\}\)/s//800-\2/
0,/-[0-9][0-9][0-9][0-9]/s//-1234/
s/Boris\s*Lane/Boris Kent/g
s/Lane/Ln/g
s/@/#/g
s/;/,/g
s/(\([0-9]\{3\}\))\s*\([0-9]\{3\}\)-\([0-9]\{4\}\)/\2-\1-\3/g
$ a p.s. your winnings must be claimed by February 29th.
