open Double_Pendulum

let params : Parameters.t = {
  m1 = 1.0;
  m2 = 1.0;
  l1 = 1.0;
  l2 = 1.0;
  g = 9.81;
}

let initial_state : State.t = {
  theta1 = Float.pi /. 3.0;
  theta2 = Float.pi /. 4.0;
  omega1 = 0.0;
  omega2 = 0.0;
}
