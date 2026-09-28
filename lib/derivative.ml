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

let add (d1 : t)(d2 : t) = 
    {
        omega1 = d1.omega1 +. d2.omega1;
        omega2 = d1.omega2 +. d2.omega2;
        alpha1 = d1.alpha1 +. d2.alpha1;
        alpha2 = d1.alpha2 +. d2.alpha2;
    }
    
let scale (d : t)(c : float) =
    {
        omega1 = d.omega1 *. c;
        omega2 = d.omega2 *. c;
        alpha1 = d.alpha1 *. c;
        alpha2 = d.alpha2 *. c;
    }