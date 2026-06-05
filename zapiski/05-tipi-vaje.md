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

*S semantiko malih korakov izračunajte zaporedje korakov, ki izračunajo vrednost izrazov:*

1. `(2 * 2) + (3 * 3)`
2. `(fun x -> if x + 1 > 0 then x else 0) 12`
3. `(rec f x. if x = 0 then 1 else x * f (x - 1)) 3`

## Naloga 2

Zgornja operacijska semantika sledi neučakanemu izvajanju, saj pri uporabi funkcije najprej izračunamo vrednost argumenta in dobljeno vrednost substituiramo v telo funkcije. Pri lenem izvajanju pa pri uporabi funkcije argument še neizračunan substituiramo v telo funkcije. Popravite semantiko na leno izvajanje (potrebno je spremeniti zgolj pravila za aplikacijo funkcij) ter primerjajte izvajanje na primerih:

1. `(fun x -> (fun y -> if x > 0 then y else 0)) 1 (4*((4+2)*3))`
2. `(fun x -> (x * x) + x) (3*(2+(4*0)))`

## Naloga 3

*Preverite tipe izrazov. Izrazi morda nimajo primernega tipa. V tem primeru poiščite mesto, kjer se postopek zatakne.*

  1. `b:bool, x:int |- 1 + (if b then 2 else x) : int`
  2. `|- fun x -> (fun y -> x > y) : int -> int -> bool`
  3. `|- (rec f x -> if x then f x else 0) true : int`
  4. `f : int -> int |- (f 3) > (f (f 0)) 2 : bool`

## Naloga 4

Napišite nekaj izrazov, katerim ni možno dodeliti tipa, vendar se izračunajo v vrednost.

## Naloga 5

**Razširite jezik in sistem tipov s pari, seznami in vsotami. Za pare dodajte projekciji na posamezno komponento, za sezname in vsote pa dodajte razgrajevalnik `match`.**

**Kot dodaten izziv premislite, kako razširitve narediti v lenem izvajanju in napišite funkcijo, ki zgradi neskončen seznam ničel.**

Če nas ne zanima obnašanje jezika na zahtevnejših konstruktih (pri tem predmetu nas običajno ne), je jezik iz predavanj že povsem dovolj.
Je pa za praktično uporabo mnogo preveč okoren.
Naprednejše podatkovne tipe sicer lahko zakodiramo z osnovnimi konstrukti v lambda računu, vendar je to zelo nepraktično in tudi neučinkovito.
Prav tako nam vgrajene zmožnosti konstruktov (pari, seznami) omogočajo, da smo že med prevajanjem bolj učinkoviti, če recimo jezik ali tarčno okolje, v katerem pišemo prevajalnik ali tolmač omogočajo učinkovitejšo implementacijo.

Dodajanje parov (produktinih tipov) in vsot je enostavnejše, če se smemo omejiti na zgolj dva argumenta, vendar pravil ni težko razširiti tudi na poljubno število argumentov.

Pri dodajanju novh konstruktov (parov) načeloma postopamo po ustaljenem kopitu
1. Dodamo sintaktične konstrukte.
  1. Dodamo možnost za konstruiranje para iz že obstoječih izrazov.
  2. Dodamo možnost razgradnjo (uporabo) para.
  3. Dodamo nove vrednosti (če se pojavijo)
2. Dodamo tip (če je potrebno).
3. Za vsak nov sintaktični konstrukt dodamo pravilo za določitev tipa.
4. Dodamo nova pravila za izvajanje.

### Pari

$$
    \begin{align*}
    \text{izraz } M &::= ...
        \mid (M_1, M_2) \mid \fst M \mid \snd M
    \end{align*}
$$

$$
    \begin{align*}
    \text{tip } A,B &::= ...
         \mid A_1 \times A_2
    \end{align*}
$$

$$
    \text{vrednost } V ::= ... \mid (V_1, V_2)
$$

Prvi konstrukt konstruira par iz že obstoječih izrazov, druga dva pa par ustrezno razgradita, nove vrednosti pa so seveda pari že obstoječih vrednosti. Tip para je produkt tipov komponent.

Za vsak nov konstrukt moramo dodati pravilo za določitev tipa in pravilo (potencialno več) za izvajanje.

Določitev tipa je preprosta, ob poznavanju tipov komponent, tip para ni nič drugega kot produkt tipov komponent.
Pri razgradnji pa moramo upoštevati, da je tip para produkt tipov komponent, zato moramo pri razgradnji ustrezno razgraditi tudi tip.
Komponenta tipa, ki je ne uporabimo, je lahko poljubna.

$$
    \infer{\Gamma \vdash M_1 : A_1 \qquad \Gamma \vdash M_2 : A_2}{\Gamma \vdash (M_1, M_2) : A_1 \times A_2}

    \infer{\Gamma \vdash M : A_1 \times A_2}{\Gamma \vdash \fst M : A_1}

    \infer{\Gamma \vdash M : A_1 \times A_2}{\Gamma \vdash \snd M : A_2}
$$

$$
    \infer{M_1 \leadsto M_1'}{(M_1, M_2) \leadsto (M_1', M_2)}
    
    \infer{M_2 \leadsto M_2'}{(V_1, M_2) \leadsto (V_1, M_2')}

    \infer{M \leadsto M'}{\fst M \leadsto \fst M'}

    \infer{M \leadsto M'}{\snd M \leadsto \snd M'}

    \infer{}{\fst (V_1, V_2) \leadsto V_1}

    \infer{}{\snd (V_1, V_2) \leadsto V_2}
$$

Pravila za izvajanje so preprosta, par izvajamo po vrsti, dokler ne pridemo do vrednosti, pri razgradnji pa najprej izvajamo *argument* in ga, ko postne vrednost razgradimo.
Pravila za izvajanje komponent postavimo na tak način, da je izvajanje deterministično - najprej izvajamo prvo komponento, nato drugo.
Če je jezik čist (brez stranskih učinkov), bi lahko najprej izvajali tudi drugo komponento.

Za posodobite izreka o napredku je ključen podatek, da je edina vrednost, ki ima tip $A_1 \times A_2$ oblike $(V_1, V_2)$, in torej lahko vrednost s tipom para vedno razgradimo (tako imenovana lema o kanoničnih oblikah).

Ker je podajanje izrazov in tupov rekurzivno (najmanjša za pravila zaprta relacija), lahko z dovolj globokim gnezdenjem parov, skonstruiramo izraz, ki je izomorfen poljubni n-terici v OCamlu.

<!-- TODO: splošno pravilo za tuple>
<!-- https://hackage.haskell.org/package/base-4.19.0.0/docs/src/GHC.Show.html#line-263 -->

### Vsote

Vsotni (variantni) tipo predstavljajo pojavitev enega izmed dveh različnih tipov pod *eno streho* in jih običajno modeliramo z disjunktnimi unijami (koprodukti).
V OCamlu jih lahko definiramo z `type` in pripadajočimi konstruktorji.

```ocaml
type int_bool_either = Left of int | Right of bool
```

S tem smo definirali nov tip ` int_bool_either`, ki ima dva konstruktorja `Left` in `Right`, vsak izmed njiju *vloži* `int` oz. `bool` v skupni tip.

V naš jezik ne bomo dodali možnosti definiraja poljubnega tipa in pripadajočih konstruktorjev, ampak se bomo zadovoljili z vgrajenimi konstruktorji `INL` in `INR` za vgrajeni vsotni tip.

$$
    \begin{align*}
    \text{izraz } M &::= ...
        \mid \inl M \mid \inr M \mid \matchsum{M}{x_1}{M_1}{x_2}{M_2}
    \end{align*}
$$

$$ \text{vrednost } V ::= ... \mid \inl V \mid \inr V $$

Sintaksa je podobna kot pri parih, le da sta tu dva konstruktorja in en sam razgrajevalnik, ki pa vsebuje obe možnosti za obliko vsote.
Če bi imeli več konstruktorjev za isti tip, bi morali dodati več vej v razgrajevalnik.
Pomembno je, da je del $\inl x_1$ **vzorec** in ne izraz (običajno programski jeziki podpiranjo gnezdenje vzorcev, ki se mu bomo zaradi enostavnosti izognili), ki spremenljivki $x_1$ *priredi* vrednost v levi komponenti vsote.
Če to navidezno spominja na lambda abstrakcijo, je to namerno, saj lahko na vsako vejo razgrajevalnika gledamo kot na funkcijo, ki sprejme vrednost v vsoti in ji priredi telo te veje.

Pomembno je še omeniti, da smo lahko pri izbiri sintakse za razgrajevalnik mnogo bolj inovativni kot pri parih, saj si lahko izberemo praktično karkoli.
Navadno je merilo za izbiro sintakse nek smiselen kompromis med berljivostjo, kratkostjo in enostavnostjo pisanja razčlenjevalnika za jezik.

$$
    \begin{align*}
    \text{tip } A,B &::= ...
         \mid A_1 + A_2
    \end{align*}
$$

Tipi in vrednosti so direktni.

$$
    \infer{\Gamma \vdash M : A_1}{\Gamma \vdash \inl M : A_1 + A_2}

    \infer{\Gamma \vdash M : A_2}{\Gamma \vdash \inr M : A_1 + A_2}

    \infer{\Gamma \vdash M : A_1 + A_2 \qquad \Gamma, x_1 : A_1 \vdash M_1 : B \qquad \Gamma, x_2 : A_2 \vdash M_2 : B}{\Gamma \vdash \matchsum{M}{x_1}{M_1}{x_2}{M_2} : B}
$$

Pri razgrajevalniku zahtevamo, da imata obe veji enak tip, saj je vrednost vsote lahko vložena s poljubnim konstruktorjem.
Pogoj za posamezno vejo razčlenjevalnika pa je enak kot pri lambda abstrakciji, le da je tu tip spremenljivke že določen s krovnim tipom vsote.

Pravila za izvajanje so enostavna, razgrajevalnik nekoliko spominja na pogojni stavek, ki potem izvajanje nadaljuje z lambda abstrakcijo v telesu veje.

$$
    \infer{M \leadsto M'}{\inl M \leadsto \inl M'}

    \infer{M \leadsto M'}{\inr M \leadsto \inr M'}

    \infer{M \leadsto M'}{\matchsum{M}{x_1}{M_1}{x_2}{M_2} \leadsto \matchsum{M'}{x_1}{M_1}{x_2}{M_2}}

    \infer{}{\matchsum{\inl V}{x_1}{M_1}{x_2}{M_2} \leadsto M_1[V/x_1]}

    \infer{}{\matchsum{\inr V}{x_1}{M_1}{x_2}{M_2} \leadsto M_2[V/x_2]}
$$

<!-- TODO: dodajanje lastnih konstruktorjev, CH isomorphism? -->
<!-- https://stackoverflow.com/a/6237886/1062835 -->

### Seznami

Seznami so samo poseben primer vsot, kjer prvi konstruktor ne sprejme dodantih argumentov, drugi pa sprejme dva (ali pa en sam, ki je par).

$$
    \begin{align*}
    \text{izraz } M &::= ...
        \mid [] \mid M_1 :: M_2 \mid \matchlist{M}{M_1}{x_1}{x_2}{M_2}
    \end{align*}
$$

$$ \text{vrednost } V ::= ... \mid [] \mid V_1 :: V_2 $$

$$
    \begin{align*}
    \text{tip } A,B &::= ...
         \mid \kwdpre{list} A
    \end{align*}
$$

$$
    \infer{}{\Gamma \vdash [] : \kwdpre{list} A}

    \infer{\Gamma \vdash M_1 : A \qquad \Gamma \vdash M_2 : \kwdpre{list} A}{\Gamma \vdash M_1 :: M_2 : \kwdpre{list} A}

    \infer{\Gamma \vdash M : \kwdpre{list} A \qquad \Gamma \vdash M_1 : B \qquad \Gamma, x_1 : A, x_2 : \kwdpre{list} A \vdash M_2 : B}{\Gamma \vdash \matchlist{M}{M_1}{x_1}{x_2}{M_2} : B}
$$

$$
    \infer{M_1 \leadsto M_1'}{M_1 :: M_2 \leadsto M_1' :: M_2}

    \infer{M_2 \leadsto M_2'}{V_1 :: M_2 \leadsto V_1 :: M_2'}

    \infer{M \leadsto M'}{\matchlist{M}{M_1}{x_1}{x_2}{M_2} \leadsto \matchlist{M'}{M_1}{x_1}{x_2}{M_2}}

    \infer{}{\matchlist{[]}{M_1}{x_1}{x_2}{M_2} \leadsto M_1}

    \infer{}{\matchlist{V_1 :: V_2}{M_1}{x_1}{x_2}{M_2} \leadsto M_2[V_1/x_1, V_2/x_2]}
$$

<!-- records -->

### Leno izvajanje

Pri lenem izvajanju (ang.~Call by name - CBN), izrazov ne izvajamo, dokler jih ne potrebujemo.
Pri aplikaciji funkcije torej ne izračunamo vrednosti argumenta, ampak ga kar substituiramo v telo funkcije, tudi izraz, na katerega apliciramo argument računamo le toliko časa, da pridemo do ustrezne oblike, kjer lahko opravimo substitucijo.

Za naše dodane konstrutke to pomeni, da pri parih ne izračunamo vrednosti komponent, saj je dovolj, da pridemo do oblike (par dveh izrazov).
Pri razgradnji para dobimo le komponento, ki jo potrebujem in še to izračunamo, ko jo res potrebujemo.

Sintasa in tipi ostanejo povsod ostanejo enaki, pravila za izvajanje pa se spremenijo tako, da ostanejo zgolj sledeča:

$$
    \infer{M \leadsto M'}{\fst M \leadsto \fst M'}

    \infer{M \leadsto M'}{\snd M \leadsto \snd M'}

    \infer{}{\fst (M_1, M_2) \leadsto M_1}

    \infer{}{\snd (M_1, M_2) \leadsto M_2}

    \infer{M \leadsto M'}{\matchsum{M}{x_1}{M_1}{x_2}{M_2} \leadsto \matchsum{M'}{x_1}{M_1}{x_2}{M_2}}

    \infer{}{\matchsum{\inl M}{x_1}{M_1}{x_2}{M_2} \leadsto M_1[M/x_1]}

    \infer{}{\matchsum{\inr M}{x_1}{M_1}{x_2}{M_2} \leadsto M_2[M/x_2]}

    \infer{M \leadsto M'}{\matchlist{M}{M_1}{x_1}{x_2}{M_2} \leadsto \matchlist{M'}{M_1}{x_1}{x_2}{M_2}}

    \infer{}{\matchlist{[]}{M_1}{x_1}{x_2}{M_2} \leadsto M_1}

    \infer{}{\matchlist{M'_1 :: M'_2}{M_1}{x_1}{x_2}{M_2} \leadsto M_2[M'_1/x_1, M'_2/x_2]}
$$

Ključna razlika je, da sedaj pri razgradnji deli niso nujno več vrednosti, ampak poljubni izrazi.

## Naloga 6

V jeziku iz naloge 3 poiščite primeren tip za spodnji izraz in ustreznost preverite z izpeljavo, v primeru ko sta s `fst` in `snd` označeni projekciji na prvo in drugo komponento para.

``` (fun p -> (match fst p with [] -> true | x :: xs -> snd p)) (1::2::[], false) ```

## Naloga 7

Pokažite, kako lahko v jezik dodamo medsebojno rekurzivne funkcije.
