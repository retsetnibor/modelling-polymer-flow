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
