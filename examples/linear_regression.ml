open Containers

open Decml
open   Model
open   Optimise

open Frontend

let%model linear x = ([%pc 1] *. x) +. [%pc 0]

let data = 
  get_data
    (List.map 
      (fun xs -> 
        let x = float_of_string (List.nth xs 0) in
        let y = float_of_string (List.nth xs 1) in
        x, y))

let model =
  let%decouple (m, p) = linear in
  let m = rebind m in
  let p = 
    grad_desc ~loss_f:mse ~rate:!rate ~threshold:!threshold ~epochs:!iterations 
      ~model:m p data in
  m p

let () =
  output model Float.pp !start_x
