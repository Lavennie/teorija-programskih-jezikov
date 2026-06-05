let rec check_exp ctx = function
  | Syntax.Int _ -> true
  | Syntax.Lookup l -> List.mem l ctx
  | Syntax.Plus (e1, e2) -> check_exp ctx e1 && check_exp ctx e2
  | Syntax.Minus (e1, e2) -> check_exp ctx e1 && check_exp ctx e2
  | Syntax.Times (e1, e2) -> check_exp ctx e1 && check_exp ctx e2

let check_bexp ctx = function
  | Syntax.Bool _ -> true
  | Syntax.Equal (e1, e2) -> check_exp ctx e1 && check_exp ctx e2
  | Syntax.Greater (e1, e2) -> check_exp ctx e1 && check_exp ctx e2
  | Syntax.Less (e1, e2) -> check_exp ctx e1 && check_exp ctx e2

let rec check_cmd ctx = function
  | Syntax.Assign (l, e) -> if check_exp ctx e then Some (l :: ctx) else None
  | Syntax.IfThenElse (bexp, c1, c2) -> (
      match (check_cmd ctx c1, check_cmd ctx c2) with
      | Some ctx1, Some ctx2 when check_bexp ctx bexp ->
          Some (List.filter (fun x -> List.mem x ctx2) ctx1)
      | _, _ -> None)
  | Syntax.Seq (c1, c2) -> (
      (* Option.bind (check_cmd ctx c1) (fun ctx' -> check_cmd ctx' c2) *)
      match check_cmd ctx c1 with
      | Some ctx' -> check_cmd ctx' c2
      | None -> None)
  | Syntax.Skip -> Some ctx
  | Syntax.WhileDo (bexp, c) -> (
      match check_cmd ctx c with
      | Some _ when check_bexp ctx bexp -> Some ctx
      | _ -> None)
  | Syntax.PrintInt e -> if check_exp ctx e then Some ctx else None

let check cmd = check_cmd [] cmd |> Option.is_some
