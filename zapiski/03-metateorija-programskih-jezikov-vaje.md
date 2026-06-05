---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.12
    jupytext_version: 1.8.0
kernelspec:
  display_name: OCaml 4.11
  language: OCaml
  name: ocaml-jupyter
---

# Vaje

```{code-cell}
:tags: [remove-cell, remove-stdout]

(* Ko se v Jupytru prvič požene OCaml, program Findlib izpiše neko sporočilo.
   Da se to sporočilo ne bi videlo v zapiskih, je tu ta celica, ki sproži izpis,
   vendar ima nastavljeno, da je v zapiskih v celoti skrita. *)
```

## Vaje

## Naloga 1

Preverite primere, izpuščene v zgornjih dokazih.

## Naloga 2

Vpeljite relacijo $\leadsto^*$, ki je tranzitivna in refleksivna ovojnica relacije malih korakov $\leadsto$. Razložite, kakšen je njen intuitivni pomen ter pokažite, da je res tranzitivna.

## Naloga 3

Definirajte _vrednosti_ `v` za posamezne družine izrazov.

Pokažite pomožno lemo oblike:

    s , c1 ~~> s' , c1' 
    => 
    s' , c1' --> s'' 
    => 
    s , c1 --> s''

Pokažite ujemanje `~~*>` in `-->` (semantika velikih korakov):

    s , e --> s', v 
    <=> 
    s , e ~~*> s' , v

Ujemanje je potrebno pokazati za vsako družino izrazov.
