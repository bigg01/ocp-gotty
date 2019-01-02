# ocp-gotty
```sh
docker build -t test_gotty .
docker run -p 8080:8080 test_gotty
```

## openshift

```sh
oc new-project gotty

# local
cat Dockerfile | oc new-build -D - --name mygotty
# from git
oc new-build  https://github.com/bigg01/ocp-gotty.git --name mygotty --strategy=docker

# deploy image
oc new-app mygotty --image-stream=gotty/mygotty

# expose image
oc expose service mygotty
oc get route
NAME      HOST/PORT                            PATH      SERVICES   PORT       TERMINATION   WILDCARD
mygotty   mygotty-gotty.192.168.64.10.nip.io             mygotty    8080-tcp                 None
```
