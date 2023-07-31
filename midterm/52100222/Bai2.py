# -*- coding: utf-8 -*-
from asyncore import write
from operator import index
import numpy as np
import re
import itertools
import collections
#Đọc file
f = open('input2.txt', 'r')
qa=f.readlines()
qa1=qa[1]
F=list(qa1.split(';'))

# X=input('Thuộc tính cần tìm bao đóng: (Nhập theo định dạng A,B,C,D,...)\n')
X = 'A,B'

le=[] #biến xuât hiện bên trái
ri=[] #biến xuất hiện bên phải
for i in F:
    le.append(i.split('->')[0])
    ri.append(i.split('->')[1])

# F là list của các phụ thuộc hàm
# X là thuộc tính người dùng nhập
def Closure(F,X):
    result=[]

    # Chuyễn xâu X thành list X tên input
    input=" ".join(X)
    input=input.split(',')

    # Bao đóng của các thuộc tính đầu vào là chính chúng
    for i in input:
        result.append(i)


    check=0
    while check!=len(F)*2: 
        for i in range(0,len(le)): # duyệt từng thuộc tính trong vế trái
            if(all(item in result for item in le[i].split(','))): # nếu chúng có trong tập bao đóng
                for i in ri[i]: # thêm thuộc tính bên phải tương ứng vào tập bao đóng
                    if(i!=','):
                        result.append(i)
        check+=1

    return(set(result)) # trả về kết quả kiểu set để loại bỏ phần tử trùng

print(Closure(F,list(X.split(' '))))

# TÌM BAO ĐÓNG

# List chứa toàn bộ thuộc tính
listUniqueInput = [i for i in qa[0] if i.isalpha()]


# TÌM N VÀ L
N=[]
for i in listUniqueInput:
    if i not in ''.join(ri).replace(',',''):
      N.append(i)
Lbe=[]
Lbe=Lbe+N
for i in listUniqueInput:
    if(i not in N and i not in ri):
        Lbe.append(i)

Laf=[]
for i in listUniqueInput:
    if(i not in Lbe):
        Laf.append(i)
keys = []
tempLaf=Laf
table=list(itertools.product({0,1},repeat=len(Laf)))
for i in range(0,len(table)):
    Laf=table[i]
    X=[]   
    key=[]
    for i in range(0,len(Laf)):
        if(Laf[i]!=0):
            X.append(tempLaf[i])
            X=X+N
    X=set(X)
    Xaf=list(','.join(list(X)).split(' '))

    # Nếu bao đóng của Xaf chứa các phần tử của listUniqueInput thì Xaf là khóa
    if (all(item in listUniqueInput for item in list(Closure(F, Xaf)))):
      keys.extend(Xaf)
# print(keys)
# Loại bỏ superkey

temp = [] # list chứa các tập cha của candidate keys
for i in range(len(keys)): # duyệt từng khóa
  for j in range(i+1, len(keys)): # và xét với các khóa còn lại
    if (all(item in keys[j] for item in keys[i])): # nếu khóa keys[i] là con của keys[j]
      temp.append(keys[j]) # thêm khóa keys[j] vào temp
# Tìm các phần tử chỉ có trong candidateKeys mà không có trong temp
candidateKeys = [item for item in keys if item not in temp]

print("Tất cả các khóa của lược đồ quan hệ là:")
print(candidateKeys)
# GHI FILE
file = open("output2.txt", "a")
for i in candidateKeys:
  key = "".join(i.split(','))
  file.write(key + "\n")
file.close()