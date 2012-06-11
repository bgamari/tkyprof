#!/bin/sh

for i in `seq 0 999`; do                                         /home/maoe/src/tkyprof
  curl -X POST -d "{\"name\": \"Project #$i\"}" -D - http://localhost:3000/projects
done

