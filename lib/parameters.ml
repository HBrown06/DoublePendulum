(**
  Physical parameters for the double pendulum system.

  @param m1 the mass of the upper pendulum;
  @param l1 the length of the upper pendulum;
  @param m2 the mass of the lower pendulum;
  @param l2 the length of the lower pendulum;
  @param g the strength of acceleration due to gravity.
*)

type t = {
    m1 : float;
    m2 : float;
    l1 : float;
    l2 : float;
    g : float;
}