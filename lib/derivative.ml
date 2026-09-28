(**
  Description of the rate of change of the state variables.

  @param omega1 the angular velocity of the first pendulum;
  @param omega2 the angular velocity of the second pendulum;
  @param alpha1 the angular acceleration of the first pendulum;
  @param alpha2 the angular acceleration of the second pendulum.
*)
type t = {
  omega1 : float;
  omega2: float;
  alpha1: float;
  alpha2 : float;
}