# Quarter Five Spot 3D


Reservoir simulation is the use of numerical methods on a geological model and petrophysical properties of the reservoir, the fluid system and the production equipment to predict how fluids flow through the reservoir to the well, and the production equipment.

The simulation model consists of three main parts:
	The flow model is the set of equations describing the flow of fluids in a porous medium 
	The geological model: realized in the form of a 3D grid populated with petrophysical data that acts as input to the flow model.
	The well model provides pressure and fluid communication between the reservoir and the surface.
 
The incompressible Immiscible Two-phase Flow model can be written in  the fractional flow formulation:
One elliptic pressure equation

-∇([λ_n+λ_w ]K∇p_n )=q- ∇[λ_w ∇p_c+(λ_n ρ_n+λ_w ρ_w )g∇z]

Another parabolic, with hyperbolic character, saturation equation

ϕ (∂S_w)/∂t+∇[f_w v ⃗+f_w λ_n KΔρ∇z]=q_w-∇(f_w λ_n KP_c^' ∇S_w)

Darcy equation

v ⃗=-[λ_n+λ_w ]∇p_n+ λ_w ∇p_c+(λ_n ρ_n+λ_w ρ_w )g∇z


I simulated a uniform 40*40*15 grid with dimensions 700*700*100 m for 25 years of injection/production. the petrophysical data are sampled from the topmost layer of the SPE10 dataset.

This is an example of a Quarter Five Spot Pattern of water Flooding with two wells, an injector, and a producer, at diagonally opposite corners of the reservoir region. The wells operate at a fixed rate corresponding to the injection of one pore volume over a period of 23 years, 0.0119m3/s or 6490 STB/day. The pore volume is equal to 9.423 MMm3, or 59.269 MMSTB. To reach the final time I used 250 pressure steps and the implicit transport solver. The fluid is assumed to obey a simple Corey fluid model with quadratic relative permeabilities and no residual saturations. The water density is 1014 kg/m3 and the oil density is 700 kg/m3. The water viscosity is 2.5 cp and the oil viscosity is 1 cp.  
Water breakthrough occurs after almost 9.7 years. The oil production drops after which due and a substantial amount of water is produced.
We see that the water flows faster in some layers than the others as a result of the heterogeneity and in some preferred directions due to anisotropy. This causes viscous fingering and some regions in the reservoir aren’t swept before water breakthrough.

I attached some Visualizations of the results. The code will be available on my GitHub account.

It’s a simplified example, not representative of the real world, but it helps understand the concepts in reservoir simulation and visualize the flow in a porous medium.

3D Visualization
<img src="https://github.com/Mahmoud899/QuarterFiveSpot3D/blob/master/Flood.gif" width="400" height="350" /> <img/>

<img src="https://github.com/Mahmoud899/TensorFlow-Advanced-Techniques-Specialization/blob/main/MOOC%203%20-%20Advanced%20Computer%20Vision%20with%20TensorFlow/week%202%20-%20Object%20Detection/duckies_test.gif" width="400" height="350" /> <img src="https://github.com/Mahmoud899/TensorFlow-Advanced-Techniques-Specialization/blob/main/MOOC%203%20-%20Advanced%20Computer%20Vision%20with%20TensorFlow/week%202%20-%20Object%20Detection/zombie-anim.gif" width="400" height="350" />
