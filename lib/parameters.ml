(**
    Physical parameters for the double pendulum system.

    @param masses the masses of the pendulums;
    @param lengths the lengths of the pendulums;
    @param g the strength of acceleration due to gravity.
*)

type t = {
    masses : float array;
    lengths : float array;
    tail_masses : float array;
    g : float;
}

let create masses lengths g = 
    let n = Array.length masses in
    let tail_masses = Array.make n 0.0 in

    tail_masses.(n - 1) <- masses.(n - 1);
    for i = n - 2 downto 0 do
        tail_masses.(i) <- masses.(i) +. tail_masses.(i + 1)
    done;

    { masses; lengths; tail_masses; g }