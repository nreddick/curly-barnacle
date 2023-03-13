# MIS480 Project by Nick Reddick
# March 2023
# Python for preprocessing the IBM coffee_sales.zip data (IBM Sampels Team, 2017)
# Both the sales_reciepts and products are loaded.


from io import StringIO
import pandas as pd

# sales receipts is loaded for processing
sales_frame = pd.read_csv('C:/Users/conif/Documents/CSUG/MIS480/sales_receipts.csv', header=0, usecols=['order','product_id'] )

# Single line transactions are grouped by order nuimber and arrayed by product ID
# Products not part of a given order are filled with zeros to comeplete the 2D array.

order_array = sales_frame.groupby(['order','product_id']).size().unstack(fill_value='0')
# The list of products, by product ID are loaded.

prod_frame = pd.read_csv('C:/Users/conif/Documents/CSUG/MIS480/product.csv', header=0, usecols=['product_id','product'] )

# A list of product IDs is created.
prodid_list = list(prod_frame["product_id"])

# A list of product IDs ordered is created.
order_list = list(order_array.columns.values)
# These lists are converted to sets to allow them to be compared.
order_set = set(order_list)
prod_set = set(prodid_list)
# The missing list is the list of ordered products without current prodcut IDs.
# In this case the list is empty.  All ordered products have valid IDs.

missing = list(sorted(order_set - prod_set))
print(missing)
# not_ordered is a list of products with valid IDs for which there are no current orders.
# All items on this list appear to be seasonal.  
not_ordered = list(sorted(prod_set - order_set))
print(not_ordered)


# I list of products for which there are current orders is created.
# This is done by excluding the prodcuts not ordered, by ID, from the product data frame
prod_frm_cor = prod_frame[~prod_frame.product_id.isin(not_ordered)]

# A list of product names to replace the product IDs in the order / product array is created.

order_prd_list = list(prod_frm_cor["product"])
# The prodcut IDs in the order / prodct array are replaced with the prodcut names
order_array.columns = order_prd_list
# the corrected array is visually inspected, and then written out to a CSV.
# This is the general process that could be used for a feasibility study of the 
# actual customers data.
order_array
order_array.to_csv('C:/Users/conif/Documents/CSUG/MIS480/order_array.csv')
# The data set is split into April data and May data for analysis before and after the start of the promotion.
may_22_array = order_array.loc[(order_array.index[40267:85584])]
apr_22_array = order_array.loc[(order_array.index[0:40266])]
# the data is written out as individual files 
apr_22_array.to_csv('C:/Users/conif/Documents/CSUG/MIS480/apr_22_array.csv')
may_22_array.to_csv('C:/Users/conif/Documents/CSUG/MIS480/may_22_array.csv')



##References
#IBM Samples Team. (2017, June 19). Small Coffee Chain Sales. IBM Accelerator Catalog.
# Retrieved from https://community.ibm.com/accelerators/catalog/content/Small-coffee-chain-sales
#Python Software Foundation. (2022). Download python. Python.org. 
# Retrieved from https://www.python.org/downloads/ 