using Statistics
include("LoadCOSORE.jl");
include("DAMMfit.jl");

n = length(Names)
poro_val = 0.5
params = [1, 1, 1]
for i = 1:n
	println("Working on dataset ", i, ", ", Names[i], "...")
	df = Data[Names[i]][1]
	coln = names(df)
	Ts_names = names(df, r"CSR_T[0-9]")
	if isempty(Ts_names)
		println("Skipping dataset ", i, ", ", Names[i], ". No soil temperature.")
		continue # go to next i
	end
	Ts_depth = [Ts_names[i][6:end] for i = 1:length(Ts_names)]
	Ts_depth = parse.(Float64, Ts_depth)
	SWC_names = names(df, r"CSR_SM[0-9]")
	if isempty(SWC_names)
		println("Skipping dataset ", i, ", ", Names[i], ". No soil moisture.")
		continue # go to next i
	end
	SWC_depth = [SWC_names[i][7:end] for i = 1:length(SWC_names)]
	SWC_depth = parse.(Float64, SWC_depth)
	Ts_shallowest = findall(x -> x == minimum(Ts_depth), Ts_depth)
	Ts_shallowest_name = Ts_names[Ts_shallowest]
	SWC_shallowest = findall(x -> x == minimum(SWC_depth), SWC_depth)
	SWC_shallowest_name = SWC_names[SWC_shallowest]
	dropmissing!(df, ["CSR_FLUX_CO2", Ts_shallowest_name[1], SWC_shallowest_name[1]])
	if isempty(df)
		println("Skipping dataset ", i, ", ", Names[i], ". Empty driver columns.") 
		continue
	end
	if median(df[!, SWC_shallowest_name[1]]) > 1 # some SWC are in % instead of m3 m-3
		println("SWC in % detected. Converting to m3 m-3.")
		df[!, SWC_shallowest_name[1]] = df[!, SWC_shallowest_name[1]]./100
	end
	Resp = df.CSR_FLUX_CO2
	Ind_var = hcat(df[!, Ts_shallowest_name[1]], df[!, SWC_shallowest_name[1]])
	poro_val = maximum(df[!, SWC_shallowest_name[1]])
	params = fitDAMM(Ind_var, Resp)
	include("3Dplot.jl");
	fig = plot3D(Ind_var, Resp)
	name = string(Names[i], ".png")	
	save(joinpath("Output", "COSORE_DAMM", name), fig)
	println("Success!")
end

# Some soil moisture are in %, need to convert them to m3 m-3

