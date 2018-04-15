20:31->20:53
20:55->21:10
うおー
反復再帰（末尾再帰）と普通の再帰の違いが明らかになる回

>"再帰計算のすべてが、部分問題を 解く間に変更されるレジスタの元の値を必要とするわけではないからです (練 習問題 5.4参照)。"
これの例はすぐ思い浮かんだ。
リストの長さを調べる関数なんかがそうだ。
常に1を足せばいいだけだから。

二重再帰は考えてもわかる気配が全くせず、イライラが募るばかりだったので理解をスキップ

21:56->22:40
読める気がしてきたので超ざっくり読んだ
前より読めたがやっぱり読み切れはしない
超ざっくり読んだ限りでは素のSchemeコードと同じことやってるんだろうなとわかる
まずfib(n-2)をスタックに積みつつfib(n-1)の再帰をどんどん掘り下げていって、
行く所まで行ったらfib(n-2)の方を掘り下げる
んでfib(n-2)も正体はfibだから同じように左から掘り下げていくのが始まる
スタックは掘り下げ開始ごとに積まれていく
めっちゃ効率悪いなということが改めてわかる

;;FIGURE 5.12
(controller
   (assign continue (label fib-done))
 fib-loop
   (test (op <) (reg n) (const 2))
   (branch (label immediate-answer))
   ;; set up to compute Fib(n-1)
   (save continue)
   (assign continue (label afterfib-n-1))
   (save n)                           ; save old value of n
   (assign n (op -) (reg n) (const 1)); clobber n to n-1
   (goto (label fib-loop))            ; perform recursive call
 afterfib-n-1                         ; upon return, val contains Fib(n-1)
   (restore n)
   ;; set up to compute Fib(n-2)
   (assign n (op -) (reg n) (const 2))
   (assign continue (label afterfib-n-2))
   (save val)                         ; save Fib(n-1)
   (goto (label fib-loop))
 afterfib-n-2                         ; upon return, val contains Fib(n-2)
   (assign n (reg val))               ; n now contains Fib(n-2)
   (restore val)                      ; val now contains Fib(n-1)
   (restore continue)
   (assign val                        ; Fib(n-1)+Fib(n-2)
           (op +) (reg val) (reg n))
   (goto (reg continue))              ; return to caller, answer is in val
 immediate-answer
   (assign val (reg n))               ; base case: Fib(n)=n
   (goto (reg continue))
 fib-done)
