#!/bin/bash

SRC=/home/docker_share/blog/extra_postlog
C=blog_web_1
DST=/var/www/html

docker cp $SRC/logtitle.html $C:$DST/

for f in $SRC/log*.html; do
    [[ $(basename "$f") =~ ^log[0-9]+\.html$ ]] && docker cp "$f" $C:$DST/postlog/
done

docker cp $SRC/images/. $C:$DST/images/postlog/

echo "done"
