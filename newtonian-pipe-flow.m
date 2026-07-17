function newtonian_pipe_flow
    %parameters
    R = 0.2;
    nu = 0.01;
    dpdz = 1;
    rho = 1;
    tmax = 10;

    %important stuff 
    r = linspace(0, R, 100);
    t = linspace(0, tmax, 100);

    %define the pde in the way the solver likes
    function [c, f, s] = pdefun(r, t, w, dwdr)
        c = 1;
        f = nu * dwdr;
        s = dpdz / rho;
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
    plot_times = [0.01, 0.05, 0.1, 0.5, 1.0, tmax];  % times to plot
    colors = lines(length(plot_times));

    for i = 1:length(plot_times)
        [~, idx] = min(abs(t - plot_times(i)));
        semilogx(r, w(idx, :), 'DisplayName', ['t = ' num2str(t(idx))], 'Color', colors(i,:));
    end

    xlabel('Radius r');
    ylabel('Velocity w(r,t)');
    title('Velocity profiles over time');
    legend show;
    grid on;
end
