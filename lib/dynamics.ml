(**
  Given the parameters defining the system and the current state, find the angular acceleration of each pendulum.

  @param params a Parameter record of type t;
  @param state a State record of type t.

  Returns a tuple
*)
let accelerations (params : Parameters.t)(state : State.t) = 
  let delta = state.theta1 -. state.theta2 in

  (* 
    Encodes the data in the M matrix from the Euler-Lagrange equation. 
  *)
  let m11 = (params.m1 +. params.m2) *. params.l1 in
  let m12 = (params.m2 *. params.l2 *. cos(delta)) in
  let m21  = (params.l1 *. cos(delta)) in
  let m22 = params.l2 in

  (* 
    Encodes the data in the B matrix from the Euler-Lagrange equation. 
  *)
  let b1 = -. params.g *. sin(state.theta1) *. (params.m1 +. params.m2) -. params.m2 *. params.l2 *. state.omega2 *. state.omega2 *. sin(delta) in
  let b2 = -. params.g *. sin(state.theta2) -. params.l1 *. state.omega1 *. state.omega1 *. sin(delta) in

  let det = m11 *. m22 -. m12 *. m21 in

  (*
    Formula to solve for the two accelerations; derived from the inverse of a 2 x 2 matrix.
  *)
  let alpha1 = (m22 *. b1 -. m12 *. b2) /. det in
  let alpha2 = (m11 *. b2 -. m21 *. b1) /. det in

  (alpha1, alpha2)
