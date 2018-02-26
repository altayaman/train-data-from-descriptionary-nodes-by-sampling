## -------------------------------------------------------------------------------------------
## Read node ids file
library(data.table)
path = '/Users/altay.amanbay/Desktop/new node booster/experiments/3/1 - Code to produce csv files in folder 1.1/'
csv_file = 'descriptionary_cat_ids_n_counts.csv'
node_ids <- fread(paste0(path,csv_file), sep = ',', header = T) #, nrows = 50)
node_ids <- data.frame(node_ids)

# rename colnames
colnames(node_ids) <- c('category_id', 'count')

# pick only certain node ids with count higher than 100
node_ids <- node_ids[1:298,c('category_id', 'count')]

# iterate through csv files and cluster them one-by-one
library(stringdist)
c <- 1

for(i in 1:nrow(node_ids)){
  start_time <- Sys.time()
  
  # generate file name
  file_name <- paste0(node_ids[i,1],'-',node_ids[i,2],'.csv')
  file_name <- gsub(',','',file_name)
  print('=======================================================================')
  print(c)
  
  # read data
  print(paste0('Reading from ',file_name,' ...'))
  path = '/Users/altay.amanbay/Desktop/new node booster/experiments/3/1.1 - Descriptionary in separate csv files for each node/'
  dt <- fread(paste0(path,file_name), sep = ',', header = T, nrows = 10)
  
  # select certain descriptions
  df = data.frame(dt[,c('description'),with=F])
  colnames(df) <- 'desc'
  
  ## -------------------------------------------------------------------------------------------
  ## Data processing
  
  ## clean data
  clean_pat <- paste0("[0-9]+|[[:punct:]]|ï|½|®")
  df <- as.data.frame(sapply(df, function(x) {gsub(clean_pat, " ", x)}))
  
  ## turn data to lowercase
  df <- as.data.frame(sapply(df, function(x) {return(tolower(x))}))
  
  ## additional processing
  clean_pat <- paste0('*\\b[[:alpha:]]{1,2}\\b*')
  df <- as.data.frame(sapply(df, function(x) {gsub(clean_pat, "", x)}))
  
  clean_pat <- paste0('^\\s+|\\s+$')
  df <- as.data.frame(sapply(df, function(x) {gsub(clean_pat, "", x)}))
  
  clean_pat <- paste0('\\s+')
  df <- as.data.frame(sapply(df, function(x) {gsub(clean_pat, " ", x)}))
  
  df <- na.omit(df)
  
  ## -------------------------------------------------------------------------------------------
  ## 1
  ## H-clustering (calculate distances betweeen data points)
  print('Distance calculation is in process ...')
  uniquemodels <- unique(as.character(df[1:nrow(df),]))
  uniquemodels.int <- hashr::hash(strsplit(uniquemodels,"[[:blank:]]+"))
  distancemodels <- seq_distmatrix(uniquemodels.int,uniquemodels.int,method = 'jw')
  rownames(distancemodels) <- uniquemodels
  hc <- hclust(as.dist(distancemodels))
  
  ## 3 (if setp 2 skipped, set h manually)
  ## Divivde into clusters according to height
  print('Clustering is in process ...')
  dfClust <- data.frame(uniquemodels, cutree(hc, h=0.5))   # h=(1-0.0001)
  names(dfClust) <- c('description','cluster')
  dfClust <- dfClust[order(dfClust$cluster),]
  row.names(dfClust) <- NULL
  
  print('Sorting clustered items ...')
  dfClust <- dfClust[with(dfClust, order(cluster, description)), ]  # optional sort
  #View(dfClust)
  
  # export into file
  path = path = '/Users/altay.amanbay/Desktop/new node booster/experiments/3/2.1 - clustered files/'
  file_name <- paste0(node_ids[i,1],'-',node_ids[i,2],'_clustered.csv')
  file_name <- gsub(',','',file_name)
  print(paste0('Exporting into ',file_name,' ...'))
  write.table(dfClust, file = paste0(path, file_name), sep = ',' ,append = F, row.names = F)
  
  c <- c + 1
  
  # print elapsed time
  end_time <- Sys.time()
  time_taken <- end_time - start_time
  print(paste0('The process took ',time_taken, 's'))
}



