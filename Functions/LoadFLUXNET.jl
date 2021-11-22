using DataFrames, CSV, Dates

function getID()
	# get the path of folder files
	folders = readdir(joinpath("Input", "FLUXNET"), join = true);
	deleteat!(folders,1); # first folder is different
	n = length(folders);
	# retrieve a short ID for each site
	ID = []
	[push!(ID, folders[i][19:24]) for i = 1:n];
	return ID
end
ID = getID();

function loadFLUXNET(site)
	# get the path of folder files
	folders = readdir(joinpath("Input", "FLUXNET"), join = true);
	deleteat!(folders,1); # first folder is different
	n = length(folders);

	# get the path of input files
	paths = Dict(ID .=> [readdir(folders[i], join = true)[9] for i in 1:n]);

	# load data corresponding to ID
	data = DataFrame(CSV.File(paths[site];
	dateformat="yyyymmddHHMM",
	types = Dict([:TIMESTAMP_START, :TIMESTAMP_END] .=> DateTime),
	missingstring="-9999"));
	return data
end
# e.g., data_AR_SLu = loadFLUXNET(ID[1])
# e.g., data_AU_Cum = loadFLUXNET("AU-Cum")


#= 
Notes:
https://www.nature.com/articles/s41597-020-0534-3.pdf
SWC is soil moisture (depth unknown)
TS is soil temperature (depth unknown)
NIGHT column is nighttime (1) or daytime (0)
I want: nighttime NEE measured (not gap-filled), qc'ed, turbulent + storage
same for SWC and TS, I want not gap-filled if possible
e.g., FLX_AT-Neu_FLUXNET2015_FULLSET_HH_2002-2012_1-4.csv
start with NEE_CUT_REF, with NEE_CUT_REF_QC = 1, NIGHT = 1 ? change later if needed
SWC_F_MDS_1 for SWC, SWC_F_MDS_1_QC = 0, NIGHT = 1 ?
TS_F_MDS_1 for TS, TS_F_MDS_1_QC = 0, NIGHT = 1 ? 
=#
