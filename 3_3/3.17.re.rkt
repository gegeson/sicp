#lang debug racket
(require sicp)
(require racket/trace)
;12:06->13:39
;3ポモドーロ
;13:39->14:05
;+1ポモドーロ
;以下のa5で3にならず2になる理由にずっと悩んでいたが、やっと判明。
;最初の時点でリストに加えてしまうせいで、
;一番下でもう一度出てきた時にもう遭遇済みと判定している。
;そのせいで、一番上と二段目しかリストを探索せず、
;しかもそれぞれ+1としかしていないから2が出力される。
;うまくいかない理由がわかったので、改善案を考える。
;改善verがcount-pairs3である。
;こんどはa7が3になるべきなのに4になってこける。
;原因判明。そして完成。
;条件節を
;(not (has (car x) lst))
;というふうにしたら行けた。よく考えたらこれと逆とは排他的でない。
;cdrを持つがcarも持つ、という事がありうるのだ。

(define (count-pairs1 x)
  (if (not (pair? x))
    0
    (+ (count-pairs1 (car x))
       (count-pairs1 (cdr x))
       1)))
(define (has a lst)
  ;(printf "lst is ~a\n" lst)
  (cond
    [(null? lst) #f]
    [(eq? a (car lst)) #t]
    [else (has a (cdr lst))])
  )
(define (count-pairs3 x)
  (define lst nil)
    (define (sub x)
      (cond
        [(not (pair? x)) 0]
        [(and (has (car x) lst) (has (cdr x) lst))
         0]
         [(not (has (car x) lst))
          (begin (set! lst (cons (car x) lst))
                ;(printf "lst ~a \n " lst)
                 (+ 1 (sub (car x))))]
        [(not (has (cdr x) lst))
         (begin (set! lst (cons (cdr x) lst))
                ;(printf "lst ~a \n" lst)
                (+ 1 (sub (cdr x))))]
        [(eq? (car x) (cdr x))
         (begin (set! lst (cons (car x) lst))
                (+ (sub (car x)) (sub (cdr x)) 1))
         ]
        [else
          (begin (set! lst (cons (car x) (cons (cdr x) lst)))
          ; (printf "lst ~a \n" lst)
           (+ (sub (car x)) (sub (cdr x)) 2))]
        ))
    (sub x)
    )

(define a1 (cons 'a 'a))
(define a2 (cons a1 a1))
(define a3 (cons 'a a2))
(define a4 (cons a2 a2))
(count-pairs3 a1)

(count-pairs1 a4)
(count-pairs3 a4)
(newline)
(define a5 (cons a2 a1))
(display "a5 ")
(count-pairs1 a5)
(count-pairs3 a5)
(newline)
(define a6 (cons a1 nil))
(define a7 (cons a6 a1))
(count-pairs1 a7)
(count-pairs3 a7)
(newline)
(define a8 (cons 'a (cons 'b (cons 'c nil))))
(count-pairs1 a8)
(count-pairs3 a8)
