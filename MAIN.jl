# TO DO 
# Figures and parameters for FLUXNET
# Interactive figure COSORE on HOT TEA

using Statistics

# 1. Load COSORE 82 datasets and 2. subset the data we want, mapped to site name
include(joinpath("Functions", "filterCOSORE.jl"));
# e.g., Names[1] is the name of the first dataset
# e.g., df[Names[1]][1] gives the DataFrame of the dataset
# e.g., Ts_shallowest_name[Names[1]][1] gives the column name of the shallowest Ts 

# Load DAMM model
include(joinpath("Functions", "DAMMfit.jl"));
# Gives a soil respiration value as a function of soil temperature and moisture
# Has 3 parameters: temperature sensitivity, moisture limitation, oxygen limitation

# DAMM plots for COSORE shallowest Tsoil and SWC
poro_val = 0.5
params = [1.0, 1.0, 1.0]
poro_vals = Dict(Names .=> [0.5 for i in 1:n]) 
params_x = Dict(Names .=> [[1.0, 1.0, 1.0] for i in 1:n])
using GLMakie
fig = Dict(Names .=> [Figure() for i in 1:n])
for i in Names # for each COSORE dataset
	println("Working on ", i, "...")
	if isempty(df[i][1]) == false
		if (isempty(Ts_shallowest_name[i]) == true || isempty(SWC_shallowest_name[i]) == true) == false
			Resp = df[i][1].CSR_FLUX_CO2
			Ind_var = hcat(df[i][1][!, Ts_shallowest_name[i][1]], df[i][1][!, SWC_shallowest_name[i][1]])
			poro_vals[i] = maximum(df[i][1][!, SWC_shallowest_name[i][1]]) # set porosity to max SWC
			poro_val = poro_vals[i]
			params_x[i] = fitDAMM(Ind_var, Resp) # fit DAMM to data, get parameters
			params = params_x[i]
			include(joinpath("Functions", "3Dplot.jl"));

			fig[i] = plot3D(Ind_var, Resp)
			# should this just save plot/axis? (not fig), so that slider work... to test

			#fig = plot3D(Ind_var, Resp)
			#name = string(i, ".png")	
			#save(joinpath("Output", "COSORE_DAMM", name), fig)
		end
	end
end

# Save DataFrame with COSORE DAMM params
df_desc = DataFrame(CSV.File(joinpath("Input", "COSORE", "description.csv"))) # contains IGBP
#df_desc.names = [df_desc.CSR_DATASET[i][11:end] for i = 1:size(df_desc)[1]]
datanames = [inputs[i][28:end-4] for i = 1:n]
IGBP = Dict(Names .=> ["NA" for i in 1:n])
for i = 1:n
	println(i)
	this = findfirst(x -> x == datanames[i], df_desc.CSR_DATASET)
	if isnothing(this) == false
		IGBP[Names[i]] = df_desc.CSR_IGBP[this]
	end
end

df_p = DataFrame("Site_Name" => [Names[i] for i = 1:n],
		 "IGBP" => [IGBP[i] for i in Names],
		 "Porosity" => [poro_vals[i] for i in Names],
		 "a" => [params_x[i][1] for i in Names],
		"kMsx" => [params_x[i][2] for i in Names],
		"kMo2" => [params_x[i][3] for i in Names])

CSV.write(joinpath("Output", "COSORE_DAMMparams.csv"), df_p)

# Timeseries for COSORE shallowest Tsoil and SWC
include(joinpath("Functions", "TimeSeries.jl"))
counts = 0
for i in Names
counts += 1
println("Working on dataset #", counts, "/", n, ", ", i, "...")
	if isempty(df[i][1]) == false
		if (isempty(Ts_shallowest_name[i]) == true || isempty(SWC_shallowest_name[i]) == true) == false
			fig = timeserie(df[i][1][!, "CSR_TIMESTAMP_BEGIN"],
				  df[i][1][!, "CSR_FLUX_CO2"],
				  df[i][1][!, Ts_shallowest_name[i][1]],
				  df[i][1][!, SWC_shallowest_name[i][1]])
			name = string(i, ".png")	
			save(joinpath("Output", "COSORE_timeseries", name), fig)

		end
	end
end

