using ODINN

# Define the working directory
working_dir = joinpath(ODINN.root_dir, "demos")

# Ensure the working directory exists
mkpath(working_dir)

# Define which glacier RGI IDs we want to work with
rgi_ids = ["RGI60-11.03208", "RGI60-11.03232"] #mont perdut: "RGI60-11.03222", "RGI60-11.03221"
rgi_paths = get_rgi_paths()#conté diccionari de path amb el RGI ID associat per tots els glaciars considerats

# Create the necessary parameters
params = Parameters(
    simulation = SimulationParameters(
    working_dir = working_dir,
    tspan = (2010.0, 2015.0),
    multiprocessing = false,
    #workers = 4,
    rgi_paths = rgi_paths,
    use_velocities=false
)
)

# Specify a model based on an iceflow model, a mass balance model,
# and a machine learning model
model = Model(
    iceflow = SIA2Dmodel(params),
    mass_balance = TImodel1(params; DDF = 6.0 / 1000.0, prcp_fac = 1.2)
)

# We initialize the glaciers with all the necessary data
glaciers = initialize_glaciers(rgi_ids, params)

# We specify the type of simulation we want to perform
prediction = Prediction(model, glaciers, params)

# And finally, we just run the simulation
run!(prediction)

# Then we can visualize the results of the simulation, e.g. the difference in ice thickness
# between 2010 to 2015 for Argentière glacier
output_dir="/home/ish/Documents/UNI/4rt/internship_IGE/internship_pyrenees/docu_tests/plots"
for i in 1:length(rgi_ids)
    fig=plot_glacier(prediction.results[i], "evolution difference", [:H]; metrics = ["difference"])

    ODINN.CairoMakie.save(joinpath(output_dir,"evolution_difference_$i.png"),fig)

    fig=plot_glacier(prediction.results[i],"heatmaps",[:V])
    ODINN.CairoMakie.save(joinpath(output_dir,"surface_velocity$i.png"),fig)
end
