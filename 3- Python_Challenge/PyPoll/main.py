#|---------|
#| PY_POLL | 
#|---------| 
#Analyze votes  
#Dependencies
import os
import csv

#Establish path
csvfile_path = os.path.join('.','raw_data','election_data.csv')
textfile_path = os.path.join('.','election_analysis.txt') #Saved at the end

#Variables stored in empty lists
total_votes=[]
total_candidates=[]
unique_candidates=[]
candidates=[]
candidate_count=[]

#Open csv, read and store contents, and remove the header
with open(csvfile_path, newline='', encoding= "utf8") as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',')
    
    #Read through header first
    csv_header = next(csvreader)

#1. Calculate the total number of votes cast
    for row in csvreader:
        
        total_votes.append(row[0])
        votes_count = str(len(total_votes))

#2. Calculate a complete list of candidates who received votes
        total_candidates.append(row[2])
    
    for i in total_candidates:
        if i not in unique_candidates:   #this can be re-used/not hard coded
            unique_candidates.append(i)

#3. Calculate the percentage of votes each candidate won
    # Calculate out of all votes, the ones assigned to each candidate and the %
    # Use a dictionary 
    total_candidates_count = [[x,total_candidates.count(x)] for x in set (total_candidates)]
    total_candidates_summary= dict((x,total_candidates.count(x)) for x in set(total_candidates))

    for key in total_candidates_summary:
        keys = key
    for value in total_candidates_summary.items():
        values = value

#4. Calculate the total number of votes each candidate won
    for row in total_candidates_count:
      candidates.append(row[0])
      candidate_count.append(int(row[1]))

#5. Calculate the winner of the election based on popular vote.
# Use max value to return an index which will be the winner
    max_increase_value = max(candidate_count)
    max_increase_value_index = candidate_count.index(max_increase_value)
    winner = candidates[max_increase_value_index]

#6. Print final script
print(" ")
print("Election Results!!!")
print("-----------------------")
print(f"Total votes: {votes_count}")
print("-----------------------")

for key, value in total_candidates_summary.items():
   print(f"{key}: {round((int(value)/int(votes_count))*100)}% ({value})")  #To print %

print("-----------------------")
print(f"Winner: {winner}")
print("-----------------------")

#7. Export a text file with results
with open (textfile_path, 'w') as txtfile:
    txtfile.write(" ")
    txtfile.write("\n")
    txtfile.write("Election Results!!!")
    txtfile.write("\n")
    txtfile.write("-----------------------")
    txtfile.write("\n")
    txtfile.write(f"Total votes: {votes_count}")
    txtfile.write("\n")
    txtfile.write("-----------------------")
    txtfile.write("\n")
    for key, value in total_candidates_summary.items():
        txtfile.write(f"{key}: {round((int(value)/int(votes_count))*100)}% ({value})" +"\n")  #To print %
    txtfile.write("-----------------------")
    txtfile.write("\n")
    txtfile.write(f"Winner: {winner}")
    txtfile.write("\n")
    txtfile.write("-----------------------")