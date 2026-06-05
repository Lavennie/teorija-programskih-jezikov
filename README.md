# Teorija programskih jezikov

V tem repozitoriju se zbirajo gradiva za predmet Teorija programskih jezikov na magistrskem študijuna [Fakulteti za matematiko in fiziko](https://www.fmf.uni-lj.si/).

## Zapiski

Viri zapiskov se nahajajo v mapi `zapiski`. Za izdelavo HTML datotek si morate namestiti paket [`jupyter-book`](https://jupyterbook.org/). Nato pa pokličete

```bash
jupyter-book build zapiski
```

Zapiski sicer uporabljajo Jupyter book v1 (Sphinx).
```bash
pip install "jupyter-book<2"
```

Hkrati imamo ponekod evaluacijo OCaml kode, za katero z opam naložite še `jupyter` paket.
```bash
opam install jupyter
opam exec -- ocaml-jupyter-opam-genspec
jupyter kernelspec install --user --name ocaml-jupyter \
  "$(opam var share)/jupyter"
```
Preverite, da je jedro vključeno.
```bash
jupyter kernelspec list
```
Če s tem ne želite izgubljati časa, lahko v `zapiski/_config.yml` odkomentirate vrstici z `execute`.


Zapiski uporabljajo lokalno kopijo Mathjaxa, zato da delujejo tudi brez spleta.
V ta namen ga je treba najprej spraviti v `zapiski/_static`. To naredimo eksplicitno z
```bash
npm pack mathjax@3
tar -xzf mathjax-3*.tgz
rm -rf zapiski/_static/mathjax
mkdir -p zapiski/_ext_assets
mv package zapiski/_static/mathjax
rm mathjax-3*.tgz
```

Za lažjo uporabo je vse to zapakirano v makefile, tako da lahko samo poženete
```bash
make build
```
kar naloži Mathjax in zgradi zapiske.
```bash
make host
```
še zažene strežnik na `localhost:8000`.

Če imate ustrezne pravice, lahko HTML najenostavneje objavite kar prek [GitHub pages](https://pages.github.com) tako, da si namestite še paket [`ghp-import`](https://github.com/c-w/ghp-import) in poženete

```bash
ghp-import --no-jekyll --no-history --force --push zapiski/_build/html
```
