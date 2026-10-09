open Lacaml.D

let mass_matrix (params : Parameters.t) (state : State.t) =
    let n = Array.length state.omega in

    Array.init n (fun mu ->
        Array.init n (fun i ->
            let l_mu = params.lengths.(mu) in
            let l_i = params.lengths.(i) in
            let mass_sum = params.tail_masses.(max mu i) in
            let delta = state.omega.(i) -. state.omega.(mu) in

            l_mu *. l_i *. cos delta *. mass_sum;
        )
    )

let rhs (params : Parameters.t)(state : State.t) = 
    let n = Array.length state.theta in

    Array.init n (fun mu -> 
        let l_mu = params.lengths.(mu) in
        let theta_mu = params.lengths.(mu) in

        let velocity_term = ref 0.0 in

        for i = 0 to n - 1 do
            let l_i = params.lengths.(i) in
            let mass_sum = params.tail_masses.(max i mu) in
            let delta = state.omega.(i) -. state.omega.(mu) in

            velocity_term := !velocity_term +. l_mu *. l_i *. sin delta *. mass_sum
        done;

        let gravity_term = params.g *. l_mu *. sin theta_mu *. params.tail_masses.(mu) in

        !velocity_term -. gravity_term;
    )

(**
    Given the parameters defining the system and the current state, find the angular acceleration of each pendulum.

    @param params a Parameter record of type t;
    @param state a State record of type t.

    Returns a tuple of the two alpha values.
*)
(* let accelerations (params : Parameters.t)(state : State.t) = 
    let m = mass_matrix params state in
    let b = rhs params state in



let derivative (params : Parameters.t)(state : State.t) : Derivative.t = 
    let alpha = accelerations(params)(state) in
    {
        omega = state.omega;
        alpha;
    } *)