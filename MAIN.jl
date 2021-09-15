include("LoadCOSORE.jl");

# to do: filter out DataFrames that don't have soil moisture or soil temperature
# when they do, need to get column name automatically, most shallow surface?

include("DAMMfit.jl");

i = 5;
df = Data[Names[i]][1]
names(df)
dropmissing!(df, [:CSR_FLUX_CO2, :CSR_T7, :CSR_SM5])
Resp = df.CSR_FLUX_CO2
Ind_var = hcat(df.CSR_T7, df.CSR_SM5)
poro_val = maximum(df.CSR_SM5)
params = fitDAMM(Ind_var, Resp)

include("3Dplot.jl");
plot3D(Ind_var, Resp)


# to do, write separate function to load 1. COSORE, 2. FLUXNET
# this script will just 1. fit DAMM and 2. plot (current lines 44-56)


