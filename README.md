# Phenospex Analysis
---
This repository contains tools for analyzing growth curve characteristics of 
Phenospex data from the World Vegetable Center, to compare different varieties 
of crops (e.g. eggplants and peppers) using 3D phenotyping techniques.

[![Build Status](https://travis-ci.org/qedsoftware/phenospex-analysis.svg?branch=master)](https://travis-ci.org/qedsoftware/phenospex-analysis)

# Contact

Point of Contact: Jiehua Chen <j@qed.ai> | QED | https://qed.ai


# CSV Format Requirements
* It is better to delete any space and special characters in the column names (for example, "Height (mm)" should be edited to "Height").
* Please make sure the date format for ```timestamp``` is "MM/DD/YYYY HH/MM/SS", for example: "10/23/2019  1:34:00 PM".


# How to run the code
* Open ```main.R```
* Put the name of the data file as the input of  the variable ```datafile``` 
* Put the perperties that want to compare as the input of the vector variable ```properties```.
* Put the dates of the starting time and ending time of the legitimate data as the inputs of ```strptime``` function in the variables ```startingtime``` and ```endingtime```. 
* Then run the whole script of ```main.R```. 
* The output is a csv file which contains AUC estimates for each unit. 