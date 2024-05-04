#!/bin/bash

mkdir -p ./out

cd ./cartographer
zip -0 -r ../out/cartographer.pk3 *

cd ../disk-jockey
zip -0 -r ../out/disk-jockey.pk3 *

cd ../drla-bonsai
zip -0 -r ../out/drla-bonsai.pk3 *

cd ../drla-thrifty
zip -0 -r ../out/drla-thrifty.pk3 *

cd ../rat-fd
zip -0 -r ../out/rat-fd.pk3 *

cd ../rat-crosshairs
zip -0 -r ../out/rat-crosshairs.pk3 *

cd ../rat-tools
zip -0 -r ../out/rat-tools.pk3 *
