using Statistics
include(joinpath("Functions", "filterCOSORE.jl"));
include(joinpath("Functions", "DAMMfit.jl"));

# DAMM plots for COSORE shallowest Tsoil and SWC
poro_val = 0.5
params = [1, 1, 1]
for i in Names # for each COSORE dataset
	println("Working on ", i, "...")
	if isempty(df[i][1]) == false
		if (isempty(Ts_shallowest_name[i]) == true || isempty(SWC_shallowest_name[i]) == true) == false
			Resp = df[i][1].CSR_FLUX_CO2
			Ind_var = hcat(df[i][1][!, Ts_shallowest_name[i][1]], df[i][1][!, SWC_shallowest_name[i][1]])
			poro_val = maximum(df[i][1][!, SWC_shallowest_name[i][1]])
			params = fitDAMM(Ind_var, Resp)
			include(joinpath("Functions", "3Dplot.jl"));
			fig = plot3D(Ind_var, Resp)
			name = string(i, ".png")	
			save(joinpath("Output", "COSORE_DAMM", name), fig)
		end
	end
end

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

