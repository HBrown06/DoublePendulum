open Double_Pendulum

let params : Parameters.t = {
    m1 = 1.0;
    m2 = 1.0;
    l1 = 1.0;
    l2 = 1.0;
    g = 9.81;
}

let initial_state : State.t = {
    theta1 = 2.0 *.Float.pi /. 3.0;
    theta2 = 0.0;
    omega1 = 0.0;
    omega2 = 0.0;
}

let h = 0.001

let next_state =
  Integrator.runge_kutta_4
    initial_state
    (Dynamics.derivative params)
    h

let rec simulate (state : State.t)(time : float)(final_time : float)(time_step : float)(out : out_channel)  = 
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
        "%f, %f, %f, %f, %f, %f\n"
        time
        state.theta1
        state.theta2
        state.omega1
        state.omega2
        energy;
    
    let next_state = Integrator.runge_kutta_4 (state)(Dynamics.derivative params)(h) in
    simulate(next_state)(time +. h)(final_time)(h)(out)
end

let () = 
    let out = open_out "data/simulation.csv" in
    simulate(initial_state)(0.0)(60.0)(h)(out);
    close_out out