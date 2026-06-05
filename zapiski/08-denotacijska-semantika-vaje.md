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

Izpeljite semantiko naslednjih programov:

1. `|- fun x -> if x < 0 then 0 else 2 * x : int -> int`
2. `|- fun x -> (fun y -> x > y) : int -> int -> bool`

Preverite, da je pomen sledečega program enak pomenu programa 1.

`|- fun a -> (fun y -> if y > 0 then y else 0) (a + a) : int -> int`

## Naloga 2

Denotacijsko semantiko dopolnite za pare in vsote in izpeljite pomen programa:

`|- Fst (Inl 2, false): int + (bool * bool)`

## Naloga 3

Definirajte denotacijsko semantiko za jezik IMP brez zanke while. Predpostavimo, da imamo fiksno množico vseh lokacij $Loc$. Stanje lokacij predstavimo s funkcijo $s$ tipa $State := Loc \to \mathbb{Z}$.

Pomen izrazov modelirajte kot:

- (aritmetični izrazi) $[[e]] : State \to \mathbb{Z}$,
- (logični izrazi) $[[b]] : State \to \{tt,ff\}$
- (ukazi) $[[c]] : State \to State$

Premislite, zakaj smo izpustili zanko while.
