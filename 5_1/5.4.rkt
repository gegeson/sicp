21:11->21:13
22:04->22:15
22:25->22:33
---
例のコピペ
---
;;FIGURE 5.11
(controller
   (assign continue (label fact-done))     ; set up final return address
 fact-loop
   (test (op =) (reg n) (const 1))
   (branch (label base-case))
   ;; Set up for the recursive call by saving n and continue.
   ;; Set up continue so that the computation will continue
   ;; at after-fact when the subroutine returns.
   (save continue)
   (save n)
   (assign n (op -) (reg n) (const 1))
   (assign continue (label after-fact))
   (goto (label fact-loop))
 after-fact
   (restore n)
   (restore continue)
   (assign val (op *) (reg n) (reg val))   ; val now contains n(n-1)!
   (goto (reg continue))                   ; return to caller
 base-case
   (assign val (const 1))                  ; base case: 1!=1
   (goto (reg continue))                   ; return to caller
 fact-done)
---
(define (expt b n)
 (if (= n 0)
     1
     (* b (expt b (- n 1)))))
---
ここから解答
---
学ぶは真似ぶ。
上のfactを真似る。
今回はnをスタックに積む必要はないな
データパス図は苦手なのでパス。
図で考えるのがそもそも苦手だと気付いた。コードのほうがわかりやすい
---
ネットで答え見たら間違えてる人みっけー。nはスタックに積まなくていいのに積んでる。
(assing b (op read))
(assing n (op read))
などの初期化が無かったのを除けば合ってる
---
(controller
    (assign continue (label expt-done))
  expt-loop
    (test (op =) (reg n) (const 0))
    (branch (label base-case))
    (save continue)
    (assign continue (label after-expt))
    (assign (op -) (reg n) (const 1))
    (goto (label expt-loop))
  after-expt
    (restore continue)
    (assign val (op *) (reg b) (reg val))
    (goto (reg continue))
  base-case
    (assign val (const 1))
    (goto (reg continue))
    expt-done)
---
次はこっち。
(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
        product
        (expt-iter (- counter 1) (* b product))))
  (expt-iter n 1))

スタック無しで行ける
これもOK
(controller
   (assign (reg c) (reg n))
   (assign (reg p) (const 1))
 test-expt
   (test (op =) (reg c) (const 0))
   (branch (label expt-done))
   (assign (reg c) (op -) (reg c) (const 1))
   (assign (reg p) (op *) (reg b) (reg p))
   (goto (label test-expt))
 expt-done)
