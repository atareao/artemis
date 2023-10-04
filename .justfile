user    := "atareao"
name    := `basename ${PWD}`
version := `git tag -l  | tail -n1`

build:
    echo {{version}}
    echo {{name}}
    docker build -t {{user}}/{{name}}:{{version}} \
                 -t {{user}}/{{name}}:latest \
                 .

enter:
    docker run  -it \
                --rm \
                --init \
                {{user}}/{{name}}:latest bash

run:
    docker run  --detach \
                --rm \
                --init \
                --publish 8161:8161 \
                --publish 61616:61616 \
                --name artemis \
                {{user}}/{{name}}:latest
