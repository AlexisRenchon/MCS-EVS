include(joinpath("Functions", "LoadFLUXNET.jl")) # e.g., loadFLUXNET("US-SLu")
ID = getID()[1]; # ID for FLUXNET sites
include(joinpath("Functions", "FLUXNET_plot.jl")) # plot light response

# PR test
