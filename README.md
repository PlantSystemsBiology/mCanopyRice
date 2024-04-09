# mCanopyRice
Source code of the 3D canopy model of rice used for identifying key features contributing to canopy photosynthesis in the F1 hybrid compared to parents.

Code developer: Dr. Qingfeng Song songqf(at)cemps.ac.cn


/M 
Plant architectural parameter dataset measured, including leaf base height, leaf length, leaf width, leaf angle, horizontal distance, and vertical height of the leaf tip. The leaf curvature was calculated. Includes: 0711 period: 9311, JYY and WYJ. 0724 period: JYY and WYJ. 0810 period: 9311, JYY and WYJ. 0828 period: JYY and WYJ. The NILs with ca1 and CA2 and F1.
Calculate leaf curvature using the mCanopy/getLeafCurvature.m program.

/AQcurves
Actual measured leaf light response curve data, measured at the upper middle position of the top mature leaves. Data format: 1 .txt file for each variety and period, including 4 columns, the first column is PPFD, and columns 2-5 are leaf net photosynthetic rates (4 biological replicates) Includes: 0724 period: 9311, JYY, WYJ. 0807 period: 9311, JYY, WYJ (this period is used for canopy photosynthesis calculation for the 0810 period) HS (heading stage) period 9311, JYY, WYJ. ca1 and CA2 of NILs and F1. AQ curves need to be fitted into formula parameters, which can then be used for canopy photosynthesis calculation. The fitting of AQ curves was done using fittingAQ/fittingAQs.m The fitted results are saved in .xlsx files in the \AQcurves directory.

/FastTracer_2021
Ray tracing simulation software, fastTracerVS2019.exe, input and output format files.

/python script
Python scripts for Jupyter notebooks, used to batch execute fastTracer ray tracing simulation calculations (Python 3, Jupyter notebook installation required).

/mCanopy
Canopy modeling software. Features include: 1. Constructing 3D canopy models from plant architectural parameters; Os_main.m 2. Replacing the plant architectural parameters of two plants to generate virtual plant architectural parameters. virtualPlant/virtualCanopy.m 3. Calculating leaf curvature angles from measured plant architectural parameters. leafCurvature/getLeafCurvature.m 4. Fitting AQ curve formulas from measured AQ curves. fittingAQ/fittingAQs.m 5. Calculating canopy photosynthesis. calculation/calculateAc.m as well as scripts for batch execution of 3D model construction.

/CM
Output directory, storing 3D canopy model files.

/PPFD
Output directory, storing files after ray tracing calculations of 3D canopy models.

/summary
Output directory, .xlsx tables for canopy photosynthesis Ac, leaf area index LAI, and absorptance Abs.

/summary_total
Output directory, .xlsx tables for canopy photosynthesis and leaf area index mean and std values. 
