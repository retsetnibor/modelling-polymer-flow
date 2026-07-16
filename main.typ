#import "@preview/great-theorems:0.1.2" as great_theorems
#import "@preview/headcount:0.1.0": *

#let numbered_eq(content) = math.equation(
    block: true,
    numbering: dependent-numbering("(1.1)", levels: 1),
    number-align: end+horizon,
    content,
)

#let nhat(content) = $limits(content)^nabla$
#let eqcounter = counter("hello")

#show: great_theorems.great-theorems-init
#set page(margin: 1.2in)
#set par(leading: 1em, spacing: 1em, first-line-indent: 1.8em, justify: true)
#set text(font: "New Computer Modern" , size: 12pt)
#show raw: set text(font: "New Computer Modern")
#show heading: set block(above: 1.4em, below: 1em)
#show math.equation: set block(above:0.5cm, below: 0.5cm)
#set heading(numbering: "1.1 ")
#show heading: reset-counter(eqcounter, levels: 1)


#align(center, text(25pt)[
  *Modelling Polymer Flow*
])
\
#align(center, text(15pt)[
  #image("figures/LeedsCrest2.png", width: 7cm)\
  #v(1cm)\
  Robin Tester\
  Student Number: 201441256\
  Supervised by: Dr Claire McIlroy\
  MATH5000M\
  August 20, 2025
])


#pagebreak()
In this dissertation we study the mathematics of polymer melts, a non Newtonian fluid. To start, we introduce polymer chains and how to model them mathematically, following theory presented by Doi & Edwards @bible. We state some properties of a single polymer chain such as relaxation time and radius of gyration. We then introduce two models for polymer chains: the dumbbell and tube models. The dumbbell model is the simplest model that incorporates the elasticity of a single polymer chain and the tube model is used to handle relaxation of entanglements between multiple polymer chains. We derive a deformation equation for the dumbbell model. Following Likhtman & Graham @roliepoly, we extend the tube model to the Rolie-Poly constitutive model that includes more detailed descriptions of relaxation. We also derive a deformation equation for the Rolie-Poly model. We subject both the dumbbell and Rolie-Poly model to shear flows and discuss the flow profile, stress profile and stretch profile. \
\
We then introduce polydisperse polymers and,
following the work of Boudara @Boudara, discuss a constitutive model for a bi-disperse polymer melt, based on the Rolie-Poly model. We subject this to a shear flow and discuss the effect of changing the composition of the polymer melt. \
\
Finally, we derive the flow profile for a Newtonian fluid before subjecting a monodisperse polymer melt to a pipe flow.
We solve for the flow profile of a melt pipe flow, following the work of McIlroy & Olmsted, to compare it to that of a Newtonian fluid. We justify the differences by investigating the stretch and stress profiles.


#pagebreak()
#set page(numbering: "1")


#outline(depth: none)

#pagebreak()
= Introduction <introduction>
Polymers can be found everywhere in everyday life. They can be natural, such as DNA or protein chains in cells, or synthetic such as polystyrene. Synthetic chains are man-made and used in consumer products all over the globe (in raincoats or packing peanuts, for example). Polymers are long molecules comprised of lots of repeating units, monomers, that are linked together with strong covalent bonds. Due to the high strength of these covalent bonds, most polymers are solid at room temperature.\
\
Polymers in a liquid form are known as polymer melts and they contain thousands of polymer chains. Melts are usually quite viscous and elastic. For example, chewing gum is a polymer melt that can be stretched out and shrunk. Investigating this viscoelasticity property is one of the main interests of Rheology.\
\
Polymers are used in so many things because of the versatile range of properties they can have. They often have a lower density than other solid materials and have high extensibility so can be stretched as necessary. Despite their lightweight composition, they are often strong. Another attractive property of polymers are low melting points. Even though they share these main properties, different polymer chains will have different lengths and different molecular weights. Different monomers have different weights, thus the weight of the polymer chain depends on which monomers are in its composition.  \
\
Industry-used polymer melts are typically polydisperse: they are composed of polymers that have a whole distribution of chains lengths and molecular weights. Particular cases of this are mono-disperse and bi-disperse melts. Mono-disperse melts have only one kind of polymer within; that is, chains with an equal length and molecular weight. Bi-disperse have two different kinds of polymers within. \
\
The chains within a melt move randomly and can become entangled with each other, much like a bowl of spaghetti or cables in a pocket. Because of these entanglements, it becomes hard to describe the dynamics of a single polymer chain within the melt and assumptions must be made about the orientation of the polymers to create constitutive models.\
\
Due to the viscoelastic properties and entanglements, one cannot describe flows of polymer melts in the same way as a Newtonian fluid. As we will see, there is an extra contribution to the stress tensor @John-fluid so the Navier-Stokes equations cannot be used. As a polymer can be stretched and deformed, it can be harder to track the movement of a single chain compared to a single fluid particle in traditional Newtonian fluid dynamics. \
\
One of the largest applications of polymer melts is in 3D printing, in which consumer grade plastic goods can be created without the use of a mould, even in cases where non-trivial shapes must be created. The process is seemingly simple: a polymer melt is extruded through a nozzle to build up layers of plastic on a plate in the x - y plane. Once one layer has been printed, the nozzle moves slightly higher in the z direction to build the next layer, slowing building a print layer by layer. Polymer dynamics are so integral for 3D printing because the melts must be transported from a reserve to the nozzle. Thus, we must know how they flow in order to create effective methods of transport. \
\
In this project, we will give a brief introduction to rheology and the mathematics of polymer chains by considering different models. In particular, we will discuss these models in the context of a shear flow. We will then discuss pipe flow for Newtonian and polymer flows and investigate the differences.


= Polymer Modelling <polymer-modelling>
In this section we will introduce some important concepts from rheology that will form the basis of this dissertation. We will follow theory presented by de Gennes @scalingpolymer, Doi and Edwards @bible and Boudara @Boudara. Rheology is defined as the study of materials - in particular, the mechanical properties of those materials. These properties include the stress and strain of a material and what impacts they have on the deformation of the material. 

== Stress <stress-section>
In this section we will define the stress tensor for a _Newtonian_ fluid and the discuss what happens to the stress tensor in a polymer solution.\
\
The deformation rate, or deformation tensor, of a fluid is calculated from the velocity field, $bold(u)(bold(r),t)$, and is denoted by the velocity gradient tensor,

#numbered_eq($bold(kappa)(bold(r),t) = (nabla bold(u))^T.$) <deformation-rate>

@deformation-rate is commonly split into two parts: a _symmetric_ rate of strain tensor, $bold(E)$, and a _traceless_ vorticity tensor, $bold(Omega)$, with

$ bold(E) = 1/2 (bold(kappa) + bold(kappa)^T), \ bold(Omega) = 1/2 (bold(kappa) - bold(kappa)^T). $

Thus, the deformation tensor can be expressed as  

#numbered_eq($bold(kappa) = bold(E) + bold(Omega).$)

In a Newtonian fluid (which has a linear relation between stress rate and local strain), the full stress tensor is

#numbered_eq($ bold(sigma) = p bold(I) +2mu (nabla bold(u) + (nabla bold(u))^T) = 2mu bold(E). $)

where $mu$ is the fluid viscosity and $p$ is the pressure acting on the fluid. However, in a melted polymer solution there is a non-linear relationship between stress and strain which leads to the following stress tensor

#numbered_eq($bold(sigma) =p bold(I) + 2 mu bold(E) + G_e (bold(A) - bold(I)).$) <non-newt-stress-tensor>

Here we have an extra contribution to the stress tensor. The final term is the plateau modulus, $G_e$, multiplied by a polymer deformation tensor, $bold(A)$. The deformation tensor takes the form 

#numbered_eq($bold(A) = mat(
   A_(x x), A_(x y), A_(x z);A_(y x), A_(y y), A_(y z);A_(z x), A_(z y), A_(z z), ).
$)

The extra term causes issues when solving flow problems because the Navier-Stokes equations cannot be used. Any problem must be derived from the general form of the momentum equation.

== Polymer chains
We can consider a polymer chain mathematically as $N$ points connected by springs of length $b$, giving $N-1$ segments of a chain. This is the Rouse model, first proposed in 1953 by Rouse @rouse1953theory. He proposed that the chain can diffuse by Brownian motion and every particle in the chain exerts a force on both of its neighbours.
Each segment in the chain can be modelled as an elastic dumbbell @dumbbell-book, as seen in @polymer_no_angle. The "dumbbell" consists of two points connected by a spring with spring constant $k$ (as seen in @polymer-chain). This type of model is the simplest way to incorporate elasticity. The spring stretches and relaxes on some time scale that we can find.\
\
The chain configuration is represented formally by the set of position vectors of the points ${bold(R)_N} = (bold(R)_0, ... ,bold(R)_N)$. Then the total length of the polymer is represented by the _end to end_ vector

#numbered_eq($ bold(R) = bold(R)_N - bold(R)_0.  $)

Since each segment of the chain follows a Gaussian distribution, they can be treated as independent from one other. We have that the mean length of a freely-jointed polymer is 

#numbered_eq($ angle.l bold(R) angle.r = 0 \ $)

where $angle.l dot angle.r$ denotes the average. The variance of a polymer chain is given by

#numbered_eq($angle.l bold(R)^2 angle.r = N b^2. $) <variance>

The distribution of the polymer length is given by

#numbered_eq($p(N,bold(r)) = (frac(3, 2pi N b^2))^(3\/2) exp(-frac(3 bold(R)^2, 2N b^2)).$)

#figure(
  image("figures/Rouse Model.jpeg", width: 9cm), caption: [Rouse model of polymer chains with length $b$ and radius of gyration $R_g$.]
) <polymer-chain> \
\
Since all of the particles in a chain are connected, if one moved by a distance $R$, say, it would have to pull on all the particles within a circle of radius $R$. This circle is known as the radius of gyration and is denoted $R_g$. We can find the value of $R_g$ for an ideal polymer. Starting from the definition of $R_g$ @radiusofgyration,

$ R_g^2 = 1/(2N^2) sum_(i=1)^N sum_(j=1)^N angle.l (r_i - r_j)^2 angle.r \ = b^2/(2N^2) sum_(i=1)^N sum_(j=1)^i i^2 - j \ = b^2/(2N^2) (frac(N(N+1)(2N+1), 6) - N(N+1)/2) = b^2/(2N^2) (N^3/3 + O(N^2)) \ = (N b^2)/6 arrow.double R_g = 1/sqrt(6) sqrt(N)a^2. $

The polymer deformation tensor can be expressed in terms of the end-to-end vector and radius of gyration,

#numbered_eq($A_(i j) = frac(angle.l R_i R_j angle.r, 3 R_g^2).$)

Expressing the tensor in this way is useful for deriving equations of motion for the deformation, as we will see in the next section. Furthermore, the stretching of a polymer can be described by the trace of $bold(A)$. When $i=j$, we have 

$ A_(i i) = frac(angle.l |R_i|^2 angle.r, 3 R^2_g) $

Which is a measure of distance from equilibrium. Thus we denote the stretch of the polymer chain by $Lambda = "tr"bold(A).$ Often we will normalise this by setting $Lambda = 3\/"tr"bold(A)$.\
\
The time scale in which the springs stretch and relax has been well studied. Here, we will just state the main result from Doi and Edwards, but for more detail see chapter 4 of @bible. The longest relaxation time for an N particle polymer chain is 

#numbered_eq($tau_R = frac(zeta N^2 b^2, 3pi^2 k_B T)$)
Where $T$ is the temperature of the polymer and $k_B$ is the Boltzmann constant.
For our purposes, relaxation time can be related to the molecular weight of a considered polymer. From @variance we have $R_g tilde sqrt(N b^2) tilde M_w^(1/2)$ and we also have that diffusion coefficient scales like $D tilde M_w^(-1)$. So the relaxation time scales like

#numbered_eq($ tau_R tilde frac(R_g^2, D) tilde frac(M_w, M_w^(-1)) = M_w^2. $) <relaxation-time-tau_r>

== Dumbbell Model <dumbbell-model-section>
We will now consider a single segment from a polymer chain. That is, two particles connected by a spring with spring constant $k$. We aim to study how this single chain deforms within a melt. Here, we derive an equation for this deformation. \
\
The dynamics of the model can be found by considering the forces acting on the dumbbell when it is in a flow. There are 3 forces: a relaxation force by the spring, a drag force acting on the molecules due to the movement of the flow and a thermal force due to random collisions of the molecules with the surrounding particles. 

#figure(
  image("figures/polymer_no_angle.jpeg", height: 30% ), caption: [
    A polymer modelled as a spring, of length $bold(R)$, between two points.
  ],
)<polymer_no_angle> \
The resultant force on both of the particles is

$ bold(F)_"spring" + bold(F)_"drag" + bold(F)_"thermal" = 0. $

From here we can get 2 equations of motion for the particles. For particle 1:

#numbered_eq($k(bold(r)_1 - bold(r)_2) - zeta (frac(d bold(r)_1, d t) -bold(u)(bold(r)_1)) + bold(f)_1 = 0,$) <particle-1-eq>

and similarly for particle 2:

#numbered_eq($k(bold(r)_2 - bold(r)_1) - zeta (frac(d bold(r)_2, d t) -bold(u)(bold(r)_2)) + bold(f)_2 = 0.$) <particle-2-eq>

where $zeta$ is the coefficient of drag and $bold(f)_1, bold(f)_2$ are thermal forces. By substracting @particle-1-eq from @particle-2-eq and recalling $bold(R) = bold(r)_2 - bold(r)_1$ we have

#numbered_eq($zeta frac(d bold(R), d t) - zeta(bold(u)(bold(r)_2)-bold(u)(bold(r)_1)) = 2k bold(R) + bold(f).$) <particle-motion-eq>

We can expand $bold(u)$ around $bold(r)_1$ with a Taylor expansion, giving 

$ u_i (bold(r)_2) = u_i (bold(r_1)) + frac(diff u_i, diff x_k) (bold(r)_2 - bold(r)_1)_k = u_i (bold(r_1)) + frac(diff u_i, diff x_k) R_k. $

Substitution into @particle-motion-eq gives

#numbered_eq($ zeta frac(d bold(R), d t) - zeta (nabla bold(u) dot bold(R)) = 2k bold(R) + bold(f),$)

which in tensor notation is 

#numbered_eq($ frac(d R_i, d t) - nabla_k u_i R_k - (2k)/zeta R_i + f_i/zeta.$)

We want an equation in terms of $A_(i j) = angle.l R_i R_j angle.r$, so multiplying by $R_j$ gives

#numbered_eq($R_j frac(d R_i, d t) = nabla_k u_i R_k R_j - (2k)/zeta R_i R_j + f_i/zeta R_j.$) <multiplied-by-Rj>

Then we can get another equation in terms of $R_i$ and $R_j$ by cyclic permutation of @multiplied-by-Rj, giving

#numbered_eq($R_i frac(d R_j, d t) = nabla_k u_j R_i - (2k)/zeta R_j R_i + f_j/zeta R_i.$) <cyclic-permuted-eq>

Adding these together yields

#numbered_eq($d/(d t)(R_i R_j) = nabla_k u_i R_k R_j + R_i R_k (nabla_i u_k)^T - (4k)/zeta R_i R_j + 1/zeta (f_i R_j + (f_i R_j)^T).$)

Taking the average gives

#numbered_eq($d/(d t) angle.l R_i R_j angle.r = nabla_k u_i angle.l R_k R_j angle.r + angle.l R_i R_k angle.r (nabla_j u_k)^T - (4k)/zeta angle.l R_i R_j angle.r + (4k_B T) / zeta delta_(i j).$)

Letting $Q_(i j) = angle.l R_i R_j angle.r$ gives

#numbered_eq($frac(d bold(Q), d t) = nabla bold(u) dot bold(Q) + bold(Q) dot (nabla bold(u))^T - (4k)/zeta bold(Q) + (4k_B T)/zeta bold(I).$)

Finally, introducing a time scale $tau = zeta \/ (4k)$ and a re-scaling $bold(A) = 3 bold(Q) \/ N b^2$ gives

#numbered_eq($frac(d bold(A), d t) = nabla bold(u) dot bold(A) + bold(A) dot (nabla bold(u))^T - 1/tau (bold(A)-bold(I)).$) <dumbbell-dynamics-eq>

=== Resting state of a dumbbell
The simplist case we can study is to put the dumbbell into a system with no motion $(bold(u) = bold(0))$. In this scenario, $nabla bold(u) = (nabla bold(u))^T = 0$, so @dumbbell-dynamics-eq reduces to 

#numbered_eq($ frac(d bold(A), d t) = - frac(1,tau) (bold(A)-bold(I))arrow.r.double bold(A) = bold(I) = mat(1,0,0; 0,1,0; 0,0,1).$)

Physically, this means that the dumbbell will not deform at all if there is no flow in the system, regardless of how long it has been sitting there. This is exactly what is to be expected. There are no drag forces acting on the dumbbell, and since there is no motion in its surroundings, there will be no forces due to collisions. Thus, by Newton's first law @newton1850newton, the dumbbell will never deform.

=== Shear Flow
Now we will introduce a simple flow into the system. Consider a steady state shear flow $bold(u)=(gamma(y), 0, 0)$. This gives the velocity gradient tensor

#numbered_eq($ nabla bold(u) = frac(diff u_i, diff x_j) = mat(0, dot(gamma), 0; 0,0,0; 0,0,0) arrow.r.double (nabla bold(u))^T = mat(0,0,0; dot(gamma),0,0; 0,0,0). $)

Substituting into @dumbbell-dynamics-eq yields 

#numbered_eq($mat(dot(gamma)A_(x x), dot(gamma)A_(y y), dot(gamma)A_(y z); 0,0,0; 0,0,0) + mat(dot(gamma)A_(x y),0,0; dot(gamma)A_(y y),0,0; dot(gamma)A_(z y),0,0) = frac(1,tau_d) mat(A_(x x)-1, A_(x y), A_(x z); A_(y x), A_(y y)-1, A_(y z); A_(z x), A_(z y), A_(z z)-1).$) <dumbbell-matrix-eq>

Now by equating components and solving the linear system of equations we have an explicit form of the polymer deformation tensor

#numbered_eq($bold(A) = mat(1+2dot(gamma)^2tau_d^2, dot(gamma)tau_d, 0; dot(gamma)tau_d, 1, 0; 0,0,1 ).$)

The formation of the polymer in equilibrium can be seen in Figure 3; the deformation tensor has no effect on the orientation of the dumbbell. Similarly, the formation of the polymer in a shear flow can be seen in Figure 4; this time the deformation tensor acts on the dumbbell which deforms it such that $R_g$ is ellipsoidal. This deformation makes intuitive sense because it matches the profile for a shear flow (as seen in @shear-flow-profile-figure).

#grid(
  columns: 2,
  align: (center, center),
  gutter: 4%,
  figure(
    image("figures/polymer in circle.png", width: 7cm), caption: [Polymer solution in an equilibrium],
  ), 
    figure(image("figures/polymer in oval.png", width: 7cm), caption: [Polymer solution subject to a simple steady state shear flow], 
  )
) \

#figure(
  image("figures/Shear-flow.jpeg", width: 10cm), caption: [Shear flow]
)<shear-flow-profile-figure> \
\
@dumbbell-dynamics-eq can be solved when the flow is not in steady state, by method of seperation of variables and integrating factors. The method is the similar for all 9 components so we will only do the $A_(x y)$ component and then state the full solution. We have 

#numbered_eq($frac(d A_(x y), d t) = dot(gamma) - 1/tau_d A_(x y), #h(1cm) A_(x y)(0) = 0. $)

Introducing an integrating factor of $e^(t\/tau_d)$ and rearranging gives

#numbered_eq($frac(d, d t) (A_(x y)e^(t\/tau_d)) = dot(gamma)e^(t\/tau_d)\ arrow.double A_(x y)e^(t\/tau_d) = tau_d dot(gamma) + C.$)

Then by the initial condition we have $C = -tau_d dot(gamma),$

#numbered_eq($arrow.double A_(x y) = tau_d dot(gamma) - tau_d dot(gamma) e^(-t\/tau_d).$)

The full solution is 

#numbered_eq($bold(A)(t) = mat(A_(x x), A_(x y), 0; A_(x y), 1, 0; 0,0,1),$)

with 

$ A_(x x) = 1 + 2dot(gamma)^2 tau_d^2 (1-e^(-t\/tau_d)) - 2dot(gamma)^2 tau_d t e^(-t\/tau_d), \ A_(x y) = dot(gamma) tau_d ( 1-e^(-t\/tau_d)). $

If we let $t arrow infinity$, we recover the steady state solution. 

== Tube model <tube-model-section>
The dumbbell model considered the deformation of a melt with only a single polymer chain. When more than one chain is considered, problems arise due to the chains entangling with one another, much like a bowl of spaghetti or cables in a pocket. This entanglement between the chains acts to slow down the movement of a single polymer. One way to deal with this problem, mathematically, is to consider a polymer chain inside of a "tube" running parallel to the polymer's contour, as first done by Doi & Edwards @bible. By constricting the entangled polymers inside a tube, as seen in @polymer_chain_in_tube, the movement of the polymers is restricted to the direction of their own contours. Subsequently, there is no movement perpendicular to the direction of the tube and so no entanglements across chains. \
\
Much like the dumbbell's relaxation time, the tube has a unique relaxation mechanism. As there are now multiple polymers in the melt, movement along the tube is caused by random collisions of the tube and its neighbouring particles. Movement due to these collisions is known as _reptation_. The tube model incorporates both reptation and relaxation; the polymer chain inside the tube still relaxes according to @relaxation-time-tau_r and the tube will move due to the reptation.\
\
Since the tube is modelled from a polymer chain, it's length still follows the same Gaussian distribution as a single polymer chain, so the time it takes for a tube to move distance $L$, equal to its length is the _reptation time_, denoted $tau_d$ , which scales like

$ tau_d tilde frac(L^2, D) tilde frac(M_w^2, M_w^(-1)) = M_w^3. $


#figure(
  image("figures/polymer_chain_in_tube.jpeg", width: 12cm), caption: [
    A polymer chain (black) constrained in a tube (blue) entangled by other polymer chains (grey) showing two types of diffusion: relaxation time $(tau_R)$ and reptation time $(tau_d)$.
  ],
)<polymer_chain_in_tube> \
While the tube model is reliable for modelling mono-disperse polymer melts, problems arise when considering melts of polydisperse polymers. However, the theory can serve as a baseline for these melts, as we will see in @multiple-polymer-modelling-section.\
\
The tube model also fails to explain some experimental results, such as the stress at high shear rates @IANNIRUBERTO1996241. According to the model decreases with increasing shear rates but experiments show is actually increases with an increasing shear rate. These results need extra consideration when part of a full model, as we will see in @rolie-poly-model-section.

=== Reptation vs relaxation
It is useful to emphasize the difference between the two relaxation methods. The Rouse time, denoted $tau_r$, describes the time it takes for a whole polymer chain to stretch and relax. However, the reptation time, $tau_d$, is unique to the tube model and describes how long it takes for the whole tube (whose interior contains polymer chains) to stretch and relax.

== Rolie-Poly model <rolie-poly-model-section>
A particular example of a tube model is the Rolie-Poly model @roliepoly, which stands for ROuse, LInear Entangled POLYmers. This model accounts for the discrepancy from experimental data. A relaxation mechanism known as Convective Constraint Release (CCR), first proposed by Marrucci @IANNIRUBERTO1996241 is introduced. At large shear strength, the flow causes the polymer chains to move further away from the neighbouring chains, so each polymer has more room to diffuse out by reptation. There is effectively a relaxation method induced by the flow, and the Rolie-Poly model includes a term that accounts for this relaxation.\
\
The derivation of the equation, found in @doubleroliepoly, involves some in depth thermodynamics, so we will not go into much detail as that is beyond the scope of this dissertation. We will however, outline the second half of the argument which highlights how the stress behaves at high and low stretch. The main result is a differential equation in $bold(sigma)$ that describes the stress over time:

#numbered_eq($ frac(d bold(sigma), d t) = nabla bold(u) dot bold(sigma) + bold(sigma) dot (nabla bold(u))^T - 1/tau_d (bold(sigma) - bold(I)) - f_(r e t r)("tr"bold(sigma)) bold(sigma) - f_(C C R)("tr"bold(sigma))(bold(sigma)-bold(I)). $) <rolie-poly-derivation-start>

Where $f_(r e t r)$ describes relaxation and $f_(C C R)$ describes CCR. These functions are determined through physical arguments. In the case of small stretch $("tr"bold(sigma) - 3 << 1)$, the relaxation function must be proportional to the stretch as the tube must be allowed to relax to its equilibrium state $("tr"bold(sigma) = 3)$ and since the typical relaxation time is $tau_r$, we have  $f_(r e t r) tilde 2("tr"bold(sigma)-3)\/tau_R$. The CCR mechanism must be proportional to the relaxation (as at zero shear there is no CCR) so we have $f_(C C R) = 2beta("tr"bold(sigma)-3)\/tau_R$. Here, $beta$ is a real number that describes the amount of CCR. A low $beta$ means less relaxation due to CCR.\
\
At high stretch $("tr"bold(sigma) - 3 >> 1)$, the stretch must follow the relation $d lambda\/ d t = -(lambda -1) \/tau_R$, as seen in @lambdarelation. So with $lambda = sqrt("tr"bold(sigma) \/ 3)$, we must have $f_(r e t r) = 2\/tau_R$ as $"tr"bold(sigma) arrow infinity$ to satisfy this requirement. The CCR function at high stretch will depend on the stretch, so we take $f_(C C R) = 2beta (sqrt("tr"bold(sigma)\/3))\/tau_R$. Thus, we have:

$ f_(r e t r) = cases(frac(2("tr"bold(sigma)-3),tau_R) &"for" "tr"bold(sigma)-3 <<1",", 2/tau_R &"for" "tr"bold(sigma)-3 >> 1"," ) $

and

$ f_(C C R) = cases(frac(2 beta ("tr"bold(sigma)-3),tau_R) &"for" "tr"bold(sigma)-3<<1"," , frac(2beta sqrt(("tr"bold(sigma)\/3)),tau_R) &"for" "tr"bold(sigma)-3 >> 1".") $

Then, these functions must still have a value when switching between the two behaviours, so we can choose 

$ f_(r e t r) = frac(2(1-sqrt(3/("tr"bold(sigma)))), tau_R), #h(2cm) f_(C C R) = frac(2beta ("tr"bold(sigma))(1-sqrt(3/("tr"bold(sigma)))), tau_R). $

Substituting these into @rolie-poly-derivation-start gives the Rolie-Poly equation:

#numbered_eq($ frac(d bold(A),d t) = nabla bold(u) dot bold(A) + bold(A) dot (nabla bold(u))^T - frac(1, tau_d)(bold(A)-bold(I))  \ -  frac(2,tau_R)(1-sqrt(frac(3,tr bold(A)))) (bold(A) + beta sqrt(frac(3, tr bold(A))) & (bold(A)-bold(I))).$) <rolie-poly-eq>

Where we have swapped $bold(sigma) "for" bold(A)$ due to the form of our stress tensor (@non-newt-stress-tensor).

=== Shear flow <rolie-poly-shear-flow-section>
First we will solve the Rolie-Poly equation in a steady state so we are to solve 

#numbered_eq($0 = nabla bold(u) dot bold(A) + bold(A) dot (nabla bold(u))^T - frac(1, tau_d )(bold(A)-bold(I)) - \ frac(2,tau_R) (1-sqrt(frac(3,tr bold(A)))) (bold(A) + beta &sqrt(frac(3, tr bold(A))) (bold(A)-bold(I))).$)

Substituting the velocity tensor for a shear flow gives 

#numbered_eq($0 = mat(dot(gamma)(A_(x y)+A_(y x)), dot(gamma)A_(y y), dot(gamma)A_(y z); dot(gamma)A_(y y), 0, 0; dot(gamma)A_(z y), 0, 0) - frac(1,tau_d)(bold(A)-bold(I)) \ -frac(2,tau_R)(1-sqrt(frac(3,"tr"bold(A))))(bold(A)+beta sqrt(frac(3, "tr"bold(A))) & (bold(A)-bold(I))).$)

This leads to system of 9 non-linear equations that we must solve numerically for the 9 components of $bold(A)$:

#numbered_eq($dot(gamma)(A_(x y)+A_(y x)) - tau_d^(-1)(A_(x x)-1) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A))))(A_(x x) + beta sqrt(frac(3, "tr"bold(A))) (A_(x x)-1)),$)
#numbered_eq($dot(gamma)A_(y y) - tau_d^(-1)A_(x y) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(x y) + beta sqrt(frac(3, "tr"bold(A)))A_(x y)),$)
#numbered_eq($dot(gamma)A_(y z) - tau_d^(-1)A_(x z) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(x z) + beta sqrt(frac(3, "tr"bold(A)))A_(x z)),$)
#numbered_eq($dot(gamma)A_(y y) - tau_d^(-1)A_(x y) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(y x) + beta sqrt(frac(3, "tr"bold(A)))A_(y x)),$)
#numbered_eq($-tau_d^(-1)(A_(y y) - 1) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(y y) + beta sqrt(frac(3, "tr"bold(A))) (A_(y y)-1)),$)
#numbered_eq($-tau_d^(-1)A_(y z) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(y z) + beta sqrt(frac(3, "tr"bold(A)))A_(y z)),$)
#numbered_eq($dot(gamma)A_(z y)-tau_d^(-1)A_(z x) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(z x) + beta sqrt(frac(3, "tr"bold(A))) A_z x),$)
#numbered_eq($-tau_d^(-1)A_(z y) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(z y) + beta sqrt(frac(3, "tr"bold(A)))A_(z y)),$)
#numbered_eq($-tau_d^(-1)(A_(z z)-1) = 2 tau_R^(-1) (1-sqrt(frac(3,tr bold(A)))) (A_(z z) + beta sqrt(frac(3, "tr"bold(A)))(A_(z z)-1)).$) 
\
To solve this system of equations, we will use scipy's 'fsolve' function. This solver uses a modified Newton's method and measures the error by how close the solved root is to the true root. The error is defined by
$ "error" = |y_(t r u e) - y_k| $. The solver stops when the error reaches a certain tolerance level. Here, we have the allowed tolerance to $epsilon = 10^(-8)$, so we are confident that the solver is returning a correct answer. Futhermore, since it is a modified Newton's method solver, it converges to the solution quadratically @Powell1970. That is,

$ epsilon_(k+1) = O(epsilon_k^2). $

Because of this, we are confident that the solver is returning a correct value.\
\
The deformation of the polymer with the Rouse term included is found in @deformation-with-rouse. We can see that the polymer does not get as stretched as in the dumbbell case. This is because there are two relaxation mechanisms acting to balance the shear flow.

#figure(
    image("figures/polymer circle oval with rouse.png", width: 12cm), caption: [Deformation of a polymer  satisfying the Rolie-Poly equation in a simple shear flow. Equilibrium state (blue) and deformation due to shear flow (orange)],
  ) <deformation-with-rouse>\
\
If we use the values $tau_r = 0.3, tau_d = 5, gamma = 5 "and" beta = 1$ we get a steady state solution of 

$ bold(A) = mat(0.483304, 0.898248, 0; 0.898248, 3.8222, 0; 0, 0, 483304). $ 

=== Start up behaviour <fulltimesolution>
Now we solve the full Rolie-Poly equation in a shear flow numerically

#numbered_eq($ frac(d bold(A),d t) = nabla bold(u) dot bold(A) + bold(A) dot (nabla bold(u))^T + frac(1, tau_d)(bold(A)-bold(I))  \ -  frac(2,tau_R)(1-sqrt(frac(3,tr bold(A)))) (bold(A) + beta sqrt(frac(3, tr bold(A))) & (bold(A)-bold(I))).$)\
\
Similarly to before, this is just a set of 9 coupled differential equations that we will solve using a Runge-Kutta method. We will use scipy's 'solve_ivp' function. This is a Runge-Kutta 4(5) solver that has known error @BurdenFairesNumericalAnalysis of 

$ epsilon = O(d t^4) $ 
where $d t$ is the set time step. When using this solver, our time step was set to $d t =0.01$ so the error we have is $epsilon = 0.01^4 = 0.00000001$. Due to this low error, we are confident that the solver is returing a correct value.\
\
We are only interested in the $A_(x y)$ solution as it is the only one affected by the velocity gradient tensor. The solution can be found in @shear-full-time-sol. We can see that the stress in the polymer builds very quickly as it is exposed to the strength of the shear flow. Then, the stress plateaus down and settles into a steady state. This plateauing happens because the polymer chains start relaxing by reptation. The reptation happens so late due to the magnitude of $tau_d$ compared to $tau_R$. The system settles into a steady state when there is a balance between the stretching and relaxation in the polymer chains.\

\
We can confirm we have the correct solution because it matches the steady state solution found in @rolie-poly-shear-flow-section.

#figure(
  image("figures/Axy full time solution.png", width: 12cm), caption: [Plot of $A_(x y)$ across for all time and a plot of the steady state solution.],
) <shear-full-time-sol>\

#figure(
  image("figures/rolie-poly-betas-plot.png", width: 12cm), caption: [Plot of the stress for different CCR parameter values]
) <rolie-poly-betas-plot> \
\
We can also do some analysis on changing the CCR parameter. @rolie-poly-betas-plot shows three solutions of @rolie-poly-eq for three different values of $beta$. When $beta$ is small, the polymer takes longer to relax into steady state and the overshoot is larger. This is because there is less relaxation in the entanglements due to CCR and the relaxation agrees with a $tau_r$ timescale. Conversely, when $beta$ is large ($beta = 1$), the polymer gets into a steady state faster because the polymer chains relax faster due to more CCR.\
\
We can also plot the stretch in the polymer, as found in @rolie-poly-stretch-plot. Just as in the stress plot, we can see that the polymer stretches very quickly when it is first exposed to the shear flow. Then, the chains relax due to reptation after a short while (as the reptation time scale is longer). When the flow reaches steady state, we can see that $Lambda > 1$, so there is always some stretching of the polymers in the steady state, which isn't apparent from the stress plot. \
\
#figure(
  image("figures/rolie-poly-stretch-plot.png", width: 12cm), caption: [Plot of the stretch term across the rolie poly full time solution]
) <rolie-poly-stretch-plot> \
We can also plot a constitutive plot to see how the behaviour of the polymer stress changes as the strength of the shear is increased. @shear-flow-constitutive is a plot of the shear stress against increasing shear strengths for different values of $beta$. We can see that when there is high CCR $(beta =1)$, the shear stress is an increasing function of the shear strength. There is a slight decrease in the rate of stress growth where the polymer chains start relaxing. Conversely, when there is no CCR $(beta = 0)$, there are two turning points in the curve. The stress on the polymer chains decreases because of shear thinning. The polymers get stretched and since there is a lack of relaxation (from a lack of CCR), the melt gets less viscous and thus, needs less force to move. Then, when the chain starts relaxing due to reptation, they chains move more toward their equilibrium positions and more stress is needed to stretch them again.\
\

#figure(
  image("figures/RP-constitutive-curve.png", width: 12cm), caption: [Constitutive curve of $A_(x y)$ against $dot(gamma)$.],
) <shear-flow-constitutive>\
We can use this to further justify the results in @rolie-poly-betas-plot. The $beta = 0$ curve takes longer to get to steady state because there is no CCR relaxation stopping the melt from thinning. The melt has to recover from the shear thinning effect before it gets into steady state.\
\
When the polymer undergoes this shear thinning effect, the viscosity of the melt decreases, allowing the melt to flow easier. The viscosity in the polymer melt matches that of a Newtonian fluid until the shear rate reaches a critical value (as seen in Figure 12 and Figure 13). Then, the viscosity decreases which lets the fluid flow more easily. In the context of @shear-flow-constitutive, the viscosity starts decreasing when the shear stress decreases. 

#grid(
  columns: 2,
  align: (center, center),
  gutter: 8%,
    figure(image("figures/newtonian-viscosity.jpeg", width: 7cm), caption: [Newtonian fluid viscosity profile for increasing shear rates.], 
  ),
  figure(
    image("figures/polymer-melt-viscosity.jpeg", width: 7cm), caption: [Non-Newtonian viscosity profile for increasing shear rates.],
  ), 
)<viscosity-plots>


= Modelling a polydisperse polymer melt <multiple-polymer-modelling-section>

== Polydisperse polymers
The Rolie-Poly equation describes the dynamics of a mono-disperse polymer melt. That is, a melt that is composed of polymer chains with no difference in molecular weight. However, polymer melts that are used in industry are typically polydisperse - they are composed of chains with a distribution of molecular weights. @mono-bi-disperse-picture gives example molecular weight curves for two different polymer melts, a mono-disperse melt is shown by the dashed blue line.\
\
Polydispersity is measured through gel permeation chromatography (GPC). This process involves passing a polymer melt through another porous material and measuring the lengths of polymer chains by the time it takes to get through the pores. Calculations of the molecular weight are made from these measurements, namely the number average molecular weight $(M_n)$ and the weight average molecular weight $(M_w)$ which are defined as

$ M_n = frac(sum_i N_i M_i, sum_i M_i), #h(2cm) M_w = frac(sum_i N_i M_i^2, sum_i N_i M_i). $
 
Polydispersity is quantified by the polydispersity index. The dispersity of a polymer melt is defined by 

$ "PDI" = M_w/M_n . $

If a melt has a dispersity of 1 then it is mono-disperse and only contains chains of a single molecular weight. Table 1 shows some melts and their dispersity's.\
\
#figure(
align(center)[
#table(
  columns: (auto, auto, auto),
  inset: 10pt,
  align: horizon,
  table.header(
    [*Polymer melt*], [*Use*], [*Dispersity*],
  ),
  [Polystyrene standard],
  [Packaging],
  [1.0 - 1.5],

  [Polybutadiene (industrial)],
  [Rubber compounding],
  [3],
  
  [m-HDPE],
  [Industrial Resins],
  [12 - 42],

) <polydispersetable>
], caption: [Polymers with different polydispersities and their uses. Values found from @melt1, @melt2, @melt3.]
)
#figure(
  image("figures/mono-bidisperse-picture.jpeg"), caption: [Molecular weight curves showing a mono-disperse melt (left) and a bi disperse melt (right). ]
)<mono-bi-disperse-picture>\
\
Much like the CCR mechanism in the Rolie-Poly model, there is another constraint release mechanism, double reptation, that must be included when more than one chain size is considered. Double reptation describes the new interaction between two different sized chains relaxing. The long chains and short chains are constrained by entanglements by each other however, since the short chains have a shorter relaxation time, when one reptates and untangles, it gives it's neighbouring chains more room to move. This lets the long chains relax more easily so it is effectively a new relaxation method.
#figure(
  image("figures/short-long-in-tube.jpeg"), caption: [Diagram of slow reptation due to short and long chain entanglements in a tube (left) and faster reptation between unentangled chains (right).]
)<short-long-in-tube>
\
In this section, we will simplify polydisperse polymer melts to a bi-disperse melt and consider the Rolie-Double-Poly model - an extension of the Rolie-Poly model that captures the dynamics of a bi-disperse melt. After setting up the model (following @Boudara), we will introduce a shear flow and do some analysis on the effects of changing the composition of the melt. 

== Rolie-Double-Poly model
There will be a proportion of the polymer melt, $phi.alt_S$ that is made from short chains and a proportion, $phi.alt_L$ made from long chains. As this will be a bi-modal model, there is a simple relationship for the melt composition,

$ phi.alt_S = 1 - phi.alt_L. $

The polymer contribution to the stress tensor is now

#numbered_eq($bold(sigma) = G_e (phi.alt_S bold(A)_S +phi.alt_L bold(A)_L),$) <fullstress>

where $bold(A)_S, bold(A)_L$ are the deformation tensors for segments of short and long polymer chains. The long and short polymers will get entangled with each other, so they must exert a force on one another. For this reason, these deformation tensors take the forms

#numbered_eq($bold(A)_S = phi.alt_S bold(A)_(S S) +phi.alt_L bold(A)_(S L), \ bold(A)_L = phi.alt_L bold(A)_(L L) + phi.alt_S bold(A)_(L S).$) <as-al>

These equations can be thought of being split into two sections, the deformation from purely short (or long) chains and then the deformation caused by the long chains on the short (or vice versa). $bold(A)_(S S) "and" bold(A)_(L L)$ follow the single Rolie-Poly model (@rolie-poly-eq) and are defined as 

#numbered_eq($ nhat(bold(A)_(S S)) = 1/tau_(d,S) (bold(A)_(S S) - bold(I)) - frac(2(1-lambda_S^(-1)),tau_(r, S))(bold(A)_(S S) + beta lambda_S (bold(A)_(S S)-bold(I))), \ nhat(bold(A)_(L L)) = 1/tau_(d,L) (bold(A)_(L L) - bold(I)) - frac(2(1-lambda_L^(-1)),tau_(r, L))(bold(A)_(L L) + beta lambda_L (bold(A)_(L L)-bold(I))). $) <ass-all>

Here we have introduced the short hand

$ nhat(A) equiv frac(d bold(A), d t) - (nabla bold(u) dot bold(A) + bold(A) dot (nabla bold(u))^T). $

The other deformation terms are defined as

#numbered_eq($ nhat(bold(A)_(S L)) = frac(1, 2 tau_(d, S)) (bold(A)_(S L) - bold(I)) - frac(2(1-lambda_S), tau_(s, S)) bold(A)_(S L) - (bold(A)_(S L) - bold(I)) (frac(beta, 2 tau_(d, L)) + 2 beta_( C C R) frac(1-lambda_L, tau_(s, L))lambda_S) \ 

nhat(bold(A)_(L S)) = frac(1, 2 tau_(d, L)) (bold(A)_(L S) - bold(I)) - frac(2(1-lambda_L), tau_(s, L))bold(A)_(L S) - (bold(A)_(L S) - bold(I)) (frac(beta, 2 tau_(d, S)) + 2 beta_( C C R) frac(1-lambda_S, tau_(s, S))lambda_L).  $) <asl-als>

Similarly to the single mode Rolie-Poly, there is a stretching term,

$ lambda_i = sqrt(1/3 "tr"bold(A)_i) $ for $i = L,S.$ 
There is a second constraint release, $beta$, term that accounts for the thermal energy release from short chains that drives the double reptation effect.
In @Boudara, these equations include a term, $f_E (lambda)$, that encodes the extending dynamics of the polymer and it takes the form

$ f_E (lambda) = frac(1-lambda_("max"), 1-lambda^2 lambda_("max")). $

For simplicity of the model, we will assume that this is equal to 1. Physically this assumption means that the polymer will have infinite extensibility.\
\
We have used new relaxation times in these equations. $tau_s$ is a stretch relaxation time and scales like

$ tau_(s S) tilde M_s^2, "  " tau_(s L) tilde M_L^2, $

where $Z$ is the molecular weight of the short (long) polymer sections. There is also a reptation time, $tau_d$, which accounts which scales like

$ tau_(d S) tilde M^3_s, "  " tau_(d L) tilde M_L^3. $

== Shear flow
We will subject the two polymer melt model to a shear flow and study the effect that changing the composition of the melt (more short or more long) has on the stress profile. Our model states that the polymers in the melt should have the shortest relaxation time when $phi.alt_S = 1$ and the melt is comprised of only short chains. In contrast, we expect to see the relaxation time rapidly increase as the chains in the melt get longer and longer. From @as-al and @ass-all, in the case where the melt is only long or short, we should see the exact same curves as @rolie-poly-model-section.\
\
A plot of the $sigma_(x y)$ component of the stress tensor can be found in @bi-model-stress-plot and Figure 17. We can see that the time taken to get into steady state (and thus relaxation time) is longest when there are only long chains $(phi.alt_S = 0)$ in the melt and shortest when there are only short chains $(phi.alt_S=1)$.\
\
We can see that as the chains in the melt get longer, the amount of stress rapidly increases. The stress overshoot gets larger when the polymers chains are longer due to a longer relaxation time causing the stress-relaxation balance in the melt to occur at a later time. The rapid increase in the stress overshoot is also evidence of the double reptation effect we discussed earlier. More shorter chains speed up the reptation of the long chains.\
\
We can also notice that the $phi.alt_S = 1 "and " phi.alt_S = 0$ cases match the single mode Rolie-Poly model we used earlier. Figure 12 shows the full time stress solution for a long chain and short chain single mode model. These plots are the same and serves as an indicator that the dual polymer model is a good model. 

#figure(
  image("figures/two polymer shear stress.png", width: 16cm), caption: [The $A_(x y)$ component of the two polymer melt stress tensor in a shear flow, for increasing fractions of long chains.]
) <bi-model-stress-plot>

#grid(
  columns: 2,
  align: (center, center),
  gutter: 8%,
    figure(image("figures/two polymer shear stress loglog.png", width: 7cm), caption: [Logarithmic plot of the $A_(x y)$ component of the two polymer shear flow stress.], 
  ),
  figure(
    image("figures/long-short-chain-full-time.png", width: 7cm), caption: [Full time solution of the single mode Rolie-Poly equation for short and long polymer chains.],
  ), 
)<stressplots>

== Comparison to a monodisperse melt
We can plot the $A_(x y)^S "and" A_(x y)^L$ components of stress for a single melt composition to understand how the two chains behave individually. @50-50-composition shows the stress for a melt that is equal parts long and short chains $(phi.alt_S = phi.alt_L = 0.5)$.\
\
We can compare this stress to the long-short single mode solutions in Figure 16. The stress the short chains is higher in the 50-50 melt. This is because of entangling interactions (@asl-als) between the long and short chains; more stress is needed to untangle the short chains from the longer ones. Conversely, the stress in the long chains is lower in the 50-50 melt. The stress overshoot is also much lower in the 50-50 melt. This is more evidence of double reptation at work

#figure(
  image("figures/50-50 melt composition.png", width:12cm), caption: [Shear stress, $A_(x y)$ for a 50/50 long/short chain polymer melt]
)<50-50-composition>

= Viscous flow through a pipe <viscous-flow-through-a-pipe>
In this section we will discuss polymer flow in a pipe. We will first recall the well known flow profile for a Newtonian fluid, before subjecting the dumbbell and tube polymer models to a pipe flow.

== Newtonian Flows

=== Basic steady state flow <basic-steady-state-flow>
Consider a steady-state, axisymmetric, incompressible and viscous flow down a circular pipe due to a pressure gradient. \
\
For a flow profile $bold(u) = (0,0,w(r))$, the Navier-Stokes in cylindrical polars $(r , phi.alt , z)$ are given by 

#numbered_eq($0 = -1/rho (diff p)/(diff r), \ 0 = -1/rho (diff p)/(diff z) + mu/r diff/(diff r) (r (diff w)/(diff r) ) $)

The first equation states that $p$ is independent of $r$ but the second equation states that $diff p\/diff z$ is a function of r. The only way this can be true is if $diff p\/diff z$ is a constant, so we can set

$ p = p_0 - G z. $

Thus the problem to solve is simply the Navier-Stokes in the $z$ direction with

#numbered_eq($ 0 = G/mu + 1/r diff/(diff r) ( r (diff w)/(diff r)), $)

subject to the no slip condition

#numbered_eq($ w = 0 #h(0.2cm) "on" #h(0.2cm)r = a. $)

Integrating w.r.t $r$ twice gives 

$  (d w)/(d r) = -G/(2 mu) r + A/r arrow.r.double w = G/(4 mu) r^2 + A ln r + B. $

There are two constants. Letting $r arrow 0$ gives an infinite solution due to the logarithmic term, so we must set $A=0$. The second is found from the no-slip condition and gives

$ B = G/(4 mu) a^2. $

So the general solution is 

#numbered_eq($w = -G/(4mu) r^2 + G/(4mu) a^2 = G/(4mu)(a^2-r^2).$)

If we plot this solution, as seen in @steady_state_tube_flow_solution, we can see that the flow is a parabola centered at the middle of the cylinder with the flow slowing towards the sides and, of course, is stationary on the cylinder walls.

#figure(
  image("figures/Steady_state_tube_flow_solution.png"), caption: [
    Plot of a fluid flow through a cylinder with $G = 2 , a = 3 , mu = 0.5$. The blue line is the flow and the black are the walls of the cylinder. 
  ],
) <steady_state_tube_flow_solution>\

=== Full time solution <newtonian-full-time-section>

If the flow is not in steady state, the system becomes

#numbered_eq($0 = -1/rho (diff p)/(diff r), \ frac(diff w, diff t) = -1/rho (diff p)/(diff z) + mu/r diff/(diff r) (r (diff w)/(diff r) ). $)

subject to the same boundary conditions as before, as well as the initial condition

$ w(r,0) = 0. $

This sytem doesn't have an analytical solution, so we must solve it numerically. We use MATLABS 'pdepe' solver to solve this system, assuming a known pressure gradient. This is a parabolic and elliptical PDE solver that uses the numerical differential formulas @MATLABpdepe. 
The error is outlined in @pdepeerror as 

$ epsilon = O(d t^5). $

Similarly to the Runge-Kutta solver, this error gives us confidence that the solution we have is correct.

#figure(
  image("figures/newtonian-pipe-flow-velocity-profile.png"),
) <newtonian-pipe-flow-velocity-profile-plot>

@newtonian-pipe-flow-velocity-profile-plot shows the evolution of the pipe flow over time. We see how the parabolic solution emerges as the flow approaches steady state.

== Polymer Flows

As we have already seen in @stress-section, polymer flow differs from Newtonian fluid flows in one aspect: there is a contribution from the polymer in the stress tensor. For this reason, to set up the problem we must start from the general form of the momentum equation. We have 

#numbered_eq($ rho frac(D bold(u), D t) = nabla dot bold(sigma) .$)

Where $D/(D t) = (diff/(diff t) + bold(u) dot nabla)$ is the material derivative,

#numbered_eq($frac(diff bold(u), diff t) + (bold(u) dot nabla)bold(u) = nabla dot bold(sigma).$) <cauchy-momentum-eq>

Now, the stress tensor takes the form of @non-newt-stress-tensor,

#numbered_eq($bold(sigma) = p bold(I) + 2mu (nabla bold(u) + (nabla bold(u))^T) + G(bold(A)-bold(I)).$)

Substituting into @cauchy-momentum-eq gives,

#numbered_eq($ frac(diff bold(u), diff t) + (bold(u) dot nabla)bold(u) = gradient p + 2mu gradient^2 bold(u) + G(nabla dot bold(A)) $) <43>

Again, we are dealing with pipe flow so the flow profile takes the form $bold(u) = (0, 0, w(r))$ which gives the gradient velocity tensor 

#numbered_eq($ nabla u = mat( 0,0,0; 0,0,0; frac(diff w, diff r),0,0).$)

Substituting this into @43 and breaking down into components gives the following system of equations

#numbered_eq($frac(diff p, diff r) + G (frac(diff A_(r r), diff r) + 1/r frac(diff A_(phi.alt r), diff phi.alt)+frac(diff A_(z r), diff z) + 1/r (A_(r r) - A_(phi.alt phi.alt))) = 0 \ 1/r frac(diff p, diff phi.alt) + G( frac(diff A_(r phi.alt), diff r) + 1/r frac(diff A_(phi.alt phi.alt), diff phi.alt) + frac(diff A_(z phi.alt),diff z) + 1/r (A_(r phi.alt) - A_(phi.alt r))) = 0 \ frac(diff p, diff z) + 2mu (frac(diff^2 w, diff r^2) + 1/r frac(diff w, diff r)) + G(frac(diff A_(r z), diff r)+ 1/r frac(diff A_(phi.alt z), diff phi.alt) + frac(diff A_(z z), diff z) + A_(r z)/r) = frac(diff w, diff t).$)

These can be simplified greatly by assumption of the flow profile $(frac(diff, diff phi.alt ) = frac(diff, diff z) = 0)$,

#numbered_eq($ frac(diff p, diff r) + G( frac(diff A_(r r), diff r) + 1/r (A_(r r) - A_(phi.alt phi.alt))) = 0 \ 1/r frac(diff p, diff phi.alt) + G(frac(diff A_(r phi.alt), diff r) + 1/r (A_(r phi.alt )-A_(phi.alt r))) = 0 \ frac(diff p, diff z) + 2mu (frac(diff^2 w, diff r^2) + 1/r frac(diff w, diff r))+ G(frac(diff A_(r z), diff r) +A_(r z)/r) = frac(diff w, diff t). $)


As there is no flow in the $r "or" phi.alt$ direction, we only need to consider the $z$ equation. Thus, the system we are to solve is

#numbered_eq($frac(diff p, diff z) + 2mu (frac(diff^2 w, diff r^2) + 1/r frac(diff w, diff r))+ G(frac(diff A_(r z), diff r) +A_(r z)/r) = frac(diff w, diff t), $) <polymer-flow-eq>

coupled with a deformation equation in $bold(A)$, and subject to the boundary conditions:

$ w = 0 #h(0.2cm) "on" #h(0.2cm)r = R #h(0.2cm) "and" #h(0.2cm) frac(diff w, diff r) = 0 #h(0.2cm) "on" #h(0.2cm) r = 0 $

as well as the initial conditions:

$ bold(A) (t=0) = bold(I) #h(0.2cm) "and" #h(0.2cm) w(t=0) = 0 $

=== Dumbbell model in pipe 
Let us subject the dumbbell model (@dumbbell-model-section) to the pipe flow we have derived. Substituting the gradient velocity into @dumbbell-dynamics-eq gives

#numbered_eq($frac(d bold(A), d t) = mat(frac(diff w, diff r)A_(z r), frac(diff w, diff r)A_(z phi.alt), frac(diff w, diff r)A_(z z); 0,0,0; 0,0,0) + mat(frac(diff w, diff r)A_(z r),0,0; frac(diff w, diff r)A_(phi.alt z),0,0; frac(diff w, diff r)A_(z z),0,0)  \ - 1/tau mat(A_(r r) -1, A_(r phi.alt), A_(r z); A_(phi.alt r), A_(phi.alt phi.alt)-1, A_(phi.alt z); A_(z r), A_(z phi.alt), A_(z z)-1)$) <dumbell-in-pipe-eq>

subject to the initial condition $bold(A)(t=0) = bold(I)$. Similarly to @dumbbell-dynamics-eq, the solutions to the components follow similar methods so we will only work through the $A_(r z)$ component explicitly and then state the full solution. We have

#numbered_eq($frac(d A_(r z),d t) = frac(diff w, diff r) - 1/tau A_(r z), #h(1cm) A_(r z) (0) = 0$) 

Rearranging and introducing the integrating factor of $e^(t\/tau)$ yields

#numbered_eq($frac(d,d t) (e^(t\/tau) A_(r z)) = frac(diff w, diff r)e^(t\/tau) \ arrow.double A_(r z) = frac(diff w, diff r) tau + c e^(-t\/tau)$)

Then imposing the initial condition gives

$ c = -frac(diff w, diff r) tau, $

#numbered_eq($arrow.double A_(r z) = frac(diff w, diff r) tau - frac(diff w, diff r) tau e^(-t\/tau).$)

The full solution of @dumbell-in-pipe-eq is 

#numbered_eq($bold(A) = mat(A_(r r), 0, A_(r z); 0,1,0; A_(r z), 0, 1)$)

with $ A_(r r) = 1+2(frac(diff w, diff r))^2 tau^2 (1-e^(-t\/tau)) - 2(frac(diff w, diff r))^2 tau t e^(-t\/tau), \ A_(r z) = A_(z r) = frac(diff w, diff r) tau (1-e^(-t\/tau)). $

We can now substitute into the flow equation (@polymer-flow-eq):

#numbered_eq($frac(diff w, diff t) = frac(diff p, diff z) + 2mu (frac(diff^2 w, diff r^2) + 1/r frac(diff w, diff r))+ G(frac(diff^2 w, diff r^2) + 1/r frac(diff w, diff r))tau(1-e^(-t\/tau)).$)

This is now an equation in $w$, and we can solve it numerically using the same method as in @newtonian-full-time-section. A plot of the results can be found in @dumbbell-model-in-pipe-velocity.\
\
#figure(
  image("figures/dumbell-in-pipe-flow.png"), caption: [dumbbell model in pipe flow with $mu=0.01, tau_d = 0.01, G=2, d p\/d z = 50.$ ]
) <dumbbell-model-in-pipe-velocity> \
@dumbbell-model-in-pipe-velocity shows how the flow of the dumbbell evolves over time. We can see that the flow reaches steady state faster than the Newtonian fluid, reaching steady state at around $t=2.5$.

=== Tube model in pipe flow
Now we will use subject the full Rolie-Poly model to a pipe flow. The system to solve is as follows:

#numbered_eq($frac(diff w, diff t) = frac(diff p, diff z) + 2mu (frac(diff^2 w, diff r^2) + 1/r frac(diff w, diff r))+ G(frac(diff A_(r z), diff r) +A_(r z)/r)$) <tube-model-mom-eq>

coupled with the $A_(r z)$ component of the Rolie-Poly equation,

#numbered_eq($frac(d A_(r z), d t) = frac(diff w, diff r)A_(r r) - A_(r z)/tau_d - 2/tau_r (1-sqrt(3/("tr"bold(A)))) (A_(r z)-beta A_(r z) sqrt(3/("tr"bold(A)))).$)

Unfortunately, unlike in the dumbbell flow, we cannot make much analytical progress in simplifying the system so we must solve this along with the equations for $A_(r r), A_(phi.alt phi.alt) "and" A_(z z)$:

#numbered_eq($frac(d A_(r r), d t) = -1/tau_d (A_(r r) - 1) - 2/tau_r (1-sqrt(3/("tr"bold(A)))) (A_(r r)-beta sqrt(3/("tr"bold(A)))(A_(r r)-1)),$)

#numbered_eq($frac(d A_(phi.alt phi.alt), d t) = -1/tau_d (A_(phi.alt phi.alt) - 1) - 2/tau_r (1-sqrt(3/("tr"bold(A))) )(A_(phi.alt phi.alt)-beta sqrt(3/("tr"bold(A)))(A_(phi.alt phi.alt) -1)),$)

#numbered_eq($frac(d A_(z z), d t) = 2 frac(diff w, diff r) A_(r z) -1/tau_d (A_(phi.alt phi.alt) - 1) - 2/tau_r (1-sqrt(3/("tr"bold(A))) )(A_(phi.alt phi.alt)-beta A_(phi.alt phi.alt) sqrt(3/("tr"bold(A)))).$)

Subject to the same boundary and initial conditions as before, $ bold(A)(0) = bold(I), " " w(r,0) = w(0,t) = frac(diff w(R,t), diff t) = 0. $

We will, again, solve this system using MATLAB's pdepe function but in order to do so we need to rearrange it into a form the solver can use. @tube-model-mom-eq is the only equation we have to change and it must take the form 

$ frac(diff w, diff t) = 1/r diff/(diff r) (2mu frac(diff w, diff r) + G A_(r z)) + frac(diff p, diff z). $


The solution can be found in @dumbbell-model-in-pipe-velocity. We can see an immediate different in the flow profile for the full Rolie-Poly flow compared to the dumbbell flow; the flow is blunt towards the centre of the pipe. Physically this represents a block of fluid in the middle of the pipe that flows together as a block, compared to a Newtonian fluid that has a velocity peak at $r=0$. We can also see that the fluid flows a lot faster than the Newtonian fluid, although this could be due to the values used when solving the equations. This block appears because of shear thinning within the melt.\
\
@A_rz-stress-polymer-pipe-flow shows the stress in the melt across the pipe. We can see that the stress gets stronger towards the walls of the pipe. At first glance the stress in the melt might not match the blunted velocity profile. However, upon close inspection the stress profile sharpens at around $r= plus.minus 0.1$.\
\
To see the effect of this change in the melt, we plot the stretch term $Lambda = sqrt(3\/"tr"bold(A))$, as seen in @stretch-term-polymer-pipe-flow. From this, we can see that the chains start getting stretched just before $r=plus.minus 0.1$ and get stretched more towards the walls of the pipe. Just as in the shear flow, when the polymer chains in the melt get stretched they are able to flow past each other more freely. This is the shear thinning effect we have already discussed.

#figure(
  image("figures/polymer-pipe-flow-velocity.png"), caption: [Solution for the full Rolie-Poly pipe flow with ...]
) <polymer-pipe-flow-velocity-plot>



#figure(
  image("figures/A_rz-stress-polymer-pipe-flow.png"), caption: [$A_(r z)$ component of the deformation tensor for the full Rolie-Poly pipe flow.]
) <A_rz-stress-polymer-pipe-flow>



#figure(
  image("figures/polymer-pipe-flow-stretch.png"), caption: [Stretch term $Lambda = sqrt(("tr"bold(A))\/3)$ for full Rolie-Poly pipe flow]
) <stretch-term-polymer-pipe-flow>\


= Conclusion
In conclusion, we have introduced various aspects of polymer modelling. We have briefly studied how modelling polymer chains geometrically can be used to derive equations of deformation for simple models like the dumbbell model. Furthermore, we have then seen the effects that different flows have on the deformation. Shear flows deformed the dumbbell to match the diagonal profile for a shear flow.\
\
We have seen how to model chain entanglements in the tube model and by extending the tube theory to include extra relaxation mechanisms, we have seen how a shear flow causes deformation in entangled polymer chains. In particular, we have observed the stress overshoot effect that happens before the chains start relaxing. Importantly, we have seen how these shear polymer flows become steady when a stress/relaxation balance has been met. We observed the shear thinning effect that occurs when there is no relaxation from CCR in the model.\
\
We extended the tube model theory further to a bi-disperse polymer melt and saw what the stress profile was like. Moreover, the stress profile in the long chains did not overshoot as much if there were more short chains in the melt composition.\
\
Finally, we subjected both models to a pipe flow and compared the velocity profiles to that of a Newtonian fluid. The dumbbell model matched the Newtonian velocity profile but interestingly, We found that the Rolie-Poly model still had a shear thinning effect towards the walls of a pipe that caused a block of the melt to move together through the centre of the pipe. \
\
Further work could include trying to model a full polydisperse polymer melt, instead a mono/bi disperse melt. Similarly, we could subject the bi-disperse model we have studied to a pipe flow and see the effects of changing the melt composition. Another avenue for further work is to introduce a temperature gradient into a flow. In this case, the viscocity is dependent on the temperature of the melt @temperaturearticle. We could also investigate what happens if a melt is placed into a rotationally dominated flow.



= Appendix
#include "code.typ"

#bibliography("3Dpolymerref.bib")
