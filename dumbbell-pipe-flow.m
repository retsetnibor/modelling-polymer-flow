function dumbbell_pipe_flow
    %parameters
    R = 0.2;
    mu = 0.01;
    dpdz = 50;
    rho = 1;
    G=2;
    td=0.01;
    tmax = 10;


    %important stuff
    r = linspace(0, R, 100);
    t = linspace(0, tmax, 1000);

    %define the pde in the way the solver likes
    function [c, f, s] = pdefun(r, t, w, dwdr)
        c = 1;
        f = (2*mu + G*td) * dwdr;
        s = dpdz / rho + 1/r*dwdr*(G*td*(1-exp(-t/td))+2*mu);
    end

    %define the initial condition
    function w0 = icfun(r)
        w0 = 0;
    end
    
    %define the boundary conditions
    function [pl, ql, pr, qr] = bcfun(rl, wl, rr, wr, t)
        pl = 0; ql = 1;   % dw/dr = 0 at r = 0
        pr = wr; qr = 0;  % w = 0 at r = R
    end


    %solve the stuff
    m = 1;
    sol = pdepe(m, @pdefun, @icfun, @bcfun, r, t);

    %get the solution
    w = sol(:,:,1);

%plotting everything
    figure;
    hold on;
    plot_times = [0, 1, 2.5, 6, 8, tmax];  % times to plot
    colors = lines(length(plot_times));

    for i = 1:length(plot_times)
        [~, idx] = min(abs(t - plot_times(i)));
        plot(r, w(idx, :), 'DisplayName', ['t = ' num2str(t(idx))], 'Color', colors(i,:));
    end

    xlabel('Radius r');
    ylabel('Velocity w(r,t)');
    title('Velocity profiles over time');
    legend show;
    grid on;

    rolie_poly_pipe_test
end
