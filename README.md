# curly-barnacle
# The files in this repository were created to analyze the dataset provided by the IBM Sample Team small coffee chain sales project.
# Those files are required for these files to work.

# The first file, the ibm_trans_trans.py is a python 3.8 script that takes the sales_reciepts.cvs and products.csv files from the IBM samples team
# and creates a 2D array for the sales orders as complete transactions against the full product array.    
# the output of the script is 3 CSV files.  
# One is the 2D array for the whole data set 
# One is the 2D array for the April sales data
# one is the 2D array for the May sales data.

# The second file MIS480_coffee_MBA.R is a R script that takes the files output by the python script, above, and performs a 
# Market Basket Analaysis.  The R script transforms the 2D arrays into sparce binary matrix, proicesses then as transactions 
# for use by the arules package, produces an item freqency plot for each matrix, generates the rules (confidence 0.1) 
# and displays the top 5 rules.   No oputput files are produced.   

# IBM Samples Team. (2017, June 19). Small Coffee Chain Sales. IBM Accelerator Catalog. Retrieved from 
#    https://community.ibm.com/accelerators/catalog/content/Small-coffee-chain-sales 
