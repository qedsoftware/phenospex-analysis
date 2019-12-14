# Phenospex Analysis
---
This repository contains tools for analyzing growth curve characteristics of 
Phenospex data from the World Vegetable Center, to compare different varieties 
of crops (e.g. eggplants and peppers) using 3D phenotyping techniques.

[![Build Status](https://travis-ci.org/qedsoftware/phenospex-analysis.svg?branch=master)](https://travis-ci.org/qedsoftware/phenospex-analysis)

![Phenospex Rig](https://qed.ai/docs/images/WorldVeg_QED_Phenospex_Angled.jpg)




# Data Requirements

* The Phenospex HortControl system produces a CSV file to be used as input.
* It is best to delete any spaces and special characters in the column names, in advance. (for example, "Height (mm)" should be edited to "Height").
* Please make sure that the date format for ```timestamp``` is "MM/DD/YYYY HH/MM/SS". For example: "10/23/2019  1:34:00 PM".


# Install R Libraries

Most dependencies listed in the DESCRIPTION file are installable by standard means, but the ```grofit``` library can only be built from source. 

## Installation of ```grofit``` using RStudio:

1. Download the source package from here: [CRAN Archive](https://cran.r-project.org/src/contrib/Archive/grofit/grofit_1.1.1-1.tar.gz). 
2. In R, go to "Tools", then "Install Packages"
3. From the first dropdown menu titled "Install from:", select "Package Archive File (.tgz; tar.gz)".
4. A window will pop up, where you should browse to find the source package that you downloaded in Step #1.
5. Click "Install".

![R Studio Installation](https://imgur.com/bfRpbNf.jpg)


## Installation of ```grofit``` using R GUI:

1. Download the source package from here: [CRAN Archive](https://cran.r-project.org/src/contrib/Archive/grofit/grofit_1.1.1-1.tar.gz). 
2. Go to "Packages & Data", then "Package Installer". 
3. Select "Local Source Package", then find the source package that you downloaded in Step #1.
4. In the R console, type:

    install.packages('PATH_TO_PACKAGE/grofit_1.1.1-1.tar.gz', repos=NULL)

   where PATH_TO_PACKAGE should be substituted with the path to the source package.

![R GUI Installation](https://imgur.com/rB3eiEx.jpg)


# Running the Code

* Open ```main.R```
* Specify the name of the Phenospex data file as the value of the variable ```datafile``` 
* Specify the properties that you wish to compare as inputs for the vector variable ```properties```.
* Specify the dates of the starting and ending times for the data of concern. 
 These variables are ```startingtime``` and ```endingtime```, respectively, supplied as inputs to the ```strptime``` function.
* Run the whole ```main.R``` main script.
* The output is a CSV file containing AUC estimates for each unit.


# Contact

Point of Contact: Jiehua Chen <j@qed.ai> | QED | https://qed.ai
