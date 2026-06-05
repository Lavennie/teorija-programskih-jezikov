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

Izpeljite in rešite enačbe za izpeljavo tipov naslednjih programov:

1. `|- (fun x -> x * x) 14`
2. `f : α, v : bool |- if f v then 1 else 0`
3. `g : bool -> α |- (fun f -> f (g true)) (fun x -> x + 2)`

Preverite, ali vrstni red enačb vpliva na rezultat. Ugotovite kje se pojavi problem pri določanju tipa funkcije `fun f -> f f`.

## Naloga 2

**Algoritem za izpeljavo tipov dopolnite za: rekurzijo, pare, vsote in sezname.**

Kot pri dodajanju novih pravil za tipe moramo za vsak nov sintaktični konstrukt dodati pravilo za izpeljavo tipa in dodatne enačbe.
Glede na dodajanje novih enačb moramo tudi posodobiti pravila za reševanje sistema enačb.

$$

    \infer{
        \Gamma, f : \alpha \to \beta, x : \alpha \vdash M : B \mid \eqs
    }{
        \Gamma \vdash \kwdpre{rec} f \, x . M : \alpha \to \beta \mid \alpha = A, \beta  = B, \eqs
    }

    \infer{\Gamma \vdash M_1 : A_1 \mid \eqs_1 \qquad \Gamma \vdash M_2 : A_2 \mid \eqs_2}{\Gamma \vdash (M_1, M_2) : \alpha_1 \times \alpha_2 \mid \alpha_1 = A_1, \alpha_2 = A_2, \eqs_1, \eqs_2}

    \infer{\Gamma \vdash M : A \mid \eqs}{\Gamma \vdash \fst M : \alpha_1 \mid \alpha_1 \times \alpha_2 = A, \eqs}

    \infer{\Gamma \vdash M : A \mid \eqs}{\Gamma \vdash \snd M : \alpha_2 \mid \alpha_1 \times \alpha_2 = A, \eqs}

    \infer{\Gamma \vdash M : A_1 \mid \eqs}{\Gamma \vdash \inl M : \alpha \mid \alpha = A_1 + \alpha_2, \eqs}

    \infer{\Gamma \vdash M : A_2 \mid \eqs}{\Gamma \vdash \inr M : \alpha \mid \alpha = \alpha_1 + A_2, \eqs}

    \infer{\Gamma \vdash M : A \mid \eqs \qquad \Gamma, x_1 : \alpha_1 \vdash M_1 : B_1 \mid \eqs_1 \qquad \Gamma, x_2 : \alpha_2 \vdash M_2 : B_2 \mid \eqs_2}{\Gamma \vdash \matchsum{M}{x_1}{M_1}{x_2}{M_2} : \beta \mid \beta = B_1, \beta = B_2, \alpha_1 + \alpha_2 = A, \eqs, \eqs_1, \eqs_2}

    \infer{}{\Gamma \vdash [] : \kwdpre{list} \alpha \mid \emptyset}

    \infer{\Gamma \vdash M_1 : A_1 \mid \eqs_1  \qquad \Gamma \vdash M_2 : A_2 \mid \eqs_2}{\Gamma \vdash M_1 :: M_2 : \alpha \mid \alpha = \kwdpre{list} A_1, \alpha = A_2, \eqs_1, \eqs_2}

    \infer{\Gamma \vdash M : A \mid \eqs_1 \qquad \Gamma \vdash M_1 : A_1 \mid \eqs_2 \qquad \Gamma, x_1 : \alpha_1, x_2 : \alpha_2 \vdash M_2 : A_2 \mid \eqs_3}{\Gamma \vdash \matchlist{M}{M_1}{x_1}{x_2}{M_2} : \alpha \mid \alpha = A_1, \alpha = A_2, A = \kwdpre{list} \alpha_1, A = \alpha_2, \eqs_1, \eqs_2, \eqs_3}
$$

Možnosti za dodajanje pravil je več, pri nekaterih lahko že nekoliko rešimo enačbe, lahko pa sestavimo bolj splošna pravila in reševanje enačb prepustimo algoritmu za reševanje.
Vseeno pa je treba biti pozoren, napačno pravilo za konstrukcijo seznama bi namreč bilo

$$
    \infer{\Gamma \vdash M_1 : A_1 \mid \eqs_1  \qquad \Gamma \vdash M_2 : \kwdpre{list} A_2 \mid \eqs_2}{\Gamma \vdash M_1 :: M_2 : \alpha \mid \alpha = \kwdpre{list} A_1, \alpha = \kwdpre{list} A_2, \eqs_1, \eqs_2}
$$

saj bi v primeru konstrukcije seznama `1 :: []` za tip `[]` dobili $\alpha'$, ki pa ni oblike $\kwdpre{list} A$ in tipa ne bi mogli izpeljati.

Dodatna pravila za reševanje enačb so potrebna zato, da lahko razrešimo nove oblike tipov, ki smo jih uvedli.

$$
\infer{
  A_1 = B_1, A_2 = B_2, \eqs \searrow \sigma
}{
  A_1 \times A_2 = B_1 \times B_2, \eqs \searrow \sigma
}\\[2em]

\infer{
  A_1 = B_1, A_2 = B_2, \eqs \searrow \sigma
}{
  A_1 + A_2 = B_1 + B_2, \eqs \searrow \sigma
}\\[2em]

\infer{
  A = B, \eqs \searrow \sigma
}{
  \kwdpre{list} A = \kwdpre{list} B, \eqs \searrow \sigma
}
$$

Posodobiti pa moramo tudi funkcijo $fv$ kot

$$
  fv(A_1 \times A_2) = fv(A_1) \cup fv(A_2) \qquad fv(A_1 + A_2) = fv(A_1) \cup fv(A_2) \qquad fv(\kwdpre{list} A) = fv(A)
$$

Z dodajanjem novih oblik tipov je vedno več enačb "nerešljivih", saj nimajo ujemajočih oblik.






## Naloga 3

Izpeljite tip funkcije `map`. Napišite še kakšen program, ki uporablja konstrukte iz naloge 2 in mu določite tip.
