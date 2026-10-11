open Double_Pendulum

let n = if Array.length Sys.argv > 1 then
    int_of_string Sys.argv.(1)
else
    2

let masses = Array.make n 1.0
let lengths = Array.make n 1.0
let g = 9.81

let params = Parameters.create masses lengths g

let initial_states : State.t list = [
    {
        State.theta =
        Array.init n (fun i ->
            if i = 0 then Float.pi /. 2.0
            else 0.0
        );
        omega = Array.make n 0.0;
    };

    {
        State.theta =
        Array.init n (fun i ->
            if i = 0 then Float.pi /. 2.0 +. 0.01
            else 0.0
        );
        omega = Array.make n 0.0;
    };

    {
        State.theta =
        Array.init n (fun i ->
            if i = 0 then Float.pi /. 2.0 +. 0.02
            else 0.0
        );
        omega = Array.make n 0.0;
    };
]

let write_header oc n =
    Printf.fprintf oc "run,time";

    for i = 1 to n do
        Printf.fprintf oc ",theta%d" i
    done;

    for i = 1 to n do
        Printf.fprintf oc ",omega%d" i
    done;

    Printf.fprintf oc "\n"

let write_state (run_id : int)(state : State.t)(time : float)(out : out_channel) =
    Printf.fprintf out "%d,%f" run_id time;

    Array.iter
        (fun theta -> Printf.fprintf out ",%f" theta)
        state.theta;

    Array.iter
        (fun omega -> Printf.fprintf out ",%f" omega)
        state.omega;

    Printf.fprintf out "\n"
let h = 0.001

let rec simulate (run_id : int)(state : State.t)(time : float)(final_time : float)(time_step : float)(out : out_channel)  = 
    if time >= final_time then
        ()
    else begin
        write_state run_id state time out;
    
    let next_state = Integrator.runge_kutta_4 (state)(Dynamics.derivative params)(h) in
    simulate run_id next_state (time +. h) final_time h out
end

let () = 
    let out = open_out "data/simulation.csv" in

    write_header out n;
    List.iteri (fun i state -> simulate i state 0.0 20.0 h out)
    initial_states;
    close_out out