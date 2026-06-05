inductive Ty : Type where
| Bul : Ty
| Fun : Ty → Ty → Ty
| Nat : Ty

notation A " ⇒ " B => Ty.Fun A B

inductive Ctx : Type where
| empty : Ctx
| snoc : Ctx → Ty → Ctx

inductive Var : Ctx → Ty -> Type where
| Z : Var (Ctx.snoc _ A) A
| S :
    Var Γ A →
    --------------------
    Var (Ctx.snoc Γ _) A

inductive Tm : Ctx -> Ty -> Type where
| tru : Tm Γ Ty.Bul
| fls : Tm Γ Ty.Bul
| ite : Tm Γ Ty.Bul → Tm Γ A → Tm Γ A → Tm Γ A
| var : Var Γ A → Tm Γ A
| lam : Tm (Ctx.snoc Γ A) B → Tm Γ (Ty.Fun A B)
| app : Tm Γ (Ty.Fun A B) → Tm Γ A → Tm Γ B
| nat : Nat → Tm Γ Ty.Nat
| add : Tm Γ Ty.Nat → Tm Γ Ty.Nat → Tm Γ Ty.Nat

-- Primer: kompozitum
    -- λf².λg¹.λx⁰.f (g x)
    -- λ.λ.λ.2 (1 0)

example {A B C} : Tm Ctx.empty ((B ⇒ C) ⇒ (A ⇒ B) ⇒ (A ⇒ C)) :=
    open Tm in
    open Var in
    lam ( lam ( lam (
        app (var (S (S Z))) (app (var (S Z)) (var Z))
    )))

def extendRename (ρ : {B : Ty} → Var Γ B → Var Δ B) : ({B : Ty} → Var (Ctx.snoc Γ A) B → Var (Ctx.snoc Δ A) B)
| _, Var.Z => Var.Z
| _, Var.S y => Var.S (ρ y)

def rename : ({B : Ty} → Var Γ B → Var Δ B) → {A : Ty} → Tm Γ A → Tm Δ A
| _, _, Tm.tru => Tm.tru
| _, _, Tm.fls => Tm.fls
| _, _, Tm.nat n => Tm.nat n
| ρ, _, Tm.ite M N1 N2 => Tm.ite (rename ρ M) (rename ρ N1) (rename ρ N2)
| ρ, _, Tm.var y => Tm.var (ρ y)
| ρ, _, Tm.lam M => Tm.lam (rename (extendRename ρ) M)
| ρ, _, Tm.app M N => Tm.app (rename ρ M) (rename ρ N)
| ρ, _, Tm.add M N => Tm.add (rename ρ M) (rename ρ N)

def extendSubst (σ : {B : Ty} → Var Γ B → Tm Δ B) : ({B : Ty} → Var (Ctx.snoc Γ A) B → Tm (Ctx.snoc Δ A) B)
| _, Var.Z => Tm.var Var.Z
| _, Var.S y => rename Var.S (σ y)

def subst : ({B : Ty} → Var Γ B → Tm Δ B) → {A : Ty} → Tm Γ A → Tm Δ A
| _, _, Tm.tru => Tm.tru
| _, _, Tm.fls => Tm.fls
| _, _, Tm.nat n => Tm.nat n
| σ, _, Tm.ite M N1 N2 => Tm.ite (subst σ M) (subst σ N1) (subst σ N2)
| σ, _, Tm.var y => σ y
| σ, _, Tm.lam M => Tm.lam (subst (extendSubst σ) M)
| σ, _, Tm.app M N => Tm.app (subst σ M) (subst σ N)
| σ, _, Tm.add M N => Tm.add (subst σ M) (subst σ N)

def substOne (V : Tm Γ A) : {B : Ty} → Var (Ctx.snoc Γ A) B → Tm Γ B
| _, Var.Z => V
| _, Var.S y => Tm.var y

def substTwo (V1 : Tm Γ A) (V2 : Tm Γ B) : {C : Ty} → (N : Var (Ctx.snoc (Ctx.snoc Γ A) B) C) → Tm Γ C
| _, Var.Z => V2
| _, Var.S Var.Z => V1
| _, Var.S (Var.S x) => Tm.var x

inductive IsValue : {Γ : Ctx} → {A : Ty} → Tm Γ A → Prop where
| tru : IsValue Tm.tru
| fls : IsValue Tm.fls
| lam : IsValue (Tm.lam _)
| nat : IsValue (Tm.nat _)

inductive Step : {Γ : Ctx} → {A : Ty} → Tm Γ A → Tm Γ A → Prop where
| ite_step :
    Step M M' →
    ---------------------------------------
    Step (Tm.ite M N1 N2) (Tm.ite M' N1 N2)
| ite_tru :
    -----------------------------
    Step (Tm.ite Tm.tru N1 N2) N1
| ite_fls :
    -----------------------------
    Step (Tm.ite Tm.fls N1 N2) N2
| app_step1 :
    Step M M' →
    -------------------------------
    Step (Tm.app M N) (Tm.app M' N)
| app_lam :
    Step (Tm.app (Tm.lam M) V) (subst (substOne V) M)
| add_step1 :
    Step M M' →
    -------------------------------
    Step (Tm.add M N) (Tm.add M' N)
| add_step2 :
    IsValue V →
    Step N N' →
    -------------------------------
    Step (Tm.add V N) (Tm.add V N')
| add_val :
    ------------------------------------------
    Step (Tm.add (Tm.nat m) (Tm.nat n)) (Tm.nat (m + n))

set_option pp.fieldNotation false

inductive Progresses : {Γ : Ctx} → {A : Ty} → Tm Γ A → Prop where
| step : Step M M' → Progresses M
| value : IsValue M → Progresses M

example : Tm Ctx.empty (Ty.Bul ⇒ Ty.Nat) :=
    open Tm in
    lam (ite tru (Tm.nat 2) (Tm.nat 0))

def example2: Tm Ctx.empty (Ty.Bul ⇒ Ty.Nat) :=
    Tm.lam (Tm.ite (Tm.var Var.Z) (Tm.nat 2) (Tm.nat 0))

theorem progress :
    Γ = Ctx.empty →
    (M : Tm Γ A) →
    Progresses M :=
by
    intro h_ctx h_typ
    induction h_typ
    case tru =>
        exact Progresses.value IsValue.tru
    case fls =>
        exact Progresses.value IsValue.fls
    case nat =>
        exact Progresses.value (IsValue.nat)
    case ite M_ih N1_ih N2_ih =>
        cases (M_ih h_ctx)
        case step M_step =>
            exact Progresses.step (Step.ite_step M_step)
        case value M_val =>
            cases M_val
            case tru =>
                exact Progresses.step (Step.ite_tru)
            case fls =>
                exact Progresses.step (Step.ite_fls)
    case var =>
        rename_i tezava
        rewrite [h_ctx] at tezava
        contradiction
    case lam =>
        exact Progresses.value IsValue.lam
    case app A B M N M_ih N_ih =>
        cases M_ih h_ctx
        case step =>
            apply Progresses.step
            apply Step.app_step1
            assumption
        case value M_val =>
            cases M_val
            apply Progresses.step
            apply Step.app_lam
    case add M N M_ih N_ih =>
        cases M_ih h_ctx
        case step =>
            apply Progresses.step
            apply Step.add_step1
            assumption
        case value M_val =>
            cases N_ih h_ctx
            case step =>
                apply Progresses.step
                apply Step.add_step2
                · assumption
                · assumption
            case value N_val =>
                cases M_val
                cases N_val
                exact Progresses.step Step.add_val

-- Tako imenovane `kanonične oblike`. Izreki nam povedo, da so vrednosti določenega tipa vedno določenih `oblik`.
theorem canonicalLam : {M : Tm Γ (Ty.Fun A B)} → (IsValue M) → ∃ body, M = Tm.lam body := by
    intro M hval
    cases M <;> try contradiction
    rename_i att
    exists att

theorem canonicalBool : (M : Tm Γ Ty.Bul) → (IsValue M) → (M = Tm.tru ∨ M = Tm.fls) := by
    intro M hval
    cases M <;> try contradiction
    left; rfl
    right; rfl


theorem canonicalNat : (M : Tm Γ Ty.Nat) → (IsValue M) → ∃ n, M = Tm.nat n := by
    intro M hval
    cases M <;> try contradiction
    rename_i n
    exists n


theorem valueNoForward : IsValue M -> ¬ (∃ M' , Step M M') := by
    intros
    induction M <;> intro step <;> (first | contradiction | (obtain ⟨M', step_eq⟩ := step; rcases step_eq))

theorem StepDeterministic : Step M M1 → Step M M2 → M1 = M2 := by
    intros step1 step2
    induction step1
    case ite_step MtoM' =>
        rename_i h1 h2
        rcases step2
        simp
        apply MtoM' -- ih za step1
        assumption
        rcases h2 -- tukaj vemo da je pogoje = true -> kako bi potem imeli pogoj od prej?
        rcases h2
    case ite_tru =>
        rcases step2
        rename_i h1 -- če gre true kam?
        rcases h1 -- ne gre
        simp
    case ite_fls =>
        rcases step2
        rename_i h1
        rcases h1
        simp
    case app_step1 MtoM' =>
        rename_i m1 m2 m3 m4
        rcases step2
        simp
        apply MtoM' -- ih za step1
        assumption
        rcases m4
    case app_lam V =>
        rename_i vv a b c
        rcases step2
        rename_i ma
        rcases ma
        simp
    case add_step1 MtoM' =>
        rename_i m1 m2 m3 m4
        rcases step2
        simp
        apply MtoM' -- ih za step1
        assumption
        simp
        rename_i h1 h2
        exfalso
        apply valueNoForward h1
        exists m2
        rcases m4
    case add_step2 V NtoN' =>
        rename_i vv a b c
        rcases step2
        exfalso
        apply valueNoForward c
        rename_i h1 N't
        exists h1
        simp
        apply NtoN' -- ih za step2
        assumption
        rcases V
    case add_val =>
        rcases step2
        simp
        rename_i h1 h2
        rcases h2
        rename_i m1' m2'
        rcases m2'
        simp
