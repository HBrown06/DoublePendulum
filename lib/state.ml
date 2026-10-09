(**
  Description of the state space for a double pendulum.

  @param theta Array of the angular positions of each pendulum;
  @param omega Angular velocity of the lower pendulum.
*)

type t = {
    theta : float array;
    omega : float array;
}

let add_scaled_derivative (state : t)(h : float)(deriv : Derivative.t) : t =
    let n = Array.length state.theta in
    if Array.length state.omega <> n
     || Array.length deriv.omega <> n
     || Array.length deriv.alpha <> n
    then invalid_arg "State.add_scaled_derivative: dimension mismatch";

    {
        theta = Array.init n (fun i -> state.theta.(i) +. h *. deriv.omega.(i));
        omega = Array.init n (fun i -> state.omega.(i) +. h *. deriv.alpha.(i));
    }