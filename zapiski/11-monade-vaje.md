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

Pokažite, da so naslednje stvari monade

## Monada `Maybe` (ali `option`) za eno samo napako

- `T X = X + 1`, ali $\kwdpre{Maybe} X = \just X \ | \ \nothing$.
- $\eta_X(x) = \just x$
- $m \bind_{X, Y} k = \begin{cases}
    k\ x & m = \just x \\
    \nothing & m = \nothing
  \end{cases}
$

Večinoma bodo monade v kakšni posebni obliki in `bind` bo "odpakiral" oblike ter imel za vsako strukturo v tej obliki svojo vejo.

Preverimo še zakone:
- Očitno lahko vsakemu tipu priredimo nov tip `Maybe X`.
- $\eta_X(x) \bind_{X, Y} k = \just x \bind_{X, Y} k = k\ x$, direktno iz definicije.
- $m \bind_{X, X} \eta_X = \begin{cases}
    \just x \bind_{X, X} \eta_X = \eta_X(x) = \just x & m = \just x \\
    \nothing \bind_{X, X} \eta_X = \nothing & m = \nothing
  \end{cases}
  $, direktno iz definicije.
- Asociativnost, obravnavamo primere glede na obliko $m$.
  1. $m = \nothing$:
    
      $(\nothing \bind_{X, Y} k) \bind_{Y, Z} k' = \nothing \bind_{Y, Z} k' = \nothing = $ 
      $ =\nothing \bind_{X, Z} (x \mapsto k(x) \bind_{Y, Z} k')$.

  2. $m = \just x', k \ x' = \nothing$:
    
      $(\nothing \bind_{X, Y} k) \bind_{Y, Z} k' = \nothing \bind_{Y, Z} k' = \nothing = $ 

      $ = \nothing \bind_{Y,Z} k' = (\just x') \bind_{X, Y} (x \mapsto k \ x  \bind_{Y, Z} k') $

  3. $m = \just x', k \ x' = \just y$:

      $(\just x' \bind_{X, Y} k) \bind_{Y, Z} k' = k \ x' \bind_{Y, Z} k' = (\just x') \bind_{X, Z} (x \mapsto k \ x \bind_{Y, Z} k')$.

## Monada `List` za rezultat več podatkov

Pozor, zaradi vrstnega reda je ta monada drugačna od monade za nedeterminizem.

- `T X = X*` ali $\kwdpre{List} X = [] \ | \ X :: \kwdpre{List } X$.
- $\eta_X(x) = x :: [] = [x]$
- $m \bind_{X, Y} k = fMap \ k \ m$, kjer $fMap f l = \begin{cases}
    [] & l = [] \\
    (f\ x) @ (fMap\ f\ xs) & l = x :: xs
  \end{cases}$

Bodimo pozorni, da je $k: X \to \kwdpre{List} X$.

Preverimo še zakone:
- Očitno lahko vsakemu tipu priredimo nov tip `List X`.
- $\eta_X(x) \bind_{X, Y} k = [x] \bind_{X, Y} k = fMap\ k\ [x] = k\ x$, direktno iz definicije.
- $m \bind_{X, X} \eta_X = [x \ | \ x \in m] = m$, direktno iz definicije.
- Asociativnost: Indukcija na $m$
    1. $m = []$:

        $([] \bind_{X, Y} k) \bind_{Y, Z} k' = [] \bind_{Y, Z} k' = [] = [] \bind_{X, Z} (x \mapsto k(x) \bind_{Y, Z} k')$.
    2. $m = x :: xs$:

       $((x :: xs) \bind_{X, Y} k) \bind_{Y, Z} k' = ((k\ x) @ (fMap \ f \ xs)) \bind_{Y, Z} k' = $
       $ = ((k\ x) @ (xs \bind_{X,Y} k)) \bind_{Y, Z} k' = ((k\ x) \bind_{Y, Z} k') @ ((xs \bind_{X,Y} k) \bind_{Y, Z} k') = $
       $ = [k' \ y \ | \ y \in k \ x ] @ (xs \bind_{X,Y} (x \mapsto (k \ x) \bind_{Y, Z} k')) = $
       $ = [k' \ y \ | \ y \in k \ x ] @ (fMap \ (x \mapsto (k \ x) \bind_{Y, Z} k') \ xs) = $
       $ = ((x \mapsto (k \ x) \bind_{Y, Z} k')\  x) @ (fMap \ (x \mapsto (k \ x) \bind_{Y, Z} k') \ xs) = $
       $= (fMap \ (x \mapsto (k \ x) \bind_{Y, Z} k') \ m) = (m \bind_{X, Z} (x \mapsto k(x) \bind_{Y, Z} k'))$.

       Kjer smo uporabili indukcijsko predpostavko in distributivnost `fMap` nad `@`.

## Monada `Writer` za pisanje v pomnilnik, do katerega ne moremo dostopati

- `T X = (X * List A)` ali $\kwdpre{Writer} X = X \times \kwdpre{List} W$.
- $\eta_X(x) = (x, [])$
- $m \bind_{X, Y} k = (y, w' @ w); \ kjer \ (x, w) = m \ in \ (y, w') = k \ x $ 
- Ker je $m$ točno določene oblike je lepši zapis $(x, w) \bind_{X, Y} k = (y, w' @ w); \ kjer (y, w') = k \ x$ ali $(x, w) \bind_{X, Y} k = (\pi_1(k \ x), \pi_2(k \ x) @ w )$

Preverimo še zakone:
- Očitno lahko vsakemu tipu priredimo nov tip `Writer X`.
- $\eta_X(x) \bind_{X, Y} k = (x, []) \bind_{X, Y} k = (y, w' @ []) = (y, w') = k\ x$, direktno iz definicije.
- $(x, w) \bind_{X, X} \eta_X = (x, [] @ w) m$, direktno iz definicije.
- $((x, w) \bind_{X, Y} k) \bind_{Y, Z} k' = (\pi_1(k\ x), \pi_2(k\ x) @ w) \bind_{Y, Z} k' = $
$ = (\pi_1(k'\ \pi_1(k \ x)), \pi_2(k' \ \pi_1(k \ x)) @ (\pi_2(k\ x) @ w))  = (z, w'' @ w' @ w) = $
$ = (\pi_1(k'\ \pi_1(k \ x)), \pi_2((\_, \pi_2( k' \ \pi_1(k \ x) @ \pi_2(k \ x)))) @ w)$
$ = (\pi_1(k'\ \pi_1(k \ x)), \pi_2(k\ x \bind_{Y, Z} k') @ w)$
  $ = ( \pi_1( (\pi_1(k'\ \pi_1(k\ x)), \pi_2(k' \pi_1(k x)))), \pi_2(k x \bind_{Y, Z} k') @ w)$
  $ = (\pi_1(k x \bind_{Y, Z} k'), \pi_2(k x \bind_{Y, Z} k') @ w)$
  $ = (x, w) \bind_{X, Z} (x' \mapsto k(x') \bind_{Y, Z} k')$.


## Monada `Reader` za branje iz okolja
- `T X = Env -> X`, ali $\kwdpre{Reader} X = Env \to X$.
- $\eta_X(x) = e \mapsto x$
- $m \bind_{X, Y} k = e \mapsto k \ (m\ e)\ e$

Opazimo, da ima $\bind_{X, Y}$ tip $(Env \to X) \to (X \to Env \to Y) \to Env \to Y$, torej je $k$ funkcija, ki sprejme vrednost $X$ in vrne funkcijo $Env \to Y$ - nekaj, kar še "čaka" na okolje.

Preverimo še zakone:
- Očitno lahko vsakemu tipu priredimo nov tip $Env \to X$.
- $\eta_X(x) \bind_{X, Y} k = (e' \mapsto x) \bind_{X, Y} k = e \mapsto k \ ((e' \mapsto x)\ e)\ e = e \mapsto k \ x\ e = k\ x$, direktno iz definicije.
- $m \bind_{X, X} \eta_X = e \mapsto \eta_X \ (m\ e)\ e = e \mapsto (e' \mapsto m\ e)\ e = e \mapsto m\ e = m$, direktno iz definicije.
- $((e' \mapsto x) \bind_{X, Y}) \bind_{Y, Z} k' = (e \mapsto k \ ((e' \mapsto x) \ e) \ e) \bind_{Y, Z} k' = (e \mapsto k \ x \ e) \bind_{Y, Z} k' =$
$ = e'' \mapsto k ' ((e \mapsto k \ x \ e) \ e'') \ e'' = e'' \mapsto k ' (k \ x \ e'') \ e'' =$
$ =  e'' \mapsto k' (k \ x \ e'') e'' = e \mapsto (e'' \mapsto k' ((k \ x) \ e'') e'') \ e = $
$ = e \mapsto (x' \mapsto (e'' \mapsto k' ((k \ x') \ e'') e'')) \ x \ e  = e \mapsto (x' \mapsto (k \ x') \bind_{Y, Z} k') \ x \ e = $
$e \mapsto (x' \mapsto (k \ x') \bind_{Y, Z} k') ((e' \mapsto x) e) e = (e' \mapsto x) \bind_{X,Z} (x' \mapsto (k \ x') \bind_{Y, Z} k')$

## Monada kontinuacij (ali `Cont`)

- `T X = (X -> R) -> R`, ali $\kwdpre{Cont} X = (X \to R) \to R$.
- $\eta_X(x) = k \mapsto k \ x$
- $m \bind_{X, Y} k = k' \mapsto m \ (x \mapsto k \ x \ k')$

Preverimo še zakone:
- Očitno lahko vsakemu tipu priredimo nov tip $(X \to R) \to R$.
- $\eta_X(x) \bind_{X, Y} k = (k' \mapsto k' \ x) \bind_{X, Y} k = k'' \mapsto (k' \mapsto k' \ x) \ (x' \mapsto k \ x' \ k'') = k'' \mapsto k \ x \ k'' = k \ x$, direktno iz definicije.
- $m \bind_{X, X} \eta_X = k \mapsto m \ (x \mapsto k \ x) = k \mapsto k \ (m \ x) = k$, direktno iz definicije.
- $((f \mapsto r) \bind_{X, Y} k) \bind_{Y, Z} k' = (k'' \mapsto (f \mapsto r) (x \mapsto k \ x \ k'')) \bind_{Y, Z} $