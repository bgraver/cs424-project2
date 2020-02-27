filename = "atlantic-data.csv"
filename2 = "north-pacific.csv"
'''
# getting number of lines
## running this for the atlantic tells us we have 53219 rows in the list
num_lines = 0
with open(filename, 'r') as f:
    for line in f:
        num_lines += 1
    f.close()

print(num_lines)
'''

f = open(filename, 'r')
f2 = open(filename2, 'r')
new_f = open("treated-data-atlantic.csv", "w+")
new_f2 = open("treated-data-pacific.csv", "w+")

tornado = []
new_f.write("date,time,recordID,status,lat,lon,maxWindSpeed,minWindPressure,NEQuadrant1,SEQuardant1,SWQuandrant1,NWQuadrant1,NEQuadrant2,SEQuardant2,SWQuandrant2,NWQuadrant2,NEQuadrant3,SEQuardant3,SWQuandrant3,NWQuadrant3,cycloneNumber,name\n")
with open(filename, 'r') as f:
    for line in f:
        l= line.strip("\n").replace(" ", "").split(",")
        if len(l) is 4:  # its new tornado
            tornado = l
        else:
            send_line = "{0},{1},{2},{3}\n".format(line.strip("\n"), tornado[0], tornado[1], tornado[2])
            new_f.write(send_line)
f.close()

new_f2.write("date,time,recordID,status,lat,lon,maxWindSpeed,minWindPressure,NEQuadrant1,SEQuardant1,SWQuandrant1,NWQuadrant1,NEQuadrant2,SEQuardant2,SWQuandrant2,NWQuadrant2,NEQuadrant3,SEQuardant3,SWQuandrant3,NWQuadrant3,cycloneNumber,name\n")
with open(filename2, 'r') as f:
    for line in f:
        l = line.strip("\n").replace(" ", "").split(",")
        if len(l) is 4:  # its new tornado
            tornado = l
        else:
            send_line = "{0},{1},{2},{3}\n".format(line.strip("\n"), tornado[0], tornado[1], tornado[2])
            new_f2.write(send_line)
f.close()




'''
1) Read line
2) if line is:
    a) defining the tornado
        i) strip all tabs
        ii) delimit by comma
        iii) hold onto data until next "define line"
    b) line about the tornado
        i) add the values from the definition to the end of the line
        ii) add the line to the new file
'''

