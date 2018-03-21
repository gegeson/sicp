13:13->13:19
(assert! (rule (?x next-to ?y in (?x ?y . ?u))))

(assert! (rule (?x next-to ?y in (?v . ?z))
               (?x next-to ?y in ?z)))
---
(?x next-to ?y in (1 (2 3) 4))
1 (2 3)
(2 3) 4
4 nil
かな
→4 nilはなかった。
考えてみれば、(4 nil 他のなにか)の形にならなきゃダメだからありえないな
---
(?x next-to 1 in (2 1 3 1))

2 1
3 1
かな
→合ってた
