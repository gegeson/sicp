#lang debug racket
(require sicp)
(require racket/trace)

;パンくずリストをnilで初期化
;チェック関数にて
;リストがパンくずリストにすでにあるかをチェック。
;無いなら追加して#f,あるなら#tを返す。
;
;ループ関数にて
;ペアじゃないなら0,
;訪問済みなら0を返す。
;訪問済みじゃないなら、
; (1+ (count-proc (car x)) (count-proc (cdr x)))

;出来たー。ついでに写経元のプログラムの無駄にも気づけた。

(define (count-pairs x)
  (define encounterd nil)
  (define (check-pair x)
      (if (memq x encounterd)
        #t
        (begin (set! encounterd (cons x encounterd)) #f)
        )
    )
  (define (count-proc x)
    (cond
      [(not (pair? x)) 0]
      [(check-pair x) 0]
      [else
       (+ 1 (count-proc (car x)) (count-proc (cdr x)))
       ]
      )
    )
  (count-proc x)
  )

(define a1 (cons 'a 'a))
(define a2 (cons a1 a1))
(define a3 (cons 'a a2))
(define a4 (cons a2 a2))
(count-pairs a1)
(count-pairs a2)
(count-pairs a3)
(count-pairs a4)
(newline)
(define a5 (cons a2 a1))
(count-pairs a5)
(newline)
(define a6 (cons a1 nil))
(define a7 (cons a6 a1))
(count-pairs a7)
(newline)
(define a8 (cons 'a (cons 'b (cons 'c nil))))
(count-pairs a8)
