#!/bin/bash
# 2. ƒаны две директории, написать скрипт, вывод€щий имена непустых файлов, которые есть и в одной, и в другой директории.
du -ab $1 | awk '{ if ($1 != 0) print $2 }' | xargs -I _ basename _ | sort > tmp
du -ab $2 | awk '{ if ($1 != 0) print $2 }' | xargs -I _ basename _ | sort | join - tmp
rm tmp