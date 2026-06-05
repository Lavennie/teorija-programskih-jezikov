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

Preverite, ali so sledeče konstrukcije domene ($\leq$ je standardna ureditev na $\mathbb{R}$).

1. $((0,1), \leq)$
2. $([0,1], \leq)$
3. $([0,1) \cup (2,3], \leq)$
4. $([0,1) \cup [2,3], \leq)$

## Naloga 2

Naj bo $\leq$ standardna ureditev na $\mathbb{N}$. Definirajte relacijo $\lessdot$ na množici $\mathbb{N} \to \mathbb{N}$ kot

$$f \lessdot g  \iff \forall n \in \mathbb{N}. f(n) \leq g(n).$$

Je $(\mathbb{N} \to \mathbb{N}, \lessdot)$ delno urejena množica? Je domena?

## Naloga 3

Naj bo $P$ končna delno urejena množica z najmanjšim elementom. Naj bo $D$ poljubna domena.

1. Pokažite, da je $P$ domena.
2. Dokažite, da je funkcija iz $P \to D$ zvezna natanko tedaj ko je monotona
3. Ali to velja tudi za $\mathbb{N}$? Kaj pa za $\mathbb{N}_\bot$ s plosko urejenostjo?

## Naloga 4

**Naj bodo $(D, \leq)$, $(D_1, \leq_1)$ in $(D_2, \leq_2)$ domene.**
**Z $\pi_1 : D_1 \times D_2 \to D_1, \pi_1(x,y) = x$ in $\pi_2 : D_1 \times D_2 \to D_2, \pi_2(x,y) = y$ označimo projekciji na prvo oz. drugo komponento.**
**Z $f^1_x : D_2 \to D, f^1_x(y) = f(x,y)$ in $f^2_y : D_1 \to D, f^2_y(x) = f(x,y)$ označimo sekciji funkcije $f : D_1 \times D_2 \to D$ za fiksno prvo oz. drugo komponento.**

**Dokažite sledeče trditve:**

1. **Funkcija $g: D \to D_1 \times D_2$, je zvezna natanko tedaj ko sta zvezni projekciji $\pi_1 \circ f$ in $\pi_2 \circ f$.**
2. **Funkcija $f: D_1 \times D_2 \to D$, je zvezna natanko tedaj ko sta zvezni sekciji $g^1_x$ in $g^2_y$.**

Naj bo $g$ poljubna funkcija, katere sekciji sta zvezni, računamo.
  - Vzemimo $(x,y) \leq (x',y')$, torej $x \leq_1 x'$ in $y \leq_2 y'$. $f(x,y) = f^1_x(y) \leq f^1_x(y') = f(x,y') = f^2_{y'}(x) \leq f^2_{y'}(x') = f(x',y')$. Neenakosti sledijo iz monotonosti sekcij, enakosti pa iz definicije sekcij.
  - Naj bo $(x, y)_i$ naraščajoča veriga. Lahko jo zapišemo po komponentah $(x_i, y_i)_i$, kjer velja $i \leq i' \implies x_i \leq_1 x_{i'} \land y_i \leq_2 y_{i'}$. Računamo.
  $f(\bigvee_i(x_i, y_i)) = f((\bigvee_i x_i, \bigvee_j y_j)) = f^1_{\bigvee_i x_i}(\bigvee_j y_j) = \bigvee_y f^1_{\bigvee_i x_i}(y_i) =$
  $ = \bigvee_j f(\bigvee_i x_i, y_j) = \bigvee_j f^2_{y_j}(\bigvee_i x_i) = \bigvee_j (\bigvee_i f^2_{y_j}(x_i)) = \bigvee_j (\bigvee_i f(x_i, y_j)) = \bigvee_i f(x_i, y_i)$.

  Vmesne enakosti sledijo iz zveznosti in definicije sekcij. Zadnja enakost pa iz leme s predavanj in dejstva, da je $(x_i, y_j)$ veriga.


## Naloga 5

Premislite, kako bi za podani domeni $(D_1, \leq_1)$ in $(D_1, \leq_2)$ skonstruirali domeno za produkt $D_1 \times D_2$ in vsoto $D_1 + D_2$. Premislite katere od možnosti bi bile primerne za modeliranje parov in vsot v neučakani oz. leni semantiki.

## Naloga 6

Operator $+_{\bot}$ definiramo kot:

$$ x +_{\bot} y = \begin{cases}
  \bot & x = \bot \vee  y=\bot \\
  x + y & \text{sicer}
\end{cases}$$

Izračunajte najmanjši fiksni točki funkcij $F, G: [\mathbb{N}_\bot \to \mathbb{N}_\bot] \to [\mathbb{N}_\bot \to \mathbb{N}_\bot]$

$$ F(f)(n) = \begin{cases}
  \bot & n = \bot \\
  0 & n = 0 \\
  (2n-1) +_\bot f(n) & n > 0
\end{cases} $$

$$ G(f)(n) = \begin{cases}
  \bot & n = \bot \\
  0 & n = 0 \\
  (2n-1) +_\bot f(n-1) & n > 0
\end{cases} $$

## Naloga 7

Naj bo $\mathbb{T} = \{tt, ff\}$ in $F : [\mathbb{N}_\bot \to \mathbb{T}_\bot] \to [\mathbb{N}_\bot \to \mathbb{T}_\bot]$,

$$ F(f)(n) = \begin{cases}
  \bot & n = \bot \\
  f(n+2) & n = 0 \\
  tt & n = 1 \\
  f(n-2) & n \geq 0
\end{cases} $$

Izračunajte najmanjšo fiksno točko $F$.

