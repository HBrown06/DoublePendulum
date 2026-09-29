open Double_Pendulum

let params : Parameters.t = {
    m1 = 1.0;
    m2 = 1.0;
    l1 = 1.0;
    l2 = 1.0;
    g = 9.81;
}

let initial_states : State.t list = [
    {
        theta1 = Float.pi /. 2.0;
        theta2 = Float.pi /. 3.0;
        omega1 = 0.0;
        omega2 = 0.0;
    };

    {
        theta1 = Float.pi /. 2.0 +. 0.01;
        theta2 = Float.pi /. 3.0;
        omega1 = 0.0;
        omega2 = 0.0;
    };

    {
        theta1 = Float.pi /. 2.0 +. 0.02;
        theta2 = Float.pi /. 3.0;
        omega1 = 0.0;
        omega2 = 0.0;
    };
]

let h = 0.001

let rec simulate (run_id : int)(state : State.t)(time : float)(final_time : float)(time_step : float)(out : out_channel)  = 
    if time >= final_time then
        ()
    else begin
        let energy =
            0.5 *. (params.m1 +. params.m2) *. params.l1 *. params.l1 *. state.omega1 *. state.omega1
            +. 0.5 *. params.m2 *. params.l2 *. params.l2 *. state.omega2 *. state.omega2
            +. params.m2 *. params.l1 *. params.l2 *. state.omega1 *. state.omega2
                *. cos(state.theta1 -. state.theta2)
            -. (params.m1 +. params.m2) *. params.g *. params.l1 *. cos(state.theta1)
            -. params.m2 *. params.g *. params.l2 *. cos(state.theta2) in
        Printf.fprintf out
        "%d, %f, %f, %f, %f, %f, %f\n"
        run_id
        time
        state.theta1
        state.theta2
        state.omega1
        state.omega2
        energy;
    
    let next_state = Integrator.runge_kutta_4 (state)(Dynamics.derivative params)(h) in
    simulate run_id next_state (time +. h) final_time h out
end

let () = 
    let out = open_out "data/simulation.csv" in
     List.iteri
    (fun i state ->
        simulate i state 0.0 20.0 h out)
    initial_states;
    close_out out