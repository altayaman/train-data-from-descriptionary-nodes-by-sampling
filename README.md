# train-data-from-descriptionary-nodes-by-sampling
Train ml model by providing balanced trainset by means of clustering  

#1  
The folder "1 - Descriptionary nodes into separate csv files" has the raw descriptionary  where each node is stored in separate csv file.  

#2  
The folder "2 - clustering ip" has the codes where I tried to cluster each descriptionary node into several clusters where each cluster would have almost the same items consisting of 80%-90% the same tokens. The purpose of that is to pick several items from each cluster of each node as a train set, after which I would have only small portion of sampled data that would be a good representative for each cluster of each node. And that would be a way better train set rather than taking the whole descriptionary as a train set.  

But for now it is paused as clustering the huge descriptionary is a challenge.  


#3  
The folder "3 - Picking samples from each node" has alternative solution to above #2.  

For that we sort each csv file and divide the rows into needed sample size and take one item from each part. 
Ex: If we need 100 items as a sample from 10000 items csv file, we sort the file and divide 10000 by 100 where we get 100 parts. Then pick 1 items from each part. Because after sorting the file, the similar items are sorted one after another creating a sorted clusters. Then when we do the sampling process it is more likely that we get at least one representative item from each cluster. And of course, example shows sample as 100 out of 10000, consequently the larger tha sample size the more likely we touch more clusters which makes a good representative sample data.  


** *:  
Descriptionary - a dictionary that has where correct item descriptions for nodes.
