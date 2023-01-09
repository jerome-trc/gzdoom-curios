#!/bin/bash

mkdir -p ./out

cd ./cartographer
zip -0 -r ../out/cartographer.pk3 *

cd ../chprog
zip -0 -r ../out/colourful-hell-prog.pk3 *

cd ../disk-jockey
zip -0 -r ../out/disk-jockey.pk3 *

cd ../drla-bonsai
zip -0 -r ../out/drla-bonsai.pk3 *

cd ../drla-nomadic
zip -0 -r ../out/nomadic-lifestyle.pk3 *

cd ../drla-thrifty
zip -0 -r ../out/drla-thrifty.pk3 *

cd ../fd-patches
zip -0 -r ../out/fd-patchpack.pk3 *

cd ../rat-crosshair
zip -0 -r ../out/rat-crosshair.pk3 *

cd ../rat-tools
zip -0 -r ../out/rat-tools.pk3 *
