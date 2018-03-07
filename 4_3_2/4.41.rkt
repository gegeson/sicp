19:27->19:56

きのこる庭より
http://kinokoru.jp/archives/711
4.41 ★★★ (順列の生成には permutations基本手続きが使える。あとはfilter)

大ヒントじゃん。
Racketにこんなのがあった。
> (permutations (list 1 2 3))
'((1 2 3) (2 1 3) (1 3 2) (3 1 2) (2 3 1) (3 2 1))
これで生成してフィルターで終了する。
順列生成も自力でやろうとしたが、ちょっと思いつかないのでパス。

なんか工場作業みたいだな…
(define (baker result)
  (list-ref result 0))
(define (cooper  result)
  (list-ref result 1))
(define (fletcher result)
  (list-ref result 2))
(define (miller result)
  (list-ref result 3))
(define (smith result)
  (list-ref result 4))

(define (multiple-dwelling)
  (let* ((all-possibilities (permutations (list 1 2 3 4 5)))
         (filtered1 (filter
                   (lambda (result) (not (= (baker result) 5)))
                   all-possibilities))
         (filtered2 (filter
                   (lambda (result) (not (= (cooper result) 1)))
                   filtered1))
         (filtered3 (filter
                   (lambda (result) (and (not (= (fletcher result) 1)) (not (= (fletcher result) 5))))
                  filtered2))
         (filtered4 (filter
                   (lambda (result) (> (miller result) (cooper result)))
                   filtered3))
         (filtered5 (filter
                     (lambda (result) (not (= (abs (- (smith result) (fletcher result))) 1)))
                     filtered4))
         (filtered6 (filter
                      (lambda (result) (not (= (abs (- (fletcher result) (cooper result))) 1)))
                      filtered5)))
     filtered6
    )
  )

>(multiple-dwelling)
'((3 2 4 5 1))

へいお待ち！
達成感無いなあ。他の人の解答見てみよう
---
http://www.serendip.ws/archives/2456
なるほど！一個作っておしまいか。賢い。上を行かれた。。
こっちのほうが明らかに探索回数少ないはず。
ただ、これだと重複はありえないからdistinct?は要らなくないか？
→うん無しでも動く動く。
(define (multiple-dwelling lis)
  (let ((baker (car lis))
        (cooper (cadr lis))
        (fletcher (caddr lis))
        (miller (cadddr lis))
        (smith (cadddr (cdr lis))))
       (and (distinct? (list baker cooper fletcher miller smith))
            (not (= baker 5))
            (not (= cooper 1))
            (not (= fletcher 5))
            (not (= fletcher 1))
            (> miller cooper)
            (not (= (abs (- smith fletcher)) 1))
            (not (= (abs (- fletcher cooper)) 1)))))

(define (distinct? items)
  (cond ((null? items) #t)
        ((null? (cdr items)) #t)
        ((member (car items) (cdr items)) #f)
        (else (distinct? (cdr items)))))

(filter multiple-dwelling (permutations '(1 2 3 4 5)))
gosh> ((3 2 4 5 1))
---
