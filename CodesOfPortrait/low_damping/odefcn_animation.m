function dydt = odefcn_animation(t,y,A1,A2,A3,A4,B,K,uh)
dydt = zeros(4,1);

dydt(1) = y(2)-A1*y(1)-y(4); % dz1
dydt(2) = y(3)-A2*y(2); % dz2
dydt(3) = -A3*y(3)-A4*sign(y(3))+0.0*sin(y(1)); % dz3
dydt(4) = sigmoidFun(t,7.5) - A2*y(2) + (B-A1)*(y(2)-y(4)-A1*y(1)) + K*y(1); % dgama
end