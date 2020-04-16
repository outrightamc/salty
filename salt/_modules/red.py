import salt.modules.network
import re
import json
from lxml import etree 
from tabulate import tabulate


def netflow():

    interfaces = __salt__['net.cli']('show configuration interfaces | display set', format='xml')['out']['show configuration interfaces | display set']

    with open("/srv/salt/_modules/xxx.txt", "w") as file:
        file.write(interfaces)
    
    pattern = re.findall(r'ge.{1,7}', interfaces)
    pattern1 = re.findall(r'dhcp', interfaces)

    return("The original list : " + str(pattern))


'''
def netflow():

    test1 = ['cinco', 'dos']
    test2 = ['nueve', 'siete']

    interfaces = __salt__['net.cli']('show configuration interfaces | display set', format='xml')['out']['show configuration interfaces | display set']

    with open("/srv/salt/_modules/xxx.txt", "w") as file:
        file.write(interfaces)
    
    regex2 = re.compile(r'sampling')
    match_reg2 = regex2.findall(interfaces)

    headers = ['value1', 'value2']
    return (tabulate(test1, headers=headers, tablefmt="orgtbl"))
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
        for match in match_reg1:
            output_table1.append(match.group())

        with open("/srv/salt/_modules/table1.txt", "w") as file:
           for item in output_table1:
              file.write("%s\n" % item)

    if match_reg2:
        for match2 in match_reg2:
            output_table2.append(match2.group())

    return("The original list : " + str(match_reg2))

    return output_table1, output_table2

    return tabulate(
        output_table1,
        headers=["value1", "value2", "value3"],
        tablefmt="orgtbl")
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