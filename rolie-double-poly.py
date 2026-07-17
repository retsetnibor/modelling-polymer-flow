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
