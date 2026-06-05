.PHONY: build host clean

PORT ?= 8000
PYTHON ?= python3

build: zapiski/_static/mathjax
	jupyter-book build zapiski

host: build
	cd zapiski/_build/html && $(PYTHON) -m http.server $(PORT)

clean:
	rm -rf zapiski/_build

zapiski/_static/mathjax:
	npm pack mathjax@3
	tar -xzf mathjax-3*.tgz
	mkdir -p zapiski/_static
	mv package zapiski/_static/mathjax
	rm mathjax-3*.tgz
