9:06->9:18

1. 任意のリストyについて、空リストとyをappendするとyになる。
2. 任意のu,v,y,zについて、vとyをappendするとzになるならば、
   (cons u v)とyをappendすると(cons u z)になる。59
---
(append v y) = z
ならば
(append (cons u v) y) = (cons u z)
---
(cons (car x) (append (cdr x) y))
これを言い換えただけかな
v が (cdr x) 、 y が y
(append (cdr x) y)が z
u が (car x)
