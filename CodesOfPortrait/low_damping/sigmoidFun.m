function f = sigmoidFun(t,T)    
n = 20;
T=3;
delta_T = 3;
end_T = 5;
alpha =1;
f = 35;
delta_f = 25;
    if t<T
       f = (f./(1+(t./T).^(2*22))+delta_f)*alpha;
 
    elseif T<t&&t<T+delta_T
        f = delta_f*alpha;
    else
%        f = f./(1+exp((2.5*t-19)));
f = ((f./(1+(t./T).^(2*22))+delta_f)./(1+(t./end_T).^(2*n)))*alpha;

    end
end