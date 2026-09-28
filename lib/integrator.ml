let runge_kutta_4 (state : State.t)(deriv : State.t -> Derivative.t)(h : float) = 
    let k1 = deriv state in
    let k2 = deriv (State.add_scaled_derivative (state)(h /. 2.0) k1) in
    let k3 = deriv (State.add_scaled_derivative (state)(h /. 2.0) k2) in
    let k4 = deriv (State.add_scaled_derivative (state)(h) k3) in

    let weighted_derivative = 
        Derivative.add
            (Derivative.scale(1.0 /. 6.0) k1)
            (Derivative.add
                (Derivative.scale(1.0 /. 3.0) k2)
                (Derivative.add
                    (Derivative.scale(1.0 /. 3.0) k3)
                    (Derivative.scale(1.0 /. 6.0) k4)))
    in

    State.add_scaled_derivative(state)(h)(weighted_derivative)
