14:07->14:24

(define (require p)
  (if (not p) (amb)))

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
     (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))
---
結局、非決定性計算は解の集合を探索して当てはまらなかったら別を探す、
ということをやっているに過ぎないので、
早くに多くの可能性を切り捨てる事が出来るなら確実に速くなると思う。
（追記:当たり前すぎて見落としてたが、解そのものには明らかに影響しない。）
いい例が思い浮かばないけど、概念的には明らかだと思う。
---
というわけで、より速いプログラムを考えなくてはいけない。
---
「より多くの可能性を切り捨てる」という意味では、
以下はただ一点だけを切り捨てているから、先にするのはよくなさそう。
(require (not (= baker 5)))
(require (not (= cooper 1)))
(require (not (= fletcher 5)))
(require (not (= fletcher 1)))
---
一方、この4つはかなり多くの可能性を切り捨ててると思う。
(require
 (distinct? (list baker cooper fletcher miller smith)))
(require (> miller cooper))
(require (not (= (abs (- smith fletcher)) 1)))
(require (not (= (abs (- fletcher cooper)) 1)))
---
これは、やや処理に時間がかかるけど、
5^5通りある内一つ以上が重なる事をすべて除外してるから、かなり節約になるはず。
(require
 (distinct? (list baker cooper fletcher miller smith)))
---
これはmiller copperの組み合わせの 5*5 = 25 が 4+3+2+1 = 10 になる。（これ単体でフィルターかけた場合）
(require (> miller cooper))
---
これはsmith, fletcherの組み合わせ 5*5 = 25 から
(5, 4), (4, 5), (4, 3), (3, 4), (3, 2), (2, 3), (2, 1), (1, 2)
この8通りを抜いて17通りになる（これ単体でフィルターかけた場合）
(require (not (= (abs (- smith fletcher)) 1)))
---
こちらも同様。
(require (not (= (abs (- fletcher cooper)) 1)))
---
これらを踏まえると、この順序が良いと思う。
どれくらい速くなってるかはよくわからない。
どう調べればいいんだろう。
まあいいか。
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
        (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5))
        (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
     (distinct? (list baker cooper fletcher miller smith)))
     (require (> miller cooper))
     (require (not (= (abs (- smith fletcher)) 1)))
     (require (not (= (abs (- fletcher cooper)) 1)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))
