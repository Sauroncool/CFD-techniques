using Plots
plotly(ticks=:native) # Allow to zoom and will adjust the grid

function SOUPW(u, c)
    n = length(u)
    v = similar(u)
    for i = 1:n
        in1 = mod1(i - 1, n)    # index of i-1 with periodic boundary
        in2 = mod1(i - 2, n)    # index of i-2 with periodic boundary
        v[i] = u[i] - (c / 2) * (3*u[i] - 4*u[in1] + u[in2])
    end
    return v
end

# Define the grid parameters
L = 10.0   # Length of the domain in the x direction (m)
Δx = 0.01  # Grid spacing in the x direction (m)
Nx = Int(L / Δx)   # Number of grid points in the x direction
c = 0.5   # Courant Numbers
# works for c<=0.2

# Define the physical parameters
α = 2   # Speed of Propagation

# Define the simulation parameters
sim_time = 4   # Total simulation time (s)
Δt = round(c * Δx / α, digits=4)  # time step size (s)
num_time_step = round(sim_time / Δt)   # Number of time steps

# Define the initial condition
x_values = range(0, stop=L, length=Nx)
# u = exp.(-4 .* (x_values .- 5) .^ 2)
# u = exp.(-30 .* (x_values .- 2) .^ 2) + exp.(-(x_values .- 5) .^ 2)
# u = zeros(Nx)
# u[1 .<= x_values .<= 2] = x_values[1 .<= x_values .<= 2] .- 1
# u[2 .<= x_values .<= 3] = 3 .- x_values[2 .<= x_values .<= 3]
u = ones(Nx)
u[x_values .<= 5] .= 2

# Plot the initial condition
plot(xlabel="x", ylabel="Amplitude", title="Second Order Upwind", legend=:outertopleft, grid=true)
plot!(x_values, u, label="Initial Condition")

# Run the simulation
for j in 1:num_time_step
    global u = SOUPW(u, c)
end

# Numerical
plot!(x_values, u, label="After $(sim_time) seconds (numerically)")

# Define the simulation parameters
sim_time_2 = 6   # Total simulation time (s)
num_time_step_2 = round(sim_time_2 / Δt)   # Number of time steps

# Run the simulation
for j in 1:num_time_step_2
    global u = SOUPW(u, c)
end

# Numerical
plot!(x_values, u, label="After $(sim_time+sim_time_2) seconds (numerically)")

# # Run the simulation
# for j in 1:20
#     global u = SOUPW(u,c)
# end

# # Numerical
# plot!(x_values, u, label="After 20 time steps (numerically)")
# png("4_Second Order Upwind")