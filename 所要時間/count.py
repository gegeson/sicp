# coding:utf-8
import re

def count_time(filename):
    file = open(filename, 'r')  #読み込みモードでオープン
    file = file.readlines()     #readlinesでリストとして読み込む

    result_lst = []
    pattern2 = r"\d+m"
    for line in file:
        m1 = re.search(pattern2, line)
        if m1:
            m1str = line[m1.start():m1.end()-1]
            result_lst.append(int(m1str))

    sum = 0
    for i in result_lst:
        sum += i
    return sum
t1 = count_time('所要時間/1.txt')/60.
t2 = count_time('所要時間/1.2.txt')/60.
t3 = count_time('所要時間/2.txt')/60.
t4 = count_time('所要時間/3.txt')/60.
t5 = count_time('所要時間/4章の所要時間.txt')/60.
print(t1)
print(t2)
print(t3)
print(t4)
print(t5)
print(t1 + t2 + t3 + t4 + t5)
