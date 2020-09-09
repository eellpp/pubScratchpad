## Delete rows based on threshold NA
Quickly drop all the columns where at least 90% of the data is empty. I thought this might be handy for others as well.  

drop_thresh = df_raw.shape[0]*.9  
df = df_raw.dropna(thresh=drop_thresh, how='all', axis='columns').copy()  

