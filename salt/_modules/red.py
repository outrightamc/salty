import salt.modules.network
import re
import json
from lxml import etree 
from tabulate import tabulate
import pandas

testfds

def parse_addresses():
    
#    s = __salt__['net.cli']('show configuration interfaces | display set', format='xml')['out']['show configuration interfaces | display set']
    s = ['set interfaces ge-0/0/1 unit 0 family inet sampling input','set interfaces ge-0/0/1 unit 0 family inet sampling output','set interfaces ge-0/0/0 unit 0 family inet sampling input','set interfaces ge-0/0/0 unit 0 family inet sampling output','set interfaces ge-0/0/0 unit 0 family inet address 192.168.15.66/24','set interfaces ge-0/0/1 unit 0 family inet dhcp','set interfaces ge-0/0/2 unit 0 family inet address 1.1.1.1/30','set interfaces ge-0/0/2 unit 0 family inet address 192.168.99.1/30']

    for sentence in s:
        return sentence

#    print("interfaces | services")
#    mydict = {}

#    for i in s:
#        interface = re.search(r"ge.{1,7}", i)
#        if "sampling" in i:
#            service = "sampling"
#            mydict.setdefault("router",{interface.group(): service})
#        else:
#            service = "None"
#        print(f"{interface.group()} | {service}")
#    if bool(mydict):
#        return mydict
#    return "None"


'''
interface_dict = {}
return("interfaces | services")
mydict ={}

s = __salt__['net.cli']('show configuration interfaces | display set', format='xml')['out']['show configuration interfaces | display set']

def netflow():

    for i in s:
            interface = re.search(r"ge.{1,7}", i)
            if "sampling" in i:
                service = "sampling"
                mydict.setdefault("router",{interface.group(): service})
            else:
                service = "None"
            print(f"{interface.group()} | {service}")
    if bool(mydict):
        return mydict
    return "None"

return(netflow)
'''
'''
def test():

    output_table1 = []
    output_table2 = []

    No_Word = ("This word was not found")
    interfaces = __salt__['net.cli']('show configuration interfaces | display set', format='xml')['out']['show configuration interfaces | display set']

    with open("/srv/salt/_modules/xxx.txt", "w") as file:
        file.write(interfaces)
    
    regex1 = re.compile(r'ge.{1,7}')
    regex2 = re.compile(r'sampling')
    match_reg1 = regex1.finditer(interfaces)
    match_reg2 = regex2.finditer(interfaces)

    if match_reg1:
        for match1 in match_reg1:
            output_table1.append(match1.group())

        with open("/srv/salt/_modules/table1.txt", "w") as file:
           for item in output_table1:
              file.write("%s\n" % item)

    if match_reg2:
        for match2 in match_reg2:
            output_table2.append(match2.group())

    return output_table1, output_table2, ("The original list : " + str(match_reg2))
'''
'''
    interfaces = __salt__['net.cli']('show configuration interfaces | display set', format='xml')['out']['show configuration interfaces | display set']

    with open("/srv/salt/_modules/xxx.txt", "w") as file:
        file.write(interfaces)
    
    pattern = re.findall(r'sampling', interfaces)
    pattern1 = re.findall(r'interfaces', interfaces)

    return pattern, pattern1
'''

'''
def test():

    interfaces = __salt__['net.cli']('show interfaces')['out']['show interfaces']

    with open("/srv/salt/_modules/xxx.txt", "w") as file:
        file.write(interfaces)

    return interfaces[0:5]
'''

'''
def wordcount(filename, listwords):

Word Counter from file already stored in some place
    
    try:
        file = open(filename, "r")
        read = file.readlines()
        file.close()
        for word in listwords:
            lower = word.lower()
            count = 0
            for sentance in read:
                line = sentance.split()
                for each in line:
                    line2 = each.lower()
                    line2 = line2.strip("!@#$%^&*()=+")
                    if lower == line2:
                        count += 1
            print(lower, ":", count)
    except FileExistsError:
        print("The file does not exist")

wordcount("/srv/salt/_modules/xxx.txt", ['sample-input,'])   
'''