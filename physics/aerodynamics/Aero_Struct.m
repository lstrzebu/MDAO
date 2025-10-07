function [y_span_w, Lprime_w, Ltotal_w, CL_w, y_span_t, Lprime_t, Ltotal_t, CL_t] = Aero_Struct(b_w, c_w, alpha_w, a0_w, alpha_L0_w, V, ...
                             b_t, c_t, alpha_t, a0_t, alpha_L0_t, V_t)
% Call Lift_Distr for both wing and tail and return one big output vector
%
% Output order:
%   [y_span_w, Lprime_w, Ltotal_w, CL_w, ...
%    y_span_t, Lprime_t, Ltotal_t, CL_t]

    % Wing
    [y_span_w, Lprime_w, Ltotal_w, CL_w] = Lift_Distr(b_w, c_w, alpha_w, a0_w, alpha_L0_w, V);

    % Tail
    [y_span_t, Lprime_t, Ltotal_t, CL_t] = Lift_Distr(b_t, c_t, alpha_t, a0_t, alpha_L0_t, V_t);

end