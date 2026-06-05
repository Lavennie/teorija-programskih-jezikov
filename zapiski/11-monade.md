# Monade

Videli smo, da je operacijska semantika računskih učinkov precej raznolika. Pri denotacijski semantiki ni nič drugače. Recimo, da tip $A$ predstavimo z množico (ali domeno, čeprav zaradi enostavnosti delajmo z množicami) vrednosti $\itp{A}$. Programe, ki računajo vrednosti tipa $A$ smo do sedaj predstavljali s funkcijami, ki so slikale v $\itp{A}$. A če dodamo učinke, taka predstavitev ni več dovolj dobra.

- Če želimo v programu podpirati izjeme, bo njegova interpretacija morala razločevati programe, ki vračajo vrednosti iz $A$ od tistih, ki sprožajo izjeme. Tako bi bila ustreznejša kodomena funkcij $\itp{A} + \mathbb{E}$.
- Če program izpisuje znake iz množice $O$, moramo poleg rezultata vrniti še seznam izpisanih znakov, torej bi bila kodomena $\itp{A} \times O^*$.
- Če naš program lahko bere in piše po pomnilniku z množico možnih stanj $S$, bo interpretacija programa odvisna od začetnega stanja, hkrati pa bo vrnila novo, spremenjeno stanje. Boljša interpretacija bi bila $(\itp{A} \times S)^S$.
- Če je izvajanje programa nedeterministično in gre lahko po različnih poteh, bi bilo bolje, če bi rezultat predstavili z množico možnih vrnjenih vrednosti, torej kodomeno $\mathcal{P}(\itp{A})$.

Opazimo, da so vsi zgornji primeri kodomen oblike $T \itp{A}$, kjer je $T$ neka konstrukcija, ki množico $X$ slika v množico $T X$. Poleg tega za interpretacijo programov, ki povzročajo učinke, potrebujemo še dve operaciji:

- Če imamo vrednost tipa $A$, moramo znati predstaviti tudi program, ki vrača samo to vrednost in ne sproža nobenih učinkov. Torej potrebujemo operacijo, ki $\itp{A}$ vloži v $T \itp{A}$.
- Če imamo program, ki vrača vrednosti tipa $A$, in še en program, ki vrača vrednosti tipa $B$, ju želimo izvesti enega za drugim. Pri tem je drugi program lahko odvisen od rezultata prvega. Torej potrebujemo operacijo, ki zna iz interpretacije v $T \itp{A}$ in funkcije $\itp{A} \to T \itp{B}$ sestaviti interpretacijo združenega programa v $T \itp{B}$.

## Definicija monad

Tako strukturo opisujejo _monade_. Monada je podana s trojico $(T, \eta, \bind)$, kjer je:

- $T$ preslikava (funktor), ki vsaki množici $X$ priredi množico $T X$,
- $\eta$ _enota_, ki je družina preslikav (naravna transformacija) $\eta_X : X \to T X$ za poljubno množico $X$,
- $\bind$ _veriženje_, ki je družina preslikav (naravna transformacija) $\bind_{X, Y} : T X \to (X \to T Y) \to T Y$ za poljubni množici $X$ in $Y$,

ki zadoščajo zakonom:

- $\eta(x) \bind_{X, Y} k = k(x)$ za poljuben $x \in X$ ter $k : X \to T Y$,
- $m \bind_{X, X} \eta_X = m$ za poljuben $m \in T X$,
- $(m \bind_{X, Y} k) \bind_{Y, Z} k' = m \bind_{X, Z} (x \mapsto k(x) \bind_{Y, Z} k')$ za poljuben $m \in T X$, $k : X \to T Y$ in $k' : Y \to T Z$.

## Primeri monad

### Trivialna monada

Najenostavnejša monada je trivialna, ki predstavlja programe, ki ne sprožajo nobenih učinkov.

$$\begin{align*}
    T X &= X \\
    \eta_X(x) &= x \\
    m \bind_{X, Y} k &= k(m)
\end{align*}$$

### Izjeme

Monado za izjeme iz množice $\mathbb{E}$ podamo kot:

$$\begin{align*}
    T X &= X + \mathbb{E} \\
    \eta_X(x) &= \iota_1(x) \\
    m \bind_{X, Y} k &= \begin{cases}
        k(x) & m = \iota_1(x) \\
        \iota_2(e) & m = \iota_2(e)
    \end{cases}
\end{align*}$$

Preverimo še veljavnost zakonov:

$$\begin{align*}
    \eta(x) \bind_{X, Y} k  &= \iota_1(x) \bind_{X, Y} k = k(x) \\
    m \bind_{X, Y} \eta_X(x) &= \left(\begin{cases}
        \iota_1(x) & m = \iota_1(x) \\
        \iota_2(e) & m = \iota_2(e)
    \end{cases}\right) = m \\
    (m \bind k) \bind k' &= \left(\begin{cases}
        k(x) & m = \iota_1(x) \\
        \iota_2(e) & m = \iota_2(e)
    \end{cases}\right) \bind k' \\
    &= \begin{cases}
        k(x) \bind k' & m = \iota_1(x) \\
        \iota_2(e) \bind k' & m = \iota_2(e)
    \end{cases} \\
    &= \begin{cases}
        k(x) \bind k' & m = \iota_1(x) \\
        \iota_2(e) & m = \iota_2(e)
    \end{cases} \\
    &= m \bind (x \mapsto k(x) \bind k')
\end{align*}$$

Za interpretacijo sprožanja in lovljenja izjem potem potrebujemo še preslikavi

$$\begin{align*}
    \mathrm{raise} &: \mathbb{E} \to T X \\
    \mathrm{raise}(e) &= \iota_2(e) \\
    \mathrm{handle} &: T X \times (\mathbb{E} \to T X) \to T X \\
    \mathrm{handle}(m, h) &= \left(\begin{cases}
        \iota_1(x) & m = \iota_1(x) \\
        h(e) & m = \iota_2(e)
    \end{cases}\right)
\end{align*}$$

### Pomnilnik

Monado za delo s pomnilnikom nad množico stanj $S$ podamo kot:

$$\begin{align*}
    T X &= (X \times S)^S \\
    \eta_X(x) &= (s \mapsto (x, s)) \\
    m \bind_{X, Y} k &= (s \mapsto k(\underbrace{\pi_1(m(s))}_x)(\underbrace{\pi_2(m(s))}_{s'}))
\end{align*}$$

Veriženje deluje tako, da $m : S \to (X \times S)$ uporabi na začetnem stanju $s \in S$ in dobi vrednost $x = \pi_1(m(s)) \in X$ ter novo stanje $s' = \pi_2(m(s)) \in S$. Nato $k : X \mapsto (Y \times S)^S$ uporabi na $x$, da dobi $k(x) : S \to (Y \times S)$, ki ga uporabi še na $s'$, da dobi končni rezultat $k(x)(s') : Y \times S$.

Preverimo še veljavnost zakonov::

$$\begin{align*}
    (\eta(x) \bind_{X, Y} k)
        &= (s \mapsto k(\pi_1(\eta(x)(s)))(\pi_2(\eta(x)(s)))) \\
        &= (s \mapsto k(\pi_1((x, s)))(\pi_2((x, s)))) \\
        &= (s \mapsto k(x)(s)) \\
        &= k(x) \\
    m \bind_{X, Y} \eta(x)
        &= (s \mapsto \eta(\pi_1(m(s)))(\pi_2(m(s)))) \\
        &= (s \mapsto (\pi_1(m(s)), \pi_2(m(s)))) \\
        &= (s \mapsto m(s)) \\
        &= m \\
    (m \bind k) \bind k'
        &= (s \mapsto k(\pi_1(m(s)))(\pi_2(m(s)))) \bind k' \\
        &= (s \mapsto k'(\pi_1(k(\pi_1(m(s)))(\pi_2(m(s)))))(\pi_2(k(\pi_1(m(s)))(\pi_2(m(s)))))) \\
        &= m \bind (x \mapsto (s \mapsto k'(\pi_1(k(x)(s)))(\pi_2(k(x)(s))))) \\
        &= m \bind (x \mapsto k(x) \bind k')
\end{align*}$$

Za interpretacijo branja in pisanja potrebujemo še preslikavi

$$\begin{align*}
    \mathrm{lookup} &: L \to T \mathbb{Z} \\
    \mathrm{lookup}(\ell) & s \mapsto (s(\ell), s) \\
    \mathrm{update} &: L \times \mathbb{Z} \to 1 \\
    \mathrm{update}(\ell, n) &= s \mapsto ((), s[\ell \mapsto n])
\end{align*}$$

## Semantika programskega jezika

Opremljeni z monado $(T, \eta, \bind)$, ki opisuje učinke, ki jih želimo zajeti, lahko podamo semantiko programskega jezika. Spomnimo se, da je drobnozrnati neučakani λ-račun podan s sintakso:

$$
    \begin{align*}
    \text{vrednost } V &::= x
        \mid \true
        \mid \false
        \mid \intsym{n}
        \mid \lambda x. M \\
    \text{izračun } M, N &::=
        \return V
        \mid \letin{x = M} N
        \mid \ifthenelse{V}{M_1}{M_2} \\
        &\mid V_1 + V_2
        \mid V_1 * V_2
        \mid V_1 < V_2
        \mid V_1 \, V_2
\end{align*}
$$

Tedaj bomo tipom $A$ priredili množico (čeprav bi zgodbo lahko ponovili tudi za domene) $\itp{A}$, le da moramo upoštevati prisotnost učinke:

$$
    \begin{align*}
    \itp{\boolty} &= \mathbb{B} = \{ \ttt, \fff \} \\
    \itp{\intty} &= \mathbb{Z} \\
    \itp{A \to B} &= \itp{B}^{T \itp{A}} = \itp{A} \to T \itp{B}
    \end{align*}
$$

Funkcijski tip $A \to B$ torej interpretiramo s funkcijami, ki za vsak argumenta iz $\itp{A}$ ustvarijo program, ki vrača vrednosti iz $\itp{B}$, vendar vmes sproža učinke, opisane z monado $T$.

Tako kot prej bomo kontekst, ki vsebuje vrednosti, interpretirali kot

$$
  \itp{x_1 : A_1, \dots, x_n : A_n} = \itp{A_1} \times \dots \times \itp{A_n},
$$

vrednosti pa s funkcijami

$$
  \itp{\Gamma \vdash_v V : A} : \itp{\Gamma} \to \itp{A}.
$$

Razlika bo pri izračunih, kjer bomo zopet uporabili monado in jih interpretirali s funkcijami:

$$
  \itp{\Gamma \vdash_c M : A} : \itp{\Gamma} \to T \itp{A}.
$$

Interpretacije definiramo rekurzivno kot:

$$
\begin{align*}
\itp{\Gamma \vdash_v x_i : A_i}(a_1, \dots, a_n) &= a_i \\
\itp{\Gamma \vdash_v \true : \boolty}(\gamma) &= \ttt \\
\itp{\Gamma \vdash_v \false : \boolty}(\gamma) &= \fff \\
\itp{\Gamma \vdash_v \intsym{n} : \intty}(\gamma) &= n \\
\itp{\Gamma \vdash_v \lambda x. M : A \to B}(\gamma) &= a \mapsto \itp{\Gamma, x : A \vdash_c M : B}(\gamma, a) \\[2em]
\itp{\Gamma \vdash_c \ifthenelse{V}{M_1}{M_2} : A}(\gamma) &=
  \begin{cases}
    \itp{M_1}(\gamma) & \itp{V}(\gamma) = \ttt \\
    \itp{M_2}(\gamma) & \itp{V}(\gamma) = \fff
  \end{cases} \\
\itp{\Gamma \vdash_c V_1 + V_2 : \intty}(\gamma) &= \eta(\itp{V_1}(\gamma) + \itp{V_2}(\gamma)) \\
\itp{\Gamma \vdash_c V_1 * V_2 : \intty}(\gamma) &= \eta(\itp{V_1}(\gamma) \cdot \itp{V_2}(\gamma)) \\
\itp{\Gamma \vdash_c V_1 < V_2 : \boolty}(\gamma) &=
  \begin{cases}
    \eta(\ttt) & \itp{V_1}(\gamma) < \itp{V_2}(\gamma) \\
    \eta(\fff) & \text{sicer}
  \end{cases} \\
\itp{\Gamma \vdash_c V_1 \, V_2 : B}(\gamma) &= \big(\itp{V_1}(\gamma)\big)\big(\itp{V_2}(\gamma)\big) \\
\itp{\Gamma \vdash_c \return V : A}(\gamma) &= \eta(\itp{V}(\gamma)) \\
\itp{\Gamma \vdash_c \letin{x = M} N : A}(\gamma) &= \itp{\Gamma \vdash_c M : B}(\gamma) \bind (a \mapsto \itp{\Gamma, x : B \vdash_c N : A}(\gamma, a))
\end{align*}
$$

Opazimo, da aritmetične operacije ne vrnejo le vrednosti, saj so izračuni, zato moramo uporabiti enoto $\eta$, da jih vložimo v $T \itp{A}$. Enota monade $\eta$ je ravno tako naravna interpretacija za izračun $\return V$, veriženje $\bind$ pa za $\letin{x = M} N$.
