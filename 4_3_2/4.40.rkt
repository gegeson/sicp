14:24->15:14

1. distinct?を外すとどうなるか
2. ほんとうに必要な枝刈りだけを行え

ということだと思う
「階が選択される前に」
というのは、多分、
bakerは5を持たないんだから5を削除しろ、とか、
require で大小関係で枝刈りする以前にデータ定義で枝刈りしろ、
ということなんじゃないか、と思う
---
1. はdistinct?外した後が多すぎて、数え切れない。
有り得る全パターンはいくつか？という意味なら、
同じでもいいなら5^5、相異なるなら5!か。
---
2.
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
こういうことでいいのか？と思いつつ
---
baker から 5、
cooperから1、
fletcherから1, 5を削除
---
miller > cooperを満たすため、
cooperから5, millerから1を削除
---
(define (multiple-dwelling2)
  (let ((baker (amb 1 2 3 4))
        (cooper (amb 2 3 4))
        (fletcher (amb 2 3 4))
        (miller (amb 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
     (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker)
          (list 'cooper cooper)
          (list 'fletcher fletcher)
          (list 'miller miller)
          (list 'smith smith))))
---
あと、distinct?について思いついたけど、
distinct?をなくすために、
bakerの値が選択されたらそれに応じで cooperからその値を引いておく、
なんていうテクニックが使えそうな気がする。
---
distinct?以外でもこの手法が使えることに気付いた。
しかし、汚い。
これでいいと信じて答えを見る。
---
(define (require p)
  (if (not p) (amb)))

(define (multiple-dwelling3)
  (let ((baker (amb 1 2 3 4)))
    (let ((cooper (amb 2 3 4)))
      (require (not (= baker cooper)))
      (let ((fletcher (amb 2 3 4)))
        (require (and (not (= baker fletcher)) (not (= cooper fletcher))
                      (not (= (abs (- fletcher cooper)) 1))))
        (let ((miller (amb 2 3 4 5)))
          (require (and (not (= baker miller)) (not (= cooper miller)) (not (= fletcher miller))
                        (> miller cooper)))
          (let ((smith (amb 1 2 3 4 5)))
            (require (and (not (= baker smith)) (not (= cooper smith)) (not (= fletcher smith)) (not (= miller smith))))
            (require (not (= (abs (- smith fletcher)) 1)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))))))
---
http://www.serendip.ws/archives/2451
なるほど。distinct? については完全に消し去る必要はなかったか。
考え方としては完全に合ってる。OKということにしよう。
---
一応distinct?を使ったバージョン
---
(define (multiple-dwelling4)
  (let ((baker (amb 1 2 3 4)))
    (let ((cooper (amb 2 3 4)))
      (require (distinct? (list baker cooper)))
      (let ((fletcher (amb 2 3 4)))
        (require (and (distinct? (list baker cooper fletcher))
                      (not (= (abs (- fletcher cooper)) 1))))
        (let ((miller (amb 2 3 4 5)))
          (require (and (distinct? (list baker cooper fletcher miller))
                        (> miller cooper)))
          (let ((smith (amb 1 2 3 4 5)))
            (require (distinct? (list baker cooper fletcher miller smith)))
            (require (not (= (abs (- smith fletcher)) 1)))
            (list (list 'baker baker)
                  (list 'cooper cooper)
                  (list 'fletcher fletcher)
                  (list 'miller miller)
                  (list 'smith smith))))))))
