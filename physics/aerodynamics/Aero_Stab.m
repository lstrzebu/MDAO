function [Cla_w, Cm0_w, alphaL0_w, a0_w, stall_w, Cla_t, Cm0_t, alphaL0_t, a0_t] = Aero_Stab(b_w, c_w, d_fuse_w, sweep_w, airfoil_w, ...
                                 b_t, c_t, d_fuse_t, sweep_t, airfoil_t)


    % Wing
    [Cla_w, Cm0_w, alphaL0_w, a0_w,stall_w] = CL_alpha(b_w, c_w, d_fuse_w, sweep_w, airfoil_w);

    % Tail
    [Cla_t, Cm0_t, alphaL0_t, a0_t, ~] = CL_alpha(b_t, c_t, d_fuse_t, sweep_t, airfoil_t);
end
