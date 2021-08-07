
# from typing import NewType


# myStrr = "Price PeriodTownSuperDieselKerosene 15th June 2021 -  14th July 2021Mombasa124.72105.2795.46 15th June 2021 -  14th July 2021Kilifi125.43105.9896.17 15th June 2021 -  14th July 2021Likoni Mainland125.07105.6295.82 15th June 2021 -  14th July 2021Kwale125.07105.6295.82 15th June 2021 -  14th July 2021Malindi125.64106.1996.38 15th June 2021 -  14th July 2021Lungalunga125.79106.3496.53 15th June 2021 -  14th July 2021Voi126.20106.7596.93 15th June 2021 -  14th July 2021Taveta127.60108.1598.34 15th June 2021 -  14th July 2021Lamu128.02108.5798.76 15th June 2021 -  14th July 2021Hola128.30108.8599.05 15th June 2021 -  14th July 2021Nairobi127.14107.6697.85 15th June 2021 -  14th July 2021Thika127.15107.6697.85 15th June 2021 -  14th July 2021Machakos127.38107.8998.08 15th June 2021 -  14th July 2021Kajiado127.56108.0898.26 15th June 2021 -  14th July 2021Makuyu127.43107.9598.13 15th June 2021 -  14th July 2021Muranga127.66108.1898.37 15th June 2021 -  14th July 2021Sagana127.88108.4098.58 15th June 2021 -  14th June "
# def Convert(string,seg):
#     li = list(string.split(seg))
#     return li
# mynew = Convert(myStrr," ")
# alphabet= ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

# for items in mynew:
#     for i in alphabet:
#         if items.find("2021"+i+"") == -1:
#         #    print("No 'is' here!")
#             pass
#         else:
#             bb=items.replace('2021',"2021 ")
#             nerarr= Convert(bb," ")
#             townarr=Convert(nerarr[1],".")
            
#             for it in townarr:
#                 town = townarr[0][:-3]

#             number= nerarr[1].replace(town,'')
          
#             if len(number)==17:
#                 price1,price2,price3= number[:6],number[6:][:-5],number[-5:]
#             if len(number)>17:
#                 price1,price2,price3= number[:6],number[6:][:-6],number[-6:]
#             newstring='2021 '+town+' '+price1+' '+price2+' '+price3
#             print(items)

#             # find location of item
#             mynew[mynew.index(items)] = newstring
#             print(newstring)
#             # print(bb)
# print(mynew[2:][:-1])
# # Driver code    
# # print(Convert(mySTr))

with open("new.txt") as myfile:
    content= myfile.read().replace('15th June 2021    14th July 2021	', '')
    with open("final.txt", 'w') as new:
        new.write(content)
with open("final.txt") as nw:
    cmpltNew=nw.read().replace(' ',",")
    with open('finaltoo.txt', 'w') as bt:
        bt.write(cmpltNew)