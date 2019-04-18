#|---------|
#| PY_BANK | 
#|---------| 
#Analyze financial records 
#Dependencies
import os
import csv

#Establish path
csvfile_path = os.path.join('.', 'raw data', 'budget_data.csv')
textfile_path = os.path.join('.','budget_analysis_1.txt') #Saved at the end

#Variables stored in empty lists
total_months = []
total_revenue = []
change_revenue = []

#Open csv, read and store contents and remove the header
with open(csvfile_path, newline="", encoding= "utf-8") as csvfile:
    csvreader = csv.reader(csvfile, delimiter=",")
    
    #Read through header first
    csv_header = next(csvreader)
    print(f"Header: {csv_header}")

    #1. Calculate the total number of months included in the dataset
    #2. Calculate the net total amount of "Profit/Losses" over the entire period

    for row in csvreader:                   
        total_months.append(row[0])
        total_revenue.append(int(row[1]))

	#3. Calculate the average of the changes in "Profit/Losses" over the entire period
    for i in range(len(total_revenue)-1):  
        change_revenue.append(total_revenue[i+1]-total_revenue[i])
        
#4. Calculate the greatest increase in profits (date and amount) over the entire period
greatest_rev_increase = max(change_revenue) 
greatest_rev_inc_month = change_revenue.index(max(change_revenue)) + 1

#5. Calculate the greatest decrease in losses (date and amount) over the entire period
greatest_rev_decrease = min(change_revenue) 
greatest_rev_dec_month = change_revenue.index(max(change_revenue)) + 1

#Print in Terminal
print("Financial Analysis")
print("-----------------------------------")
print(f"Total Months: {len(total_months)}")
print(f"Total: $ {sum(total_revenue)}")
print(f"Average Change: {round(sum(change_revenue)/len(change_revenue),2)}")
print(f"Greatest Increase in Profits: {total_months[greatest_rev_inc_month]} $ {(str(greatest_rev_increase))}")
print(f"Greatest Decrease in Profits: {total_months[greatest_rev_dec_month]} $ {(str(greatest_rev_decrease))}")
print("\n")

#Export "Print" as a text file 
with open (textfile_path, 'w') as txtfile:
    txtfile.write(" ")
    txtfile.write("\n")
    txtfile.write("Financial Analysis")
    txtfile.write("\n")
    txtfile.write("-----------------------------------")
    txtfile.write("\n")
    txtfile.write(f"Total Months: {len(total_months)}")
    txtfile.write("\n")
    txtfile.write(f"Total: $ {sum(total_revenue)}")
    txtfile.write("\n")
    txtfile.write(f"Average Change: {round(sum(change_revenue)/len(change_revenue),2)}")
    txtfile.write("\n")
    txtfile.write(f"Greatest Increase in Profits: {total_months[greatest_rev_inc_month]} $ {(str(greatest_rev_increase))}") 
    txtfile.write("\n")
    txtfile.write(f"Greatest Decrease in Profits: {total_months[greatest_rev_dec_month]} $ {(str(greatest_rev_decrease))}")
