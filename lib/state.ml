(**
  Description of the state space for a double pendulum.

  @param theta1 Angular position of the upper pendulum;
  @param omega1 Angular velocity of the upper pendulum;
  @param theta2 Angular position of the lower pendulum;
  @param omega2 Angular velocity of the lower pendulum.
*)

type t = {
    theta1 : float;
    theta2 : float;
    omega1 : float;
    omega2 : float;
}

let add_scaled_derivative (state : t)(deriv : Derivative.t)(h : float) =
   {
        theta1 = state.theta1 +. h *. deriv.omega1;
        theta2 = state.theta2 +. h *. deriv.omega2;
        omega1 = state.omega1 +. h *. deriv.alpha1;
        omega2 = state.omega2 +. h *. deriv.alpha2;
   }