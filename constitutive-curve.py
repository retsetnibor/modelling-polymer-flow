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
