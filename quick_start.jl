using ODINN

working_dir = joinpath(ODINN.root_dir, "demos")
mkpath(working_dir)

rgi_ids = ["RGI60-11.03638"]
rgi_paths = get_rgi_paths()

params = Parameters(
    simulation = SimulationParameters(
    working_dir = working_dir,
    tspan = (2010.0, 2015.0),
    multiprocessing = false,
    rgi_paths = rgi_paths
)
)

model = Model(
    iceflow = SIA2Dmodel(params),
    mass_balance = TImodel1(params; DDF = 6.0 / 1000.0, prcp_fac = 1.2)
)

glaciers = initialize_glaciers(rgi_ids, params)
prediction = Prediction(model, glaciers, params)
run!(prediction)