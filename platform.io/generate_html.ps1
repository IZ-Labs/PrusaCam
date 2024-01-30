. py -m pip install --upgrade pip setuptools wheel
. py -m pip install minify-html

. py ./minify.py ./html/index.html ./html/index.min.html
. py ./minify.py ./html/restart.html ./html/restart.min.html