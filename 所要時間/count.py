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

print(count_time('所要時間/4章の所要時間.txt')/60.)
