(**
  Description of the rate of change of the state variables.

  @param omega Array of the angular velocities of the pendulums;
  @param alpha Array of the angular accelerations of the pendulums.
*)
type t = {
    omega : float array;
    alpha : float array;
}

let add (d1 : t)(d2 : t) = 
    let n = Array.length d1.omega in
    {
        omega = Array.init n (fun i -> d1.omega.(i) +. d2.omega.(i));
        alpha = Array.init n (fun i -> d1.alpha.(i) +. d2.alpha.(i));
    }

let scale (c : float)(d : t) =
    let n = Array.length d.omega in
    {
        omega = Array.init n (fun i -> c *. d.omega.(i));
        alpha = Array.init n (fun i -> c *. d.alpha.(i));
    }