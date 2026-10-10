open Lacaml.D

let mass_matrix (params : Parameters.t) (state : State.t) =
    let n = Array.length state.theta in
    let m = Lacaml.D.Mat.create n n in

    for mu = 0 to n - 1 do
        for i = 0 to n - 1 do
        m.{mu + 1, i + 1} <-
            params.lengths.(mu)
            *. params.lengths.(i)
            *. cos (state.theta.(i) -. state.theta.(mu))
            *. params.tail_masses.(max mu i)
        done
    done;

    m

let rhs (params : Parameters.t)(state : State.t) = 
    let n = Array.length state.theta in
    let b = Lacaml.D.Mat.create n 1 in

    for mu = 0 to n - 1 do 
        let l_mu = params.lengths.(mu) in
        let theta_mu = state.theta.(mu) in

        let velocity_term = ref 0.0 in

        for i = 0 to n - 1 do
            let l_i = params.lengths.(i) in
            let mass_sum = params.tail_masses.(max i mu) in
            let delta = state.theta.(i) -. state.theta.(mu) in
            let omega_i = state.omega.(i) in

            velocity_term := !velocity_term +. l_mu *. l_i *. sin delta *. mass_sum *. omega_i *. omega_i
        done;

        let gravity_term = params.g *. l_mu *. sin theta_mu *. params.tail_masses.(mu) in

        b.{mu + 1, 1} <- !velocity_term -. gravity_term
        
    done;

    b

(**
    Given the parameters defining the system and the current state, find the angular acceleration of each pendulum.

    @param params a Parameter record of type t;
    @param state a State record of type t.

    Returns an array of the alpha values.
*)
let accelerations (params : Parameters.t)(state : State.t) = 
    let m = mass_matrix params state in
    let b = rhs params state in
    let n = Array.length state.theta in

    Lacaml.D.posv m b;

    Array.init n (fun i ->
            b.{i + 1, 1}
    )

let derivative (params : Parameters.t)(state : State.t) : Derivative.t = 
    {
        omega = Array.copy state.omega;
        alpha = accelerations params state;
    }