
universe u

/-- A vector is a function from Fin n to α -/
def Vec (α : Type u) (n : Nat) :=
  Fin n → α

namespace Vec

/-- Get element (just function application) -/
def get {α : Type u} {n : Nat} (v : Vec α n) (i : Fin n) : α :=
  v i

/-- Set element (functional update) -/
def set {α : Type u} {n : Nat}
  (v : Vec α n) (i : Fin n) (a : α) : Vec α n :=
  fun j => if j = i then a else v j

/-- Tabulate: build vector from function -/
def ofFn {α : Type u} {n : Nat} (f : Fin n → α) : Vec α n :=
  f

/-- Constant vector -/
def replicate {α : Type u} {n : Nat} (a : α) : Vec α n :=
  fun _ => a

/-- Nice indexing syntax v[i] -/
instance {α : Type u} {n : Nat} :
  GetElem (Vec α n) Nat α (fun _ i => i < n) where
  getElem v i h :=
    v ⟨i, h⟩


def toList {n : Nat} (v : Vec Nat n) : List Nat :=
  (List.finRange n).map v

end Vec

/-- Example vector -/
def ex_vector : Vec Nat 3 :=
  fun
  | ⟨0, _⟩ => 10
  | ⟨1, _⟩ => 20
  | ⟨2, _⟩ => 30

#eval ex_vector[1]  -- 20

/-- Update example -/
def updated := Vec.set ex_vector ⟨1, by decide⟩ 99

inductive AExp (n : Nat) : Type where
| const : Nat → AExp n
| var : Fin n → AExp n

inductive BExp (n : Nat) : Type where
| tru : BExp n
| fls : BExp n


inductive Cmd (n : Nat) : Type where
| skip : Cmd n
| assign : Fin n → AExp n → Cmd n

def ex_racun : AExp 1 := sorry -- 5 + x0

structure State (n : Nat) where
  run : Vec Nat n

instance {n : Nat} :
  GetElem (State n) Nat Nat (fun _ i => i < n) where
  getElem st i h :=
    st.run ⟨i, h⟩

def Result (n : Nat) : Type :=
  State n

instance {n : Nat} : ToString (State n) where
  toString st :=
    "State(" ++ toString st.run.toList ++ ")"


def evalExp {n : Nat} (st : State n) (aexp: AExp n) : Nat :=
  match aexp with
  | .const x   => x
  | .var i     => st[i]

#eval evalExp ⟨Vec.replicate 10⟩ ex_racun  -- 15

def evalBExp {n : Nat} (st : State n) (bexp: BExp n) : Bool :=
  match bexp with
  | .tru => true
  | .fls => false

#eval sorry -- evalBExp ⟨Vec.replicate 10⟩ (BExp.le ex_racun (.const 20))  -- true

def ex_vsota (n: Nat) : Cmd 3 := sorry
  -- .seq
  --   (.seq (.assign (⟨0, by decide⟩) (AExp.const n))
  --         (.assign (⟨1, by decide⟩) (AExp.const 0)))
  --   (.seq (.assign (⟨2, by decide⟩) (AExp.const 0))
  --    (.whl
  --     (BExp.le (AExp.var ⟨1, by decide⟩) (AExp.var ⟨0, by decide⟩))
  --     (.seq (.seq
  --       (.assign (⟨ 2, by decide⟩) (AExp.add (AExp.var ⟨2, by decide⟩) (AExp.var ⟨1, by decide⟩)))
  --       (.assign (⟨1, by decide⟩) (AExp.add (AExp.var ⟨1, by decide⟩) (AExp.const 1)))
  --     ) (.print (AExp.var ⟨2, by decide⟩)
  --     ))
  --   ))


def evalCmd {n : Nat} (gas: Nat) (st : State n) (cmd : Cmd n) : Result n :=
  sorry


#eval evalCmd 100 ⟨Vec.replicate 0⟩ (ex_vsota 5)  --

-- result as a pair of final state and list of printed values
structure ResultWithPrint (n : Nat) : Type where
  state : State n
  printed : List Nat

instance {n : Nat} : ToString (ResultWithPrint n) where
  toString r :=
    "ResultWithPrint(" ++ toString r.state.run.toList ++ ", " ++ toString r.printed ++ ")"


def bind {n : Nat} (res : ResultWithPrint n) (f : State n → ResultWithPrint n) : ResultWithPrint n :=
  let {state := st', printed} := f res.state
  {state := st', printed := res.printed ++ printed}

def evalCmdPrint {n : Nat} (gas: Nat) (st : State n) (cmd : Cmd n) : ResultWithPrint n :=
  sorry

#eval evalCmdPrint 100 ⟨Vec.replicate 0⟩ (ex_vsota 5)
