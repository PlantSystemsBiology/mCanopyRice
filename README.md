# mCanopyRice

## mCanopyRice/COV_Calculation
3D point cloud data and code for COV calculation.

## mCanopyRice/CanopyModel_JYY
Source code of the 3D canopy model of rice used for identifying key features contributing to canopy photosynthesis in the F1 hybrid compared to parents.

## mCanopyRice/CanopyModel_RIL_population
Source code of the 3D canopy model of rice used for constructing canopy model of RIL population and calculating COV.

Code developer: Dr. Qingfeng Song songqf(at)cemps.ac.cn

# files
mCanopyRice/CanopyModel_JYY/M

Plant architectural parameter dataset measured, including leaf base height, leaf length, leaf width, leaf angle, horizontal distance, and vertical height of the leaf tip. The leaf curvature was calculated. 
The 'ca1' for JY5B with cap1 allele, the 'CA2' for JP69 with CAP1 allele and the 'F1' for JYY69 (F1 hybrid).
Calculate leaf curvature using the mCanopy/leafCurvature_run.m and mCanopy/leafCurvature/getLeafCurvature.m program.

mCanopyRice/CanopyModel_JYY/AQcurves

Actual measured leaf light response curve data, measured at the upper middle position of the top mature leaves. Data format: 1 .txt file for each variety and period, including 4 columns, the first column is PPFD, and columns 2-5 are leaf net photosynthetic rates (4 biological replicates) Includes: 0724 period: JYY. 0807 period: JYY (this period is used for canopy photosynthesis calculation for the 0810 period) HS (heading stage) period JYY. AQ curves need to be fitted into formula parameters, which can then be used for canopy photosynthesis calculation. The fitting of AQ curves was done using mCanopy/fittingAQ/fittingAQs.m The fitted results are saved in .xlsx files in the /AQcurves directory.

mCanopyRice/CanopyModel_JYY/FastTracer_2021

Ray tracing simulation software, fastTracerVS2019.exe, input and output format files.

mCanopyRice/CanopyModel_JYY/python script

Python scripts for Jupyter notebooks, used to batch execute fastTracer ray tracing simulation calculations (Python 3, Jupyter notebook installation required).

mCanopyRice/CanopyModel_JYY/mCanopy

Canopy modeling software. Features include: 1. Constructing 3D canopy models from plant architectural parameters; Os_main.m 2. Replacing the plant architectural parameters of two plants to generate virtual plant architectural parameters. virtualPlant/virtualCanopy.m 3. Calculating leaf curvature angles from measured plant architectural parameters. leafCurvature/getLeafCurvature.m 4. Fitting AQ curve formulas from measured AQ curves. fittingAQ/fittingAQs.m 5. Calculating canopy photosynthesis. calculation/calculateAc.m as well as scripts for batch execution of 3D model construction.

mCanopyRice/CanopyModel_JYY/CM

Output directory, storing 3D canopy model files.

mCanopyRice/CanopyModel_JYY/PPFD

Output directory, storing files after ray tracing calculations of 3D canopy models.

mCanopyRice/CanopyModel_JYY/summary

Output directory, .xlsx tables for canopy photosynthesis Ac, leaf area index LAI, and absorptance Abs.

mCanopyRice/CanopyModel_JYY/summary_total

Output directory, .xlsx tables for canopy photosynthesis and leaf area index mean and std values. 

mCanopyRice/COV_Calculation/compute_COV.py

The source code for calculating COV from point cloud data.

The following directories are the data of point clouds. 

mCanopyRice/COV_Calculation/0814:

9311-DCA1: CAP1/CAP1 genotype. 
9311-xca1: cap1/cap1 genotype. 
9311-F1: CAP1/cap1 genotype. 
JP69: CAP1/CAP1 genotype. 
JY5B: cap1/cap1 genotype. 
JYY69: CAP1/cap1 genotype. 
WYG-DCA1: CAP1/CAP1 genotype. 
WYG-F1: CAP1/cap1 genotype. 
WYG-xca1: cap1/cap1 genotype. 

mCanopyRice/COV_Calculation/0815:

75aa: cap1-75 homozygote genotype. 
75aa-F1: cap1-75/CAP1 genotype. 
169aa: cap1-169 homozygote genotype. 
169aa-F1: cap1-169/CAP1 genotype. 
DCA1: WYJ-CAP1 homozygote genotype. 
fon4DCA1: WYJ-fon4/fon4-CAP1/CAP1 genotype. 
fon4F1: WYJ-fon4/fon4-CAP1/cap1 genotype. 
fon4xca1: WYJ-fon4/fon4-cap1/cap1 genotype. 

mCanopyRice/COV_Calculation/0830:

9311-dca1: CAP1/CAP1 genotype. 
9311-f1: CAP1/cap1 genotype. 
9311-xca1: cap1/cap1 genotype. 
jb69: JP69 with CAP1/CAP1 genotype. 
jy5b: JY5B with cap1/cap1 genotype. 

mCanopyRice/COV_Calculation/0904:

WYG-DCA1: WYG with CAP1/CAP1 genotype. 
WYG-XCA1: WYG with cap1/cap1 genotype. 
F1: WYG with CAP1/cap1 genotype. 

mCanopyRice/COV_Calculation/0906:

75aa: cap1-75 homozygote genotype. 
75aa-F1: cap1-75/CAP1 genotype. 
169aa: cap1-169 homozygote genotype. 
169aa-F1: cap1-169/CAP1 genotype. 
DCA1: WYJ-CAP1 homozygote genotype. 
fon4DCA1: WYJ-fon4/fon4-CAP1/CAP1 genotype. 
fon4F1: WYJ-fon4/fon4-CAP1/cap1 genotype. 
fon4XCA1: WYJ-fon4/fon4-cap1/cap1 genotype. 

mCanopyRice/COV_Calculation/0913:

fon4ca1: WYJ-fon4/fon4-cap1/cap1 genotype. 
JYY69: JYY69 with CAP1/cap1 genotype. 

mCanopyRice/COV_Calculation/wheat_1026:

abd-chun: ABD homozygote. 
abd-za: ABD heterozygote. 
wt: the wide type (WT). 

mCanopyRice/COV_Calculation/wheat_1129:

abd-chunhe: ABD homozygote. 
abd-zahe: ABD heterozygote. 
wt: the wide type (WT). 

mCanopyRice/CanopyModel_RIL_population/constructRIL.m: the source code for constructing canopy model and calculating COV for the RIL population. 

mCanopyRice/CanopyModel_RIL_population/COV.xlsx: the output of COV data. 

mCanopyRice/CanopyModel_RIL_population/virtualCanopyForRIL.m: source code used for constructing canopy model of the RIL population. 

mCanopyRice/CanopyModel_RIL_population/RIL-params.xlsx: The plant architectural parameters of the RIL population.

mCanopyRice/CanopyModel_RIL_population/"JYY69 F1 data.xlsx": The parameters of JYY69 plant architecture. 

mCanopyRice/CanopyModel_RIL_population/M:

Plant architectural parameter dataset measured, including leaf base height, leaf length, leaf width, leaf angle, horizontal distance, and vertical height of the leaf tip. The leaf curvature was calculated with code from /leafCurvature.

mCanopyRice/CanopyModel_RIL_population/CM:

Output directory, 3D canopy model files.

