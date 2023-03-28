using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function predictor(u, c) # FTFS Method
    v = copy(u)
    v[1:end-1] .= u[1:end-1] .- c .* (u[2:end] .- u[1:end-1])
    v[end] = u[end] - c * (u[1] - u[end])
    return v
end

function corrector(u, u_prev, c)    # BTBS Method
    v = copy(u)
    v[1] = ((u_prev[1] + u[1]) / 2) - (c / 2) * (u[1] - u[end])
    v[2:end] .= ((u_prev[2:end] .+ u[2:end]) ./ 2) .- (c / 2) .* (u[2:end] .- u[1:end-1])
    return v
end

function MacCormack(u, c)
    u_prev = copy(u)
    u_predicted = predictor(u, c)
    u_corrected = corrector(u_predicted, u_prev, c)
    return u_corrected
end

# Define the grid parameters
L = 10.0   # Length of the domain in the x direction 
Δx = 0.01  # Grid spacing in the x direction 
Nx = Int(L / Δx)   # Number of grid points in the x direction
c = 0.5   # Courant Numbers

# Define the physical parameters
α = 2   # Speed of Propagataion

# Define the simulation parameters
sim_time = 4   # Total simulation time 
Δt = round(c * Δx / α, digits=4)  # time step size 
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
u = exp.(-4 .* (x_values .- 5) .^ 2)
# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="MacCormack", legend=:topleft, grid=true)
plot!(x_values, u, label="Initial Condition")
# Run the simulation
for j in 1:num_time_step
    global u = MacCormack(u, c)
end

# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")
# Define the simulation parameters
sim_time_2 = 6   # Total simulation time 
num_time_step_2 = round(sim_time_2 / Δt)   # Number of time steps

# Run the simulation
for j in 1:num_time_step_2
    global u = MacCormack(u,c)
end

# Numerical
plot!(x_values, u, label="After $(sim_time+sim_time_2) seconds (numerically)")