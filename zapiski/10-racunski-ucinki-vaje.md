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

## Naloga 1

Lambda račun razširite z učinkoma za branje in pisanje (IO). Pri tem se osredotočimo zgolj na branje in pisanje celih števil.

Da lahko beležimo v katerem koraku program nekaj prebere oz. izpiše, naj nova operacijska semantika uporablja označene puščice.

- Če se v koraku ni zgodilo nič, potem uporabimo navadno puščico.
- Če smo v koraku izpisali število `n`, potem puščico označimo z `!n`.
- Če smo v koraku prebrali število `n`, potem puščico označimo z `?n`.

Sedaj je potrebno tudi stara pravila dopolniti z označenimi puščicami. Da se število pravil ne potroji, lahko uporabljate spremenljivke za tip oznake na puščici.

## Naloga 2

Napišite program, ki prebere dve števili in izpiše njuno vsoto. Narišite drevo vseh možnih izvajanj programa.

## Naloga 3

Sedaj, ko imamo na voljo razširitev Lambda računa s pomnilnikom, lahko v Lambda računu modeliramo IMP. Napišite prevajalnik, ki sprejme program v IMPu in vrne program v Lambda računu.

## Naloga 4

Lambda račun s pomnilnikom razširite še s hkratnim izvajanjem. Izračun `c1 || c2`, za `c1 : unit` in `c2 : unit`, lahko naredi korak v prvi ali drugi komponenti. Ko izračuna obe komponenti, vrne `unit` (torej je izvajanje zanimivo le v kombinaciji z drugimi učinki).

Je naš programski jezik še determinističen? Če ni, napišite program, ki bo imel več možnih rezultatov.
