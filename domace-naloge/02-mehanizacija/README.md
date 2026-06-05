# NAVODILA ZA DRUGO DOMAČO NALOGO

Naloga obsega razširitev intrinzične tipizacije jezika miniml.

Cilj domače naloge je jezik razširiti s pari, vsotami in seznami.

## Razširitev jezika
Jezik je delno že razširjen:
- Dodani so tipi `Prod`, `Sum` in `List`.
- Dodani so konstruktorji za izraze teh tipov (`mkpair`, `inl`, `inr`, `emptylist`, `cons`).
- Dodani so projekcijski izrazi (`fst`, `snd`) in pa `match` za vsote in sezname.

Vaša naloga je dopolniti obstoječe definicije (označene bodisi s `sorry` ali `TODO`) v datoteki `intrinzicni-tipi.lean` in popraviti dokaz napredka, da bo deloval za razširjeno obliko jezika.

Namig: Funkcija `substTwo` hkrati nadomesti dve spremenljivki, kar je potrebno za `match` konstrukte, kjer se v vzorcu pojavljata dve novi spremenljivki (npr. `x` in `xs` v primeru razgradnje seznama). V primeru, da bi želeli napisati dve ločeni substituciji, bi namreč naleteli na težave.

## Razširitev z lenim izvajanjem

V datoteki `intrinzicni-tipi-lazy.lean` je podan jezik z lenim izvajanjem. Vaša naloga je dopolniti definicije in popraviti dokaz napredka tudi za ta leno različico jezika.

## Oddaja

Datoteke domače naloge morate oddati prek spletne učilnice. Priporočamo, da nalogo vseeno pišete prek Gita, vendar v ločenem in zasebnem repozitoriju, da je ne bi kdo prepisal brez vaše vednosti.

**NALOGO MORATE REŠEVATI SAMOSTOJNO! ČE NE VESTE, ALI DOLOČENA STVAR POMENI SODELOVANJE, RAJE VPRAŠAJTE!**