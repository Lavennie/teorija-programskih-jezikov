inductive Ty : Type where
| Bul : Ty
| Fun : Ty → Ty → Ty
| Nat : Ty
| Prod : Ty → Ty → Ty
| Sum : Ty → Ty → Ty
| List : Ty -> Ty

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
| sub : Tm Γ Ty.Nat → Tm Γ Ty.Nat → Tm Γ Ty.Nat
| mul : Tm Γ Ty.Nat → Tm Γ Ty.Nat → Tm Γ Ty.Nat
| mkpair : Tm Γ A → Tm Γ B → Tm Γ (Ty.Prod A B)
| fst : Tm Γ (Ty.Prod A B) → Tm Γ A
| snd : Tm Γ (Ty.Prod A B) → Tm Γ B
| inl : Tm Γ A → Tm Γ (Ty.Sum A B)
| inr : Tm Γ B → Tm Γ (Ty.Sum A B)
| matchsum : Tm Γ (Ty.Sum A B) → Tm (Ctx.snoc Γ A) C → Tm (Ctx.snoc Γ B) C → Tm Γ C
| emptylist : Tm Γ (Ty.List A)
| cons : Tm Γ A → Tm Γ (Ty.List A) → Tm Γ (Ty.List A)
| matchlist : Tm Γ (Ty.List A) → Tm Γ C → Tm (Ctx.snoc (Ctx.snoc Γ A) (Ty.List A)) C → Tm Γ C


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
| ρ, _, Tm.sub M N => Tm.sub (rename ρ M) (rename ρ N)
| ρ, _, Tm.mul M N => Tm.mul (rename ρ M) (rename ρ N)
| _, _, _ => sorry

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
| σ, _, Tm.sub M N => Tm.sub (subst σ M) (subst σ N)
| σ, _, Tm.mul M N => Tm.mul (subst σ M) (subst σ N)
| _, _, _ => sorry

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
-- TODO

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
| sub_step1 :
    Step M M' →
    -------------------------------
    Step (Tm.sub M N) (Tm.sub M' N)
| sub_step2 :
    IsValue V →
    Step N N' →
    -------------------------------
    Step (Tm.sub V N) (Tm.sub V N')
| sub_val :
    ------------------------------------------
    Step (Tm.sub (Tm.nat m) (Tm.nat n)) (Tm.nat (m - n))
| mul_step1 :
    Step M M' →
    -------------------------------
    Step (Tm.mul M N) (Tm.mul M' N)
| mul_step2 :
    IsValue V →
    Step N N' →
    -------------------------------
    Step (Tm.mul V N) (Tm.mul V N')
| mul_val :
    ------------------------------------------
    Step (Tm.mul (Tm.nat m) (Tm.nat n)) (Tm.nat (m * n))
-- TODO

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
    case sub M N M_ih N_ih =>
        cases M_ih h_ctx
        case step =>
            apply Progresses.step
            apply Step.sub_step1
            assumption
        case value M_val =>
            cases N_ih h_ctx
            case step =>
                apply Progresses.step
                apply Step.sub_step2
                · assumption
                · assumption
            case value N_val =>
                cases M_val
                cases N_val
                exact Progresses.step Step.sub_val
    case mul M N M_ih N_ih =>
        cases M_ih h_ctx
        case step =>
            apply Progresses.step
            apply Step.mul_step1
            assumption
        case value M_val =>
            cases N_ih h_ctx
            case step =>
                apply Progresses.step
                apply Step.mul_step2
                · assumption
                · assumption
            case value N_val =>
                cases M_val
                cases N_val
                apply Progresses.step
                apply Step.mul_val
    sorry
    sorry
    sorry
    sorry
    sorry
    sorry
    sorry
    sorry
    sorry
