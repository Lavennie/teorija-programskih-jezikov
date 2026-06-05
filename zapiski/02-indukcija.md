# Indukcija

## Induktivne množice

Induktivne množice so definirane kot najmanjše množice, ki so zaprte za dane konstrukcije elementov.

### Naravna števila

Na primer, množico naravnih števil $\mathbb{N}$ lahko definiramo kot **najmanjšo** množico, ki:

 vsebuje $0$ in
 za poljuben $n$ vsebuje tudi njegovega naslednika $n^+$.

Pravili dostikrat zapišemo tudi v obliki:

$$
  \infer{}{0 \in \mathbb{N}} \qquad \infer{n \in \mathbb{N}}{n^+ \in \mathbb{N}}
$$

V splošnem bomo uporabljali pravila oblike

$$
  \infer{h_1 \quad h_2 \quad \cdots \quad h_n}{c},
$$

kjer nad črto pišemo _predpostavke_ $h_1, \dots, h_n$, pod črto pa _zaključek_ $c$. Pravilom oblike

$$
  \infer{}{\quad c \quad},
$$

ki nad črto nimajo predpostavk, pravimo _aksiomi_.

Katere elemente vsebuje $\mathbb{N}$?

1. Zaradi prvega pogoja mora veljati $0 \in \mathbb{N}$.
2. Sedaj mora zaradi drugega pogoja $\mathbb{N}$ vsebovati tudi $0^+$, ki ga označimo z $1$.
3. Podobno nadaljujemo in vidimo, da $\mathbb{N}$ vsebuje tudi $1^+ = 2$.

Na vsakem koraku dobimo novo naravno število in obratno, vsak element $\mathbb{N}$ dobimo tako, da končno mnogokrat uporabimo eno od zgoraj naštetih pravil (čeprav resda prav veliko izbire nimamo).

### Aritmetični izrazi

Podobno lahko množico aritmetičnih izrazov $\mathbb{E}$, ki smo jo definirali že z BNF sintakso

$$
  e ::= n \ |\ e_1 + e_2 \ |\ e_1 * e_2 \ |\ -e,
$$

definiramo tudi kot najmanjšo množico, ki:

* vsebuje vsako celo število $n$,
* za poljubna izraza $e_1, e_2 \in \mathbb{E}$ vsebuje tudi izraz $e_1 + e_2$,
* za poljubna izraza $e_1, e_2 \in \mathbb{E}$ vsebuje tudi izraz $e_1 * e_2$ in
* za poljuben izraz $e \in \mathbb{E}$ vsebuje tudi izraz $-e$;

oziroma s pravili

$$
  \infer{}{n \in \mathbb{E}}(n \in \mathbb{N})
  \quad
  \infer{e_1 \in \mathbb{E}\quad e_2 \in \mathbb{E}}{e_1 + e_2 \in \mathbb{E}}
  \quad
  \infer{e_1 \in \mathbb{E}\quad e_2 \in \mathbb{E}}{e_1 * e_2 \in \mathbb{E}}
  \quad
  \infer{e \in \mathbb{E}}{-e \in \mathbb{E}}
$$

Opazimo, da smo pri prvem pravilu $n \in \mathbb{N}$ zapisali kot stranski pogoj, saj je množica $\mathbb{N}$ že definirana in ni podana z napisanimi pravili.

Tudi tu vse elemente $\mathbb{E}$ dobimo tako, da končno mnogokrat uporabljamo pravila.

1. Najprej vidimo, da $\mathbb{E}$ vsebuje vsa števila $\dots, -2, -1, 0, 1, 2, \dots$.
2. Sedaj iz preostalih treh pravil sledi, da mora $\mathbb{E}$ poleg tega vsebovati tudi vse njihove vsote $(0 + 0), (0 + 1), (1 + 0), (-2 + 3), \dots$, njihove produkte $(0 \ast 0), (0 \ast 1), (1 \ast 0), (-2 \ast 3), \dots$ ter njihove negacije $-0, -1, -(-42), \dots$
3. Nato vidimo, da mora $\mathbb{E}$ vsebovati tudi vse kombinacije elementov, ki smo jih dobili v prejšnjih korakih, na primer $(-2 + 3) \ast (0 \ast 1)$ ali $-(-42) + (6 \ast 7)$.

Če postopek nadaljujemo, dobimo vse elemente množice $\mathbb{E}$, vsakega v končno mnogo korakih. Vsakemu elementu $e \in \mathbb{E}$ pripada tudi natanko določeno _drevo izpeljave_, iz katerega se vidi, kako smo prišli do dejstva, da $\mathbb{E}$ vsebuje $e$. V tem drevesu je $e$ koren, pravila so vozlišča, aksiomi pa listi. Na primer, elementu $42 + (6 \ast 7)$ pripada drevo

$$
  \infer
    {
      \infer
        {}
        {42 \in \mathbb{E}}
      \quad
      \infer
        {\infer{}{6 \in \mathbb{E}} \quad \infer{}{7 \in \mathbb{E}}}
      {6 \ast 7 \in \mathbb{E}}
    }
    {42 + (6 \ast 7) \in \mathbb{E}}
$$

Vidimo, da na $n$-tem koraku dobimo ravno tiste elemente z drevesom izpeljave višine $n$.

### Induktivno podane relacije

Pri teoriji programskih jezikov bomo pogosto uporabljali induktivno podane relacije, s katerimi bomo na primer definirali, kdaj se en izraz evalvira v drugega ali pa kdaj ima dani izraz veljaven tip. V preostanku tega razdelka pa si bomo izbrali bolj enostaven primer in sicer soda naravna števila.

Ker so relacije definirane kot podmnožice domene, bi lahko induktivno podane relacije podali kot najmanjše podmnožice, zaprte za dana pravila. Tako bi množico sodih naravnih števil definirali kot najmanjšo podmnožico $S \subseteq \mathbb{N}$, zaprto za pravili:

$$
  \infer{}{0 \in S}
  \quad
  \infer{n \in S}{n + 2 \in S}
$$

Da pa bomo vse spravili pod eno samo definicijo, hkrati pa še bolj zvesto sledili pristopu, ki ga uporablja Agda, bomo raje definirali družino množic $\mathsf{sodo}_n$, ki bodo predstavljale dokaze, da je $n$ sodo število. Množica $\mathsf{sodo}_n$ bo torej neprazna, kadar bo $n$ sodo, in prazna, kadar bo $n$ liho. Zgornji pravili bi tako lahko napisali kot:

$$
  \infer{}{\mathsf{nicJeSodo} \in \mathsf{sodo}_0}
  \quad
  \infer{p \in \mathsf{sodo}_n}{\mathsf{sodoPlusDvaJeSodo} \, p \in \mathsf{sodo}_{n + 2}}
$$

Za množice $\mathsf{sodo}_n$ imamo torej dva konstruktorja. Konstanto $\mathsf{nicJeSodo}$ ter konstruktor $\mathsf{sodoPlusDvaJeSodo}$, ki dokaže, da je $n + 2$ sodo, kadar obstaja dokaz $p$, da je $n$ sodo. Preverimo lahko, da je množica $\mathsf{sodo}_n$ neprazna natanko tedaj, kadar je $n \in S$.

Pri relacijah bomo pravila za konstrukcijo množic pisali malo drugače, da bomo bolj poudarili njihovo vsebino:

$$
\def\sc#1{\small\dosc#1\csod} \def\dosc#1#2\csod{{\rm #1{\scriptsize #2}}}
  \infer{}{0 \, \mathsf{sodo}} \sc{NIC}\sc{JE}\sc{SODO}
  \quad
  \infer{n \, \mathsf{sodo}}{n + 2 \, \mathsf{sodo}} \sc{SODO}\sc{PLUS}\sc{DVA}\sc{JE}\sc{SODO}
$$

Če nas imena pravil (torej konstruktorjev) ne bodo zanimala, jih bomo izpustili.

## Konstrukcija induktivnih množic

### Predstavitev množice pravil s funktorjem

Induktivne množice bomo gradili po korakih: v prvem koraku bomo dodali vse elemente, ki sledijo iz aksiomov, nato tiste, ki imajo drevesa izpeljave z globino 1, tiste z globino 2 in tako naprej. Pri tem bomo vsako množico pravil predstavili s _funktorjem_.

> **Definicija.** _Funktor_ $F$ (v kategoriji $\mathbf{Set}$, za tiste, ki poznate teorijo kategorij) je predpis, ki:
> 
> - vsaki množici $X$ priredi množico $F X$,
> - vsaki preslikavi $f : X \to Y$ priredi preslikavo $F f : F X \to F Y$,
>
> tako da velja:
>
> - $F \mathrm{id}_X = \mathrm{id}_{F X}$
> - $F (g \circ f) = F g \circ F f$

Nekaj osnovnih primerov funktorjev, ki jih bomo uporabljali:

- **Identiteta** $I$: $I X = X$ in $I f = f$.
- **Konstanta** $A$ za poljubno množico $A$: $A X = A$ in $A f = \mathrm{id}_A$.
- **Potenčna množica** $\mathcal{P}$: $\mathcal{P} X = \{ S \mid S \subseteq X \}$ in $\mathcal{P} f : S \mapsto \{ f(x) \mid x \in S \}$.
- **Vsota funktorjev** $F$ in $G$: $(F + G) X = F X + G X$, na preslikavah pa $(F + G) f$ deluje kot:
  $$ \begin{align*} ((F + G) f) (\iota_1(x)) &= \iota_1(F f (x)) \\ ((F + G) f) (\iota_2(y)) &= \iota_2(G f (y)) \end{align*} $$
- **Produkt funktorjev** $F$ in $G$: $(F \times G) X = F X \times G X$, na preslikavah pa $(F \times G) f$ deluje kot:
  $$ ((F \times G) f) (x, y) = (F f (x), G f (y)) $$

Običajno bomo delovanje funktorja določili samo za množice, saj bo vedenje na preslikavah očitno.

Funktor $F$ bo množico $X$ slikal v množico $F X$, sestavljeno iz vseh zaključkov pravil, katerih predpostavke so vsebovane v $X$. Množica $X$ bo torej zaprta za pravila natanko tedaj, kadar bo $F X \subseteq X$. "Ulomke", kot smo jih pisali doslej, bomo uporabljali še naprej, vendar nam bodo le služili kot krajši zapis funktorja $F$.

Za primer si oglejmo množico naravnih števil. Spomnimo se na pravili:

$$
  \infer{}{0 \in \mathbb{N}}
  \quad
  \infer{n \in \mathbb{N}}{n^+ \in \mathbb{N}}
$$

Ker so naravna števila dveh različnih oblik (nič oz. naslednik), bo v konstrukciji množice $F X$ nastopala disjunktna vsota. Ničla nima nobenega dodatnega argumenta, zato jo bomo predstavili z $\iota_1(\ast)$, kjer je $\ast$ edini element singletona $1$. Naslednik pa ima en argument, ki mora priti iz množice predpostavk, zato ga bomo predstavili z $\iota_2(x)$, kjer je $x \in X$. Zato bomo množico pravil za naravna števila predstavili s funktorjem $F X = 1 + X$. Število $2$ bi predstavljal element $\iota_2(\iota_2(\iota_1(\ast)))$

V splošnem vsakemu pravilu ustreza en sumand v disjunktni vsoti, sestavljen iz množic, ki ustrezajo predpostavkam pravil. Recimo, pravilom za aritmetične izraze

$$
  \infer{}{n \in \mathbb{E}}(n \in \mathbb{N})
  \quad
  \infer{e_1 \in \mathbb{E}\quad e_2 \in \mathbb{E}}{e_1 + e_2 \in \mathbb{E}}
  \quad
  \infer{e_1 \in \mathbb{E}\quad e_2 \in \mathbb{E}}{e_1 * e_2 \in \mathbb{E}}
  \quad
  \infer{e \in \mathbb{E}}{-e \in \mathbb{E}}
$$

ustreza funktor, ki množice slika kot:

$$
  F X = \mathbb{N} + (X \times X) + (X \times X) + X
$$

### Konstrukcija množice iz funktorja

> **Izrek.**
> Naj bo funktor $F$:
>
> * monoton: $X \subseteq Y \implies F X \subseteq F Y$, in
> * Scottovo zvezen: $F X = \bigcup_{A \subseteq^{\text{končna}} X} F A$
>
> Tedaj je množica $\mu F := \bigcup_{i = 1}^\infty F^i \emptyset$ najmanjša množica, zaprta za $F$.

Konstantni in identični funktor zadoščata obema pogojema, ravno tako pogoje ohranjata produkt in vsota funktorjev, ter s tem tudi funktorji, s katerimi smo definirali naravna števila in aritmetične izraze. Primer funktorja, ki ne zadošča drugemu pogoju je potenciranje $X \mapsto \mathcal{P} X$ (razmislite, zakaj $F \mathbb{N} \ne \bigcup_{A \subseteq^{\text{končna}} \mathbb{N}} F A$).

_Dokaz._ Definirajmo zaporedje

$$
  I_0 = \emptyset \qquad I_{n + 1} = F I_n
$$

ter pokažimo, da je $\mu F = \bigcup_{n = 0}^{\infty} I_n = \bigcup_{i = 1}^\infty F^i \emptyset = \mu F$ najmanjša množica, zaprta za $F$. Preverimo lahko, da $I_n$ vsebuje natanko tiste elemente, katerih drevo izpeljave ima globino kvečjemu $n$.

Pokažimo najprej, da je $F \mu F \subseteq \mu F$. Ker je $F$ definirana z vrednostmi na končnih podmnožicah, velja

$$
  F \mu F = \bigcup_{A \subseteq^{\text{končna}} \mu F} F A
$$

Ker je $\mu F = \bigcup_{n = 0}^{\infty} I_n$, za vsako končno $A \subseteq \mu F$ obstaja tak $n$, da je $A \subseteq I_n$. Ker je $F$ monotona, je $F A \subseteq F I_n = I_{n + 1} \subseteq \mu F$. Torej je tudi $\bigcup_{A \subseteq^{\text{končna}} \mu F} F A \subseteq \mu F$.

Vzemimo še množico $X$, da velja $F X \subseteq X$ ter pokažimo, da je $\mu F \subseteq X$. Z indukcijo najprej pokažimo, da je $I_n \subseteq X$. Ker je $I_0 = \emptyset \subseteq X$, je osnovni korak trivialen. Sedaj predpostavimo, da velja $I_n \subseteq X$. Tedaj velja tudi $I_{n + 1} = F I_n \subseteq F X \subseteq X$, saj je preslikava $F$ monotona. Ker so vsi členi $I_n \subseteq X$, velja tudi $\mu F = \bigcup_{n = 0}^{\infty} I_n \subseteq X$. ∎

### Dokazovanje z indukcijo

To lastnost lahko uporabimo za _dokazovanje z indukcijo_. Vsak predikat $P$ na $\mu F$ lahko predstavimo z množico $Q = \{ x \in \mu F \mid P(x) \}$. Če velja $F Q \subseteq Q$, mora biti $Q = \mu F$, saj je $\mu F$ najmanjša množica, zaprta za $F$. Na primer, za $F X = 1 + X$ in $\mu F = \mathbb{N}$ se trditev $F Q \subseteq Q$ prevede na $1 + Q \subseteq Q$. To pomeni, da mora veljati $\iota_1(\ast) \in Q$ ter $\iota_2(n) \in Q$ za vsak $n \in Q$. Prvi pogoj nam pove, da je $0 \in Q$, drugi pogoj pa, da iz $n \in Q$ sledi $n^+ \in Q$, kar je skupaj ravno običajno načelo indukcije

$$
  P(0) \land (\forall n \in \mathbb{N}. P(n) \Rightarrow P(n^+)) \implies \forall m \in \mathbb{N}. P(m)
$$

Za aritmetične izraze in $F X = \mathbb{N} + (X \times X) + (X \times X) + X$ podobno dobimo načelo indukcije

$$\begin{aligned}
  &(\forall n \in \mathbb{N} . P(n)) \\
  &\land (\forall e_1, e_2 \in \mathbb{E}. P(e_1) \land P(e_2) \Rightarrow P(e_1 + e_2)) \\
  &\land (\forall e_1, e_2 \in \mathbb{E}. P(e_1) \land P(e_2) \Rightarrow P(e_1 \ast e_2)) \\
  &\land (\forall e \in \mathbb{E}. P(e) \Rightarrow P(-e)) \\
  &\implies \forall e \in \mathbb{E}. P(e)
\end{aligned}$$

### Strukturna rekurzija in algebre funktorjev

Funkcije na induktivnih tipih običajno definiramo rekurzivno. Na primer, evalvacija aritmetičnih izrazov $\mathsf{ev} : \mathbb{E} \to \mathbb{Z}$ je podana kot:

$$ \begin{align*}
  \mathsf{ev}(\underline{n})
    &= n \\
  \mathsf{ev}(e_1 + e_2)
    &= \mathsf{ev}(e_1) + \mathsf{ev}(e_2) \\
  \mathsf{ev}(e_1 * e_2)
    &= \mathsf{ev}(e_1) \cdot \mathsf{ev}(e_2)  \\
  \mathsf{ev}(-e)
    &= -\mathsf{ev}(e)
\end{align*} $$

V večini primerov uporabljamo _strukturno rekurzijo_, ki jo lahko razbijemo na: (1) rekurzivne klice na posameznih podizrazih in (2) operacije, s katerimi rezultate klicev združimo v končen rezultat. Na primer, vedenje funkcije $\mathsf{ev}$ lahko zapišemo kot:

$$ \begin{align*}
  \mathsf{ev}(\underline{n})
    &= \alpha_1(n) \\
  \mathsf{ev}(e_1 + e_2)
    &= \alpha_2(\mathsf{ev}(e_1), \mathsf{ev}(e_2)) \\
  \mathsf{ev}(e_1 * e_2)
    &= \alpha_3(\mathsf{ev}(e_1), \mathsf{ev}(e_2))  \\
  \mathsf{ev}(-e)
    &= \alpha_4(\mathsf{ev}(e))
\end{align*} $$

kjer je:

$$ \begin{align*}
\alpha_1 &: \mathbb{N} \to \mathbb{Z} & \alpha_1(n) &= n \\
\alpha_2 &: \mathbb{Z} \times \mathbb{Z} \to \mathbb{Z} & \alpha_2(x, y) &= x + y \\
\alpha_3 &: \mathbb{Z} \times \mathbb{Z} \to \mathbb{Z} & \alpha_3(x, y) &= x \cdot y \\
\alpha_4 &: \mathbb{Z} \to \mathbb{Z} & \alpha_4(x) &= -x \\
\end{align*} $$

Vemo, da lahko par funkcij iz $X \to Z$ in $Y \to Z$ ekvivalentno zapišemo kot funkcijo iz $X + Y \to Z$. Na enak način lahko zgornje funkcije zložimo v eno samo funkcijo:

$$ \alpha : (\mathbb{N} + \mathbb{Z} \times \mathbb{Z} + \mathbb{Z} \times \mathbb{Z} + \mathbb{Z}) \to \mathbb{Z} $$

v čemer prepoznamo $\alpha : F \mathbb{Z} \to \mathbb{Z}$.

Splošen zapis z vrednostmi s tem preide na:

$$ \begin{align*} \mathsf{ev}(\iota_1(n)) &= \alpha (\iota_1(n)) \\ \mathsf{ev}(\iota_2(\langle e_1, e_2\rangle)) &= \alpha (\iota_2(\langle\mathsf{ev}(e_1), \mathsf{ev}(e_2)\rangle)) \\ \mathsf{ev}(\iota_3(\langle e_1, e_2\rangle)) &= \alpha (\iota_3(\langle\mathsf{ev}(e_1), \mathsf{ev}(e_2)\rangle))  \\ \mathsf{ev}(\iota_4(e)) &= \alpha(\iota_4(\mathsf{ev}(e))) \end{align*} $$

Če po pravilih za vsoto in produkt funktorjev razpišemo delovanje funktorja $F$ na preslikavi $f : X \to Y$, dobimo $F f : F X \to F Y$, ki deluje kot:

$$ \begin{align*}
  (F f)(\iota_1(n)) &= \iota_1(n) \\
  (F f)(\iota_2(\langle x_1, x_2\rangle)) &= \iota_2(\langle f(x_1), f(x_2)\rangle) \\
  (F f)(\iota_3(\langle x_1, x_2\rangle)) &= \iota_3(\langle f(x_1), f(x_2)\rangle)  \\
  (F f)(\iota_4(x)) &= \iota_4(f(x))
  \end{align*} $$

Torej lahko zgornji sistem rekurzivnih enačb za $\mathsf{ev}$ na kratko zapišemo kot $\mathsf{ev} = \alpha \circ F\mathsf{ev}$. Ta konstrukcija je samo posledica splošne lastnosti, ki jo ima množica $\mu F$.

**Definicija.** Naj bo $F$ funktor. Preslikavi $\alpha : F X \to X$ pravimo **algebra za $F$**. Pravimo, da je $f : X \to Y$ **homomorfizem** med algebrama $\alpha : F X \to X$ in $\beta : F Y \to Y$, če velja $f \circ \alpha = \beta \circ F f$.

**Trditev.** Vzemimo funktor $F$, ki zadošča monotonosti in Scottovi zveznosti, ter naj bo $\mu F$ najmanjša množica, zaprta za ta funktor. Tedaj je $\mathrm{id} : F \mu F \to \mu F$ algebra za $F$. Še več, $\mu F$ je **začetna algebra** za $F$: za vsako algebro $\alpha : F X \to X$ obstaja **enoličen homomorfizem** $f : \mu F \to X$.

_Dokaz._ Spomnimo se, da je $\mu F = \bigcup_{n = 0}^{\infty} I_n$, kjer je $I_0 = \emptyset$ in $I_{n + 1} = F I_n$. Prav tako velja $F \mu F = \mu F$, se pravi je identiteta res endomorfizem $\mathrm{id} : F \mu F \to \mu F$. Homomorfizem $f : \mu F \to X$ mora po definiciji zadoščati enačbi $f \circ \mathrm{id} = \alpha \circ F f$, oziroma $f = \alpha \circ F f$.

Definirajmo zaporedje preslikav $f_n : I_n \to X$ z rekurzijo:

- $f_0 : \emptyset \to X$ je edina možna prazna funkcija.
- $f_{n + 1} : I_{n + 1} \to X$ definiramo kot kompozitum $f_{n+1} = \alpha \circ F f_n$. To smemo, ker je $I_{n + 1} = F I_n$ in tako po delovanju funktorja $F$ na preslikavi $f_n : I_n \to X$ dobimo $F f_n : F I_n \to F X$, nakar apliciramo $\alpha : F X \to X$.

Z indukcijo zlahka preverimo, da se definiciji ujemata na presekih preslikav, se pravi $f_{n+1}|_{I_n} = f_n$. Osnovni korak (zožitev na prazno množico $I_0$) je trivialen. Za induktivni korak pa velja:
$$ f_{n+2}|_{I_{n+1}} = (\alpha \circ F f_{n+1})|_{F I_n} = \alpha \circ F (f_{n+1}|_{I_n}) = \alpha \circ F f_n = f_{n+1} $$
S tem lahko zberemo vse preslikave in definiramo enotno preslikavo $f : \mu F \to X$, za katero bo veljalo $f|_{I_n} = f_n$. Preslikava $f$ na vseh množicah $I_{n+1}$ zadošča zvezi

$$ f|_{I_{n+1}} = f_{n+1} = \alpha \circ F f_n = \alpha \circ F (f|_{I_n}) = (\alpha \circ F f)|_{F I_n} = (\alpha \circ F f)|_{I_{n+1}} $$

(na $I_0 = \emptyset$ pa gre trivialno za prazni funkciji), zato velja tudi $f = \alpha \circ F f$.

Preveriti moramo še enoličnost izbire $f$. Predpostavimo, da obstaja še kakšen homomorfizem $g : \mu F \to X$, da velja $g = \alpha \circ F g$. Z indukcijo dokažimo, da je $g|_{I_n} = f_n$.

- Za $n = 0$ trivialno velja $g|_{I_0} = f_0 : \emptyset \to X$.
- Za induktivni korak predpostavimo $g|_{I_n} = f_n$. Potem je
  $$ g|_{I_{n+1}} = g|_{F I_n} = (\alpha \circ F g)|_{F I_n} = \alpha \circ F (g|_{I_n}) = \alpha \circ F f_n = f_{n+1} $$

Ker se $g$ in $f$ ujemata na vsakem $I_n$, se ujemata tudi na celi množici $\mu F = \bigcup_{n = 0}^{\infty} I_n$. S tem je dokaz zaključen. ∎
