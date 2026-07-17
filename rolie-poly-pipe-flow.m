function roliepolypipeflow
    %parameters
    R = 0.3;
    dpdz = 2000;
    G = 100;
    tr = 0.1;
    beta = 1;
    mu = 0.5;
    td = 5;
    L = 100;
    rho=1;
    r = linspace(0, R, 300);
    fullr = cat(2,-1*flip(r),r);
    t = linspace(0, 50, 100);

    %define the pde in the way the solver likes
    function [c, f, s] = pdefun(r, t, w, dwdr)

    g = sqrt(3/(w(3)+w(4)+w(5)));
    c = [rho; 1; 1; 1; 1;];

    % Flux terms (f)
    f1 = 2*mu*dwdr(1) + G*w(2);  
    f2 = 0; 
    f3 = 0; 
    f4 = 0; 
    f5 = 0; 

    f = [f1; f2; f3; f4; f5];

    % Source terms (s)
    s1 = dpdz;


    A_rr = -1/td * (w(3)-1) - 2/tr*(1-g) * (w(3)+beta*g*(w(3)-1));
    A_phiphi = -1/td * (w(4)-1) - 2/tr*(1-g) * (w(4)+beta*g*(w(4)-1));
    A_rz = w(3) * dwdr(1) - 1/td * w(2) - 2/tr *(1-g)*(w(2) + g*beta*w(2));
    A_zz = 2*dwdr(1) * w(2) - (w(5)-1)/td - 2/tr*(1-g) * (w(5)+beta*g*(w(5)-1));

    s = [s1; A_rz; A_rr; A_phiphi; A_zz];

    end

    %define the initial condition
    function w0 = icfun(r)
    w0 = [0; 0; 1; 1; 1]; % [initial velocity; initial A_rz]
    end

    %define the boundary conditions
    function [pl, ql, pr, qr] = bcfun(rl, ul, rr, ur, t)
    % Left boundary: r = 0
    pl = [0; 0; 0; 0; 0];     
    ql = [1; 1; 1; 1; 1];    

    % Right boundary: r = R (wall)
    pr = [ur(1); 0; 0; 0; 0];
    qr = [0; 1; 1; 1; 1];    
    end

    %solve the stuff
    m=1;
    sol = pdepe(m, @pdefun, @icfun, @bcfun, r, t);



    w = sol(:,:,1);     % velocity
    w = cat(2,flip(w(end,:)),w(end,:));
    

    Arz = sol(:,:,2); 
    Arz = cat(2,flip(Arz(end,:)),Arz(end,:));

    Arr = sol(:,:,3);
    Aphiphi = sol(:,:,4);
    Azz = sol(:,:,5);

    
    stretch = sqrt((Arr+Aphiphi+Azz)./3);
    stretch = cat(2,flip(stretch(end,:)),stretch(end,:));

    % Plot
    figure;
    plot(fullr, w, 'b', 'LineWidth', 2);
    xlabel('Pipe radius, r'); ylabel('Velocity, w(z,t)');
    title('Velocity profile in steady state');

    figure;
    hold on;
    plot(fullr, Arz, 'b', 'LineWidth',2);
    xlabel('Pipe radius, r'); ylabel('A_{rz}');
    title('Shear stress in steady state');

    figure
    plot(fullr, stretch, 'b', 'LineWidth',2)
    xlabel('Pipe radius, r'); ylabel('trA');
    title('Stretch in steady state');
end
