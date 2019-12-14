# Phenospex Analysis
---
This repository contains tools for analyzing growth curve characteristics of 
Phenospex data from the World Vegetable Center, to compare different varieties 
of crops (e.g. eggplants and peppers) using 3D phenotyping techniques.

[![Build Status](https://travis-ci.org/qedsoftware/phenospex-analysis.svg?branch=master)](https://travis-ci.org/qedsoftware/phenospex-analysis)



# Data Requirements

* The Phenospex HortControl system produces a CSV file to be used as input.
* It is best to delete any spaces and special characters in the column names, in advance. (for example, "Height (mm)" should be edited to "Height").
* Please make sure that the date format for ```timestamp``` is "MM/DD/YYYY HH/MM/SS". For example: "10/23/2019  1:34:00 PM".

# Install R libraries
* ```grofit``` library can only be built from source. The source file can be downnloaded from [CRAN Archive](https://cran.r-project.org/src/contrib/Archive/grofit/grofit_1.1.1-1.tar.gz). In R, go to "Packages & Data", then "Package Installer". In the "Package Installer", select "Local Source Package" option, which pops up the window to locate the downloaded source file for installation.
* All of the other packages can be installed in the regular way.


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
