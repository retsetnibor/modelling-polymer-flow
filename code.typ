#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

Here is the code used to plot the polymer deformation
#codly(languages: codly-languages)
```python
import numpy as np
import matplotlib.pyplot as plt

plt.close('all')

domain = np.linspace(0,2*np.pi)
t=2


radius = 1
x0 = radius*np.cos(domain)
y0 = radius*np.sin(domain)
# z=0

tau_d = 0.2
gamma=5

A = [[1+gamma**2*tau_d**2, gamma*tau_d,0],
     [gamma*tau_d, 1, 0],
     [0,0,1]]

newx=[]
newy=[]

for i in domain:
    x=radius*np.cos(i)
    y=radius*np.sin(i)
    z=1
    pos=[x,y,z]
    newpos = np.matmul(A,pos)
    newx.append(newpos[0])
    newy.append(newpos[1])
    
figure, axes = plt.subplots(1)
axes.plot(x0,y0)
axes.plot(newx,newy)
```

#codly(languages: codly-languages)
```python
import numpy as np
import scipy as sc
import matplotlib.pyplot as plt

#we need to solve a linear of 9 equations for 9 unknowns.

def equations(A, AInitial=np.zeros(9)):
    
    tau_d = 50
    gamma = 5
    beta = 0.5
    tau_r = 3
    
    A_xx, A_xy, A_xz, A_yx, A_yy, A_yz, A_zx, A_zy, A_zz = A
    
    g = lambda A_xx, A_yy, A_zz: 2/tau_r * (1- np.sqrt(3/(A_xx+A_yy+A_zz)))
    f = lambda A_xx, A_yy, A_zz: beta * np.sqrt(3/(A_xx+A_yy+A_zz))
    
    
    eqset = [ gamma*(A_xy + A_yx) - 1/tau_d * (A_xx - 1) - g(A_xx,A_yy,A_zz) * (A_xx +  f(A_xx,A_yy,A_zz) * (A_xx -1)),
              gamma * A_yy - 1/tau_d * A_xy - g(A_xx,A_yy,A_zz) * (A_xy + f(A_xx,A_yy,A_zz)*A_xy),
              gamma * A_yz - 1/tau_d * A_xz - g(A_xx,A_yy, A_zz) * (A_xz + f(A_xx,A_yy,A_zz)*A_xz),
              gamma * A_yy - 1/tau_d * A_yx - g(A_xx,A_yy, A_zz) * (A_yx + f(A_xx,A_yy,A_zz) * A_yx),
              - 1/tau_d * (A_yy -1) - g(A_xx,A_yy, A_zz) * (A_yy + f(A_xx,A_yy,A_zz) * (A_yy -1)),
              - 1/tau_d * A_yz - g(A_xx,A_yy, A_zz) * (A_yz + f(A_xx,A_yy,A_zz) * A_yz),
              gamma * A_zy - 1/tau_d * A_zx - g(A_xx,A_yy, A_zz) * (A_zx + f(A_xx,A_yy,A_zz)*A_zx),
              - 1/tau_d * A_zy - g(A_xx,A_yy, A_zz)*(A_zy + f(A_xx,A_yy,A_zz)*A_zy),
              - 1/tau_d * (A_zz - 1) - g(A_xx,A_yy, A_zz) * (A_zz + f(A_xx,A_yy,A_zz)*(A_zz-1))
        ]
    
    return eqset

A0 = np.ones(9)
AInitial = np.zeros(9)

domain = np.linspace(0,2*np.pi)
time = np.linspace(0,5,100)

A = sc.optimize.fsolve(equations, A0)

plt.close('all')

domain = np.linspace(0,2*np.pi)
t=2



radius = 1
x0 = radius*np.cos(domain)
y0 = radius*np.sin(domain)
# z=0

A = [ [A[0],A[1],A[2]],
      [A[3],A[4],A[5]],
      [A[6],A[7],A[8]]
     ]


newx=[]
newy=[]


for i in domain:
    x=radius*np.cos(i)
    y=radius*np.sin(i)
    z=1
    pos=[x,y,z]
    newpos = np.matmul(A,pos)
    newx.append(newpos[0])
    newy.append(newpos[1])
    
figure, axes = plt.subplots(1)
axes.plot(x0,y0)
axes.plot(newx,newy)
```

This is the code used to solve the Rolie-Poly equation:
#codly(languages: codly-languages)
```python
import numpy as np
import scipy as sc
import matplotlib.pyplot as plt
from pdb import set_trace

plt.close('all')

#defining parameters
tau_r = 0.3
tau_d = 5
gamma = 5
beta = 3

#defining the velocity gradient for the flow
u = np.array([ [0,gamma,0], [0,0,0], [0,0,0] ])

#differential equation
def dAdt(A, t):
    
    A = A.reshape(3, 3)
    sqrt_term = np.sqrt(3 / np.trace(A))
    
    dA = A @ u + u.T @ A + (1 / tau_d) * (A - np.identity(3)) \
         - (2 / tau_r) * (1 - sqrt_term) * (A + beta * sqrt_term * (A - np.identity(3)))
    
    return dA.flatten()

#steady state equation
def steadystate(A):
    
    A = np.array(A)
    A = A.reshape(3, 3)

    sqrt_term = np.sqrt(3 / np.trace(A))
    
    dA = A @ u + u.T @ A - (1 / tau_d) * (A - np.identity(3)) \
         - (2 / tau_r) * (1 - sqrt_term) * (A + beta * sqrt_term * (A - np.identity(3)))
    
    return dA.flatten()
    
    A = np.array(A)
    A = np.reshape(3,3)
    
    sqrt = np.sqrt(3/np.trace(A))
    
    dAdt = A @ u + u.T @ A - 1/tau_d * (A - np.identity(3)) - 2/tau_r * (1 - sqrt) * (A + beta * sqrt) * (A-np.identity(3))
    
    dAdt = dAdt.flatten()
    
    return dAdt

#solving everything
t = np.linspace(0,10, 1000)
A0 = np.eye(3).flatten()
solution = sc.integrate.solve_ivp(lambda t, A: dAdt(A, t), [t[0], t[-1]], A0, t_eval=t).y

initial = solution[:,-1]
steadystatesolution = sc.optimize.fsolve(steadystate, initial)

#plotting everything
plt.figure(figsize=(7, 5))
plt.plot(t, solution[1,:], 'b', label='beta = 0.7')


# tau_r = 1
# tau_d = 100
beta=1
solution = sc.integrate.solve_ivp(lambda t, A: dAdt(A, t), [t[0], t[-1]], A0, t_eval=t).y
plt.plot(t, solution[1,:], 'r', label='beta = 1')

beta=0.4
solution = sc.integrate.solve_ivp(lambda t, A: dAdt(A, t), [t[0], t[-1]], A0, t_eval=t).y
plt.plot(t, solution[1,:], 'orange', label='beta = 0.1')
#plt.plot(t, steadystatesolution[1] * np.ones_like(t), 'r--', label='Steady state')
plt.xlabel(r'Time, $t$')
plt.ylabel(r'Shear stress, $A_{xy}$')
plt.title(r'Shear stress vs time')
plt.legend()
plt.grid(True)
plt.tight_layout()

plt.figure(figsize=(7,5))
for beta in [0,0.5,1]:
    solution = sc.integrate.solve_ivp(lambda t, A: dAdt(A, t), [t[0], t[-1]], A0, t_eval=t).y
    stretch = np.sqrt((solution[0,:]+solution[4,:]+solution[8,:])/3)
    plt.plot(t, stretch, label=rf'$\beta = {beta}$')
plt.legend()    

```
This is the code to plot the constitutive curve:
#codly(languages: codly-languages)
```python
import numpy as np
import scipy as sc
import matplotlib.pyplot as plt
from pdb import set_trace

#parameters
td = 5
tr = 0.3

#rolie poly eq
def RoliePoly(A,t):
    
    u = np.array([ [0,gamma,0], [0,0,0], [0,0,0]])
    A = np.array(A).reshape(3,3)
    I = np.eye(3)
    stretch = np.sqrt(3/np.trace(A))
    
    
    dAdt = u @ A + A @ u.T - 1/td * (A - I) - 2/tr * (1-stretch)*(A + beta * stretch * (A-I))
    
    return dAdt.flatten()

#spaces and initial condition for solve_ivp
t = np.linspace(0,100,100)
A0=np.eye(3).flatten()
gammavals = np.logspace(-2,5,50)

plt.figure(figsize=(7, 5))
for beta in [0,1]:
    curve=[]
    for gamma in gammavals:
        solution = sc.integrate.solve_ivp(lambda A,t: RoliePoly(t,A), [t[0], t[-1]], A0, t_eval=t).y
        a = solution[:,1][1]
        curve.append(a)
    
    plt.loglog(gammavals, curve, label=rf'$\beta = {beta}$')

plt.xlabel(r'$\dot{\gamma}$')
plt.ylabel(r'Shear stress, $A_{xy}$')
plt.legend()        

```
This is the code used to solve the Rolie-Double-Poly system:
#codly(languages: codly-languages)
```python
import numpy as np
import scipy as sc
import matplotlib.pyplot as plt
from pdb import set_trace

plt.close('all')

#set parameters

tdS = 5
tsS = 0.01

tdL = 100
tsL = 1

Bth = 1
BCCR = 1

phi_S = 1
phi_L = 1 - phi_S

d = -0.5

G = 1

fE=1
#sets the flow gradient
gamma = 5
u = np.array([ [0,gamma,0], [0,0,0], [0,0,0] ])

I = np.identity(3)

#now define the equations to solve
def Ass(A,t):
    
    A = A.reshape(3,3)
    L = np.sqrt(1/3*np.trace(A))
    #fE = (1-5**-2)/(1-L**2 * 5**-2)
    dAssdt = u @ A + A @ u.T - 1/tdS * (A - I) - 2 * (1-L**-1)/tsS * fE * (A + BCCR*L**(2*d)*(A - I))
    
    return dAssdt.flatten()

def All(A,t):
    
    A = A.reshape(3,3)
    L = np.sqrt(1/3 * np.trace(A))
    #fE = (1-5**-2)/(1-L**2 * 5**-2)
    dAlldt = u @ A + A @ u.T - 1/tdL * (A - I) - 2 * (1-L**-1)/tsL * fE * (A + BCCR*L**(2*d)*(A - I))
    
    return dAlldt.flatten()

def Asl(A,t):
    
    A = A.reshape(3,3)
    L = np.sqrt(1/3 * np.trace(A))
    #fE = (1-5**-2)/(1-L**2 * 5**-2)
    dAsldt = u @ A + A @ u.T - 1/(2*tdS) * (A - I) - 2 * (1-L**-1)/tsS * fE * A - (A - I) * (Bth/(2*tdL) + 2 * BCCR * (1-L**-1)/tsL * fE * L**(2*d))

    return dAsldt.flatten()

def Als(A,t):
    
    A = A.reshape(3,3)
    L = np.sqrt(1/3 * np.trace(A))
    #fE = (1-5**-2)/(1-L**2 * 5**-2)
    dAsldt = u @ A + A @ u.T - 1/(2*tdL) * (A - I) - 2 * (1-L**-1)/tsL * fE * A - (A - I) * (Bth/(2*tdS) + 2 * BCCR * (1-L**-1)/tsS * fE * L**(2*d))

    return dAsldt.flatten()

#solves the stuff
t = np.linspace(0, 5, 10000)
A0 = np.eye(3).flatten()

def solve():

    ss_solution = sc.integrate.solve_ivp(lambda t, A: Ass(A, t), [t[0], t[-1]], A0, t_eval=t).y
    ll_solution = sc.integrate.solve_ivp(lambda t, A: All(A, t), [t[0], t[-1]], A0, t_eval=t).y
    
    sl_solution = sc.integrate.solve_ivp(lambda t, A: Asl(A, t), [t[0], t[-1]], A0, t_eval=t).y
    ls_solution = sc.integrate.solve_ivp(lambda t, A: Als(A, t), [t[0], t[-1]], A0, t_eval=t).y

    #works out the total stress tensor
    As = phi_S * ss_solution + phi_L * sl_solution
    Al = phi_L * ll_solution + phi_S * ls_solution

    sigma = G * (phi_S * fE * As + phi_L * fE * Al)

    return [As, Al, sigma]

index = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]

plt.figure(figsize=(7, 5))
plt.title('Stress $A_{xy}$ for different polymer melt compositions')
Assol=[]
Alsol=[]
#gets the solution for different phi values and plots
for i in index:
    phi_S = i
    phi_L =1 - phi_S 
    sols = solve()[2][1]
    Assol.append(solve()[0][1,:])
    Alsol.append(solve()[1][1,:])
    plt.plot(t, sols, label=f'$\phi_S = {i}$')
    
    
#plots the stuff
plt.xlabel(r'Time, $t$')
plt.ylabel(r'Shear stress, $\sigma$')
plt.legend()
plt.grid(True)
plt.tight_layout()



phi_L = 0.5
phi_S = 1 - phi_L


plt.figure(figsize=(7, 5))
plt.title('Shear stress for a 50/50 melt composition')
plt.plot(t,solve()[0][1,:], 'b', label='$A_{xy}^S$')
plt.plot(t,solve()[1][1,:], 'r', label='$A_{xy}^L$')
plt.legend()
plt.tight_layout()
plt.grid(True)


plt.figure(figsize=(7, 5))
plt.plot(t,Alsol[1])
plt.plot(t, Assol[1])

plt.xlabel(r'Time, $t$')
plt.ylabel(r'Shear stress, $A_s$')
plt.title(r'Shear stress vs time')
plt.legend()
plt.grid(True)
plt.tight_layout()

#shortStretch = np.sqrt((solve()[0][0,:]+solve()[0][4,:]+solve()[0][8,:])/3)
#longStretch = np.sqrt((solve()[1][0,:]+solve()[1][4,:]+solve()[1][8,:])/3)

plt.figure(figsize=(7,5))
for BCCR in [0,0.5,1,5]:
    #set_trace()
    longStretch = np.sqrt((solve()[1][0,:]+solve()[1][4,:]+solve()[1][8,:])/3)
    plt.plot(t,longStretch, label=rf'$\beta = {BCCR}$')
plt.legend()

plt.figure(figsize=(7,5))
for BCCR in [0,0.5,1,5]:
    #set_trace()
    shortStretch = np.sqrt((solve()[0][0,:]+solve()[0][4,:]+solve()[0][8,:])/3)
    plt.plot(t,shortStretch, '.', label=rf'$\beta = {BCCR}$')
plt.legend()

```
This is the code used to solve the Newtonian full time pipe flow:
#codly(languages: codly-languages)
```matlab
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
```
This is the code used to solve the dumbbell pipe flow:
#codly(languages: codly-languages)
```matlab
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
```
This is the code used to solve the Rolie-Poly pipe flow:
#codly(languages: codly-languages)
```matlab
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
```
