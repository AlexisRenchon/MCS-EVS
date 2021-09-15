using DataFrames, CSV

# get the path of all COSORE input files
inputs = readdir(joinpath("Input", "FLUXNET"), join = true);

# we want FULLSET_HH
# https://www.nature.com/articles/s41597-020-0534-3.pdf
# SWC is soil moisture (depth unknown)
# TS is soil temperature (depth unknown)
# NIGHT column is nighttime (1) or daytime (0)

# I want: nighttime NEE measured (not gap-filled), qc'ed, turbulent + storage
# same for SWC and TS, I want not gap-filled if possible

# e.g., FLX_AT-Neu_FLUXNET2015_FULLSET_HH_2002-2012_1-4.csv
# start with NEE_CUT_REF, with NEE_CUT_REF_QC = 1, NIGHT = 1 ? change later if needed
# SWC_F_MDS_1 for SWC, SWC_F_MDS_1_QC = 0, NIGHT = 1 ?
# TS_F_MDS_1 for TS, TS_F_MDS_1_QC = 0, NIGHT = 1 ?


