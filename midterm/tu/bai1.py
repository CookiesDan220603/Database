import numpy as np
f=open('input.txt','r')
qa=f.readlines()
thucthe=qa[0].strip().split(';')
quanhe=qa[1].split(';')
def tachthuoctinh(a):
    khoavsthuoctinh=[]
    khoavsthuoctinh.append(a.split(':')[0])
    tt=a.split(':')[1]
    thuoctinh=tt.split(',')
    for i in range(0,len(thuoctinh)):
        khoavsthuoctinh.append(thuoctinh[i])
    return khoavsthuoctinh
def timkhoachinh(a):
    for i in range(0,len(a)):
        if(a[i][:3]=='PK.'):
            return a[i].split('.')[1]
def tachquanhe(a):
    qhevsthuoctinh=a.split(':')
    qhe=qhevsthuoctinh[0].split('-')
    thuoctinh=qhevsthuoctinh[1].split('-')
    return qhe,thuoctinh
def mohinhquanhe1n(a,b):
    b.append('FK.'+timkhoachinh(a))
def mohinhquanhe11(a,b):
    b.append('FK.'+timkhoachinh(a))
def mohinhquanhenn(a,b):
    c=[]
    c.append('PK.FK.'+timkhoachinh(a))
    c.append('PK.FK.'+timkhoachinh(b))
    return c
def mohinhquanhechacon(a,b):
    b.append('PK.FK.'+timkhoachinh(a))
def convertstr(a):
    r=a[0]+':'
    for i in range(1,len(a)):
        r=r+a[i]+','
    result = ','.join([s.strip() for s in r.split(',') if s.strip()!=''])
    return result
def timdatri(a):
    for i in range(0,len(a)):
        if(a[i][:3]=='DT.'):
            return a[i].split('.')[1]
listthucthe=[]
for i in range(0,len(thucthe)):
    listthucthe.append(tachthuoctinh(thucthe[i]))
quanhebang=[]
for i in range(0,len(quanhe)):
    x,y=tachquanhe(quanhe[i])
    if(x[0]=='1' and x[1]=='1'):
        for z in range(0,len(listthucthe)):
           if(y[0]==listthucthe[z][0]):
              a=z
           if(y[1]==listthucthe[z][0]):
              b=z
        mohinhquanhe11(listthucthe[a], listthucthe[b])
        bang11='1-1:'+listthucthe[a][0]+'-'+listthucthe[b][0]
        quanhebang.append(bang11)
    if(x[0]=='1' and x[1]=='n'):
        for z in range(0,len(listthucthe)):
           if(y[0]==listthucthe[z][0]):
              a=z
           if(y[1]==listthucthe[z][0]):
              b=z
        mohinhquanhe1n(listthucthe[a], listthucthe[b])
        bang1n='1-n:'+listthucthe[a][0]+'-'+listthucthe[b][0]
        quanhebang.append(bang1n)
    if(x[0]=='cha' and x[1]=='con'):
        for z in range(0,len(listthucthe)):
           if(y[0]==listthucthe[z][0]):
              a=z
           if(y[1]==listthucthe[z][0]):
              b=z
        mohinhquanhechacon(listthucthe[a], listthucthe[b])
        bang1n='cha-con:'+listthucthe[a][0]+'-'+listthucthe[b][0]
        quanhebang.append(bang1n)
    if(x[0]=='n' and x[1]=='n'):
        for z in range(0,len(listthucthe)):
           if(y[0]==listthucthe[z][0]):
              a=z
           if(y[1]==listthucthe[z][0]):
              b=z
        phu=[]
        tenphu=str(listthucthe[a][0])+'_'+str(listthucthe[b][0])
        phu.append(tenphu)
        phu.append(mohinhquanhenn(listthucthe[a], listthucthe[b]))
        phu=list(np.hstack(phu))
        listthucthe.append(phu)
        bang1n1='1-n:'+listthucthe[a][0]+'-'+phu[0]
        quanhebang.append(bang1n1)
        bang1n2='1-n:'+listthucthe[b][0]+'-'+phu[0]
        quanhebang.append(bang1n2)
for i in range(0,len(listthucthe)):
    if(timdatri(listthucthe[i])!=None):
        bangdatri=[]
        bangdatri.append('Table_'+str(timdatri(listthucthe[i])))
        bangdatri.append('PK.FK.'+str(timkhoachinh(listthucthe[i])))
        bangdatri.append('PK.'+str(timdatri(listthucthe[i])))
        bangdatri=np.hstack(bangdatri)
        listthucthe.append(bangdatri)
for i in range(0,len(listthucthe)):
    listthucthe[i]=convertstr(listthucthe[i])
wf = open('output.txt', 'w')
wf.write(str(listthucthe))
wf.writelines('\n')
wf.writelines(str(quanhebang))
f.close()
wf.close()

