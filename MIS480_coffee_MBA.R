# MIS480 Project by Nick Reddick
# March 2023
# R code for Market Basket Analysis of the IBM coffee_sales.zip data (IBM Samples Team, 2017)
# Both the sales_receipts and products files were pre-processed into a 2D order / product array
# using python
# The analysis of the whole data set is done first.
# This is a process that could be used to validate actual customer data

# Just the April orders are processed second.
# This represents the data prior to the new promotion

# Then the May data is processed, representing the data following the promotion

# set environment
# Location of data files
setwd("/Users/conif/Documents/CSUG/MIS480")
# Setting output prompt to include data and time the command is executed.
options(prompt = paste(Sys.time(), ">"))

# Load Libraries
# arules and arulesViz are used for the Market Basket Analysis
# install.packages("arules")
# install.packages("arulesViz")
# The mltools package contains the matrix tools used to prepare 
#     The 2 D array for processing as transactions
# install.packages("mltools")

library(arules)
library(arulesViz)
library(datasets)
library(dplyr)

library(Matrix)
library(data.table)
library(mltools)


# Load the preprocessed order / product array

ibm_order_array<- read.csv("order_array.csv", header=TRUE)
#ibm_order_array
####
# Convert the array to a table prior to creating the matrix 
ibm_order_table <- setDT(ibm_order_array)

#ibm_order_table

# convert the order /product table to a sparse matrix
# The order number column is left intact
ibm_order_spd <- sparsify (ibm_order_table[, !"order"] )
#ibm_order_spd
# converting the matrix from the dgCMatric format to the ngCMatrix format.
# dcG was used by older versions of the transactions function in arules
# ncGMatrix are binary sparse matrix that improve performance
ibm_order_spn <- as(ibm_order_spd, "nMatrix")
#ibm_order_spn

# The matrix axis are reversed by the transaction function.
# this is contrary to the examples provided
# however it is easily remedied 
# this is a matrix transformation to align the axis properly after the 
# transaction command.  
ibm_order_spt <-t(ibm_order_spn)

ibm_coffee_trans <- transactions(ibm_order_spt, format = "wide")
#ibm_coffee_trans

# The freq_range  is used to provide an array of colors in the plot.
# the itemFrequencyPlot does not use frequency the same way 
# as other bar charts, so instead of coloring the bars by height
# it just displays them in an array of colors.
# this still provides greater visual interest to the graph.
freq_range <-c(250,500,750,1000,1250,1500,2000,2250,2500,2750,3000)
itemFrequencyPlot(ibm_coffee_trans,topN=20,type="absolute", ylab="Item Frequency - Full Dataset",col=heat.colors(max(freq_range))[freq_range])

# rules are created with the recommended .8 confidence first.
# this produces a null set.
# the confidence is reduced to provide rules for further analysis.
# this reduction might be reduced, or not required if a larger data set was used.
rules <- apriori(data=ibm_coffee_trans, parameter=list(supp=0.001, conf = 0.8))
rules <- apriori(data=ibm_coffee_trans, parameter=list(supp=0.001, conf = 0.1))

rules<-sort(rules, by="confidence", decreasing=TRUE)
inspect(rules[1:5])
rules

###  Rules for Apr subset
apr_22_array<- read.csv("apr_22_array.csv", header=TRUE)

# Convert the array to a table prior to creating the matrix 
apr_22_table <- setDT(apr_22_array)

#apr_22_table
# convert the order /product table to a sparse matrix
# The order number column is left intact
apr_22_spd <- sparsify (apr_22_table[, !"order"] )
#apr_22_spd

# converting the matrix from the dgCMatric format to the ngCMatrix format.
# dcG was used by older versions of the transactions function in arules
# ncGMatrix are binary sparse matrix that improves performance
apr_22_spn <- as(apr_22_spd, "nMatrix")
#apr_22_spn

# The matrix axis are reversed by the transaction function.
# this is a matrix transformation to align the axis properly after the 
# transaction command.
apr_22_spt <-t(apr_22_spn)

apr_22_trans <- transactions(apr_22_spt, format = "wide")
#apr_22_trans

itemFrequencyPlot(apr_22_trans,topN=20,type="absolute",ylab="Item Frequency - Apr 2022",col=heat.colors(max(freq_range))[freq_range])

apr_22_rules <- apriori(data=apr_22_trans, parameter=list(supp=0.001, conf = 0.8))
apr_22_rules <- apriori(data=apr_22_trans, parameter=list(supp=0.001, conf = 0.1))

apr_22_rules<-sort(apr_22_rules, by="confidence", decreasing=TRUE)
inspect(apr_22_rules[1:5])
apr_22_rules

### rules for May subset
may_22_array<- read.csv("may_22_array.csv", header=TRUE)
may_22_table <- setDT(may_22_array)

#may_22_table
# convert the order /product table to a sparse matrix
# The order number column is left intact
may_22_spd <- sparsify (may_22_table[, !"order"] )
#may_22_spd
# converting the matrix from the dgCMatric format to the ngCMatrix format.
# dcG was used by older versions of the transactions function in arules
# ncGMatrix are binary sparse matrix that improves performance
may_22_spn <- as(may_22_spd, "nMatrix")
#may_22_spn
# The matrix axis are reversed by the transaction function.
# this is a matrix transformation to align the axis properly after the 
# transaction command.
may_22_spt <-t(may_22_spn)

may_22_trans <- transactions(may_22_spt, format = "wide")
#may_22_trans

itemFrequencyPlot(may_22_trans,topN=20,type="absolute",ylab="Item Frequency - May 2022", col=heat.colors(max(freq_range))[freq_range])

may_22_rules <- apriori(data=may_22_trans, parameter=list(supp=0.001, conf = 0.8))
may_22_rules <- apriori(data=may_22_trans, parameter=list(supp=0.001, conf = 0.1))

may_22_rules<-sort(rules, by="confidence", decreasing=TRUE)
inspect(may_22_rules[1:5])
may_22_rules

##References
#IBM Samples Team. (2017, June 19). Small Coffee Chain Sales. IBM Accelerator Catalog.
# Retrieved from https://community.ibm.com/accelerators/catalog/content/Small-coffee-chain-sales
#Posit Software. (2022, September 21). Download RStudio Desktop. 
# Posit. Retrieved November 	18, 2022, from 
# https://posit.co/download/rstudio-desktop/#download
#The R Foundation. (2022, October 31). The R project for statistical computing. 
# R. Retrieved 	November 18, 2022, from https://www.r-project.org/ 