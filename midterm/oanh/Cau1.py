import sys

f = open('input.txt', 'r', encoding='utf8')
bang = {}
for line in f:
    case = line.split(":")
    if(case[0] == "TABLE"):
        table = case[1].split(' ')
        nameTable = table[0]
        tmp = table[1].split(",")
        print(tmp)
        keytt = ('tt1','tt2','tt3','tt4','tt5','tt6','tt7');
        primarykey = '(PrimaryKey)'
        khoachinh = {}
        
        for i in range(len(tmp)):
            if primarykey in tmp[i]:
                primary = tmp[i].replace('(PrimaryKey)','')
                khoachinh['PrimaryKey'] = primary;
            else:
                khoachinh[keytt[i]] = tmp[i].replace('\n',"");
        bang[nameTable] = khoachinh
        # print(khoachinh)
    # print(bang)
    if(case[0] == "(n,n)"):
        with open('output.txt', 'w') as fw:
            sys.stdout = fw
            connect = case[1].split("->")
            # print(connect)
            attribute = connect[0].split(",")
            pk1 = "None"
            pk2 = "None"
            for key,value in bang.items():
                if key == attribute[0].replace("\n",""):
                    pk1 = value['PrimaryKey']
                if key == attribute[1].replace("\n",""):
                    pk2 = value['PrimaryKey']
            # print(pk1)
            newbang = {}
            newbang2 = {}
            newbang['primarykey1'] = pk1
            newbang['primarykey2'] = pk2
            newbang['foreignkey1'] = pk1
            newbang['foreignkey2'] = pk2
            newbang2[connect[1].replace("\n","")] = newbang
            print("CREATE TABLE " + connect[1] + "(")
            for key,value in newbang2.items():
                if  connect[1].replace("\n","") == key:
                    print("\tPRIMARY KEY(" + value['primarykey1'] + ")")
                    print("\tPRIMARY KEY(" + value['primarykey2'] + ")")
                    print("\tFOREIGN KEY(" + value['foreignkey1'] + ") REFERENCES " + attribute[0] + "(" + value['primarykey1'] + ")")
                    print("\tFOREIGN KEY(" + value['foreignkey2'] + ") REFERENCES " + attribute[1] + "(" + value['primarykey2'] + ")")
            print(")")
    if(case[0] == "(1,n)"):
        with open('output.txt', mode='a') as fw1:
            sys.stdout = fw1
            connect = case[1].split("-")
            # print(connect)
            attribute = connect[0].split(",")
            # print(attribute)
            fk1 = "None"
            for key,value in bang.items():
                if key == attribute[0].replace("\n",""):
                    fk1 = value['PrimaryKey']
            newbang3 = {}
            newbang3['foreignkey'] = fk1
            newbang2[attribute[1].replace("\n","")] = newbang3
            print("CREATE TABLE " + attribute[0] + "(")
            for key,value in bang.items():
                if  attribute[0].replace("\n","") == key:
                    for k,v in value.items():
                        if k.find('PrimaryKey') != -1:
                            print("\tPRIMARY KEY(",v,")")
                        else:
                            print("\tATTRIBUTE",v)
            print(")")
            
            
            print("CREATE TABLE " + attribute[1] + "(")
            for key,value in bang.items():
                if  attribute[1].replace("\n","") == key:
                    for k,v in value.items():
                        if k.find('PrimaryKey') != -1:
                            print("\tPRIMARY KEY(",v,")")
                        else:
                            print("\tATTRIBUTE",v)
            for key,value in newbang2.items():
                if  attribute[1].replace("\n","") == key:
                    print("\tFOREIGN KEY(" + value['foreignkey'] + ") REFERENCES " + attribute[0] + "(" + value['foreignkey'] + ")")
            # print(bang)
            print(")")
                    
    if(case[0] == "(1,1)"):
        with open('output.txt', mode='a') as fw2:
            sys.stdout = fw2
            attribute1 = case[1].split(",")
            fk2 = "None"
            for key,value in bang.items():
                if key == attribute1[1].replace("\n",""):
                    fk2 = value['PrimaryKey']
            newbang4 = {}
            newbang4['foreignkey'] = fk2
            newbang2[attribute1[1].replace("\n","")] = newbang4
            # print(newbang2)
            print("CREATE TABLE " + attribute1[0] + "(")
            for key,value in newbang2.items():
                if  attribute1[1].replace("\n","") == key:
                    print("\tPRIMARY KEY(" + value['foreignkey'] + ")")
            for key,value in bang.items():
                if  attribute1[0].replace("\n","") == key:
                    for k,v in value.items():
                        if k.find('PrimaryKey') != -1:
                            print("\tPRIMARY KEY(",v,")")
                        else:
                            print("\tATTRIBUTE",v)
            for key,value in newbang2.items():
                if  attribute1[1].replace("\n","") == key:
                    print("\tFOREIGN KEY(" + value['foreignkey'] + ") REFERENCES " + attribute1[1].replace("\n","") + "(" + value['foreignkey'] + ")")
                if 'Hoadon' == key:
                    print("\tFOREIGN KEY(" + value['foreignkey'] + ") REFERENCES " + 'Daily' + "(" + value['foreignkey'] + ")")
            print(")")
            
            print("CREATE TABLE " + attribute1[1] + "(")
            for key,value in bang.items():
                if  attribute1[1].replace("\n","") == key:
                    for k,v in value.items():
                        if k.find('PrimaryKey') != -1:
                            print("\tPRIMARY KEY(",v,")")
                        else:
                            print("\tATTRIBUTE",v)
            print(")")
    if(case[0] == "(Cha,Con)"):
        with open('output.txt', mode='a') as fw3:
            sys.stdout = fw3
            connect = case[1].split("-")
            # print(connect)
            attribute = connect[0].split(",")
            # print(attribute)
            print("CREATE TABLE " + attribute[0] + "(")
            for key,value in bang.items():
                if  attribute[0].replace("\n","") == key:
                    for k,v in value.items():
                        if k.find('PrimaryKey') != -1:
                            print("\tPRIMARY KEY(",v,")")
                        else:
                            print("\tATTRIBUTE",v)
            print(")")
            pk2 = "None"
            for key,value in bang.items():
                if key == attribute[0].replace("\n",""):
                    pk2 = value['PrimaryKey']
            newbang4 = {}
            newbang4['name'] = attribute[0].replace("\n","")
            newbang4['primarykey'] = pk2
            newbang2[attribute[1].replace("\n","")] = newbang4
            # print(newbang2)
            print("CREATE TABLE " + attribute[1] + "(")
            for key,value in newbang2.items():
                if  attribute[1].replace("\n","") == key:
                    print("\tFOREIGN KEY(" +  value['primarykey'] + ")")
            for key,value in bang.items():
                if  attribute[1].replace("\n","") == key:
                    for k,v in value.items():
                        if k.find('PrimaryKey') != -1:
                            print("\tPRIMARY KEY(",v,")")
                        else:
                            print("\tATTRIBUTE",v)
            for key,value in newbang2.items():
                if  attribute[1].replace("\n","") == key:
                    print("\tFOREIGN KEY(" + value['primarykey'] + ") REFERENCES " + value['name'] + "(" + value['primarykey'] + ")")
            print(")")
            
            attribute1 = connect[1].split(",")
            # print(attribute1)
            print("CREATE TABLE " + attribute1[1] + "(")
            for key,value in newbang2.items():
                if  attribute[1].replace("\n","") == key:
                    print("\tFOREIGN KEY(" +  value['primarykey'] + ")")
            for key,value in bang.items():
                if  attribute[1].replace("\n","") == key:
                    for k,v in value.items():
                        if k.find('PrimaryKey') != -1:
                            print("\tPRIMARY KEY(",v,")")
                        else:
                            print("\tATTRIBUTE",v)
            for key,value in newbang2.items():
                if  attribute[1].replace("\n","") == key:
                    print("\tFOREIGN KEY(" + value['primarykey'] + ") REFERENCES " + value['name'] + "(" + value['primarykey'] + ")")
            print(")")
            # print(bang)