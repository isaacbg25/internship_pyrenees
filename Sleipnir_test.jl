using Sleipnir
using Sleipnir: Parameters

# Construct simulation parameters (multiprocessing disabled for local runs)
params = Parameters(
    simulation = SimulationParameters(
        tspan = (2010.0, 2015.0),
        multiprocessing = false,
        use_MB = true,
        rgi_paths = get_rgi_paths(),#faltava això per localitzar el fitxer amb les dades 
        use_velocities = false, #si no hi ha velocitats al fitxer fridded_data.nc
    ),
    physical = PhysicalParameters()
)

# Load pre-initialized glaciers (requires preprocessed data in ~/.ODINN/)
glaciers = initialize_glaciers(["RGI60-11.03208"], params)# aneto: RGI60-11.03208

glacier = glaciers[1]
@show glacier.rgi_id, glacier.nx, glacier.ny
@show size(glacier.H₀)   # initial ice thickness grid
@show size(glacier.S)    # surface elevation grid
@show size(glacier.B)
#fer mapa color:
cm = Sleipnir.CairoMakie

fig = cm.Figure(size = (1000, 420))

ax1 = cm.Axis(fig[1, 1], title = "Gruix inicial del gel (H₀)", xlabel = "x", ylabel = "y")
hm1 = cm.heatmap!(ax1, glacier.H₀)
cm.Colorbar(fig[1, 2], hm1, label = "Gruix")

ax2 = cm.Axis(fig[1, 3], title = "Surface elvevation (S)", xlabel = "x", ylabel = "y")
hm2 = cm.heatmap!(ax2, glacier.S)
cm.Colorbar(fig[1, 4], hm2, label = "elevacio")

display(fig)
cm.save("Aneto_H0_S.png", fig)

fig =cm.Figure(size=(500,500))
ax = cm.Axis(fig[1,1], title= "Bedrock Elevation (B)", xlabel ="x", ylabel="y", aspect=cm.DataAspect())
hm=cm.heatmap!(ax,glacier.B)
cm.Colorbar(fig[1,2], hm, label="alçada Bedrock")
#display(fig)