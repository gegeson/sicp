#lang debug racket
(require sicp)
(require racket/trace)
;写経。
;http://uents.hatenablog.com/entry/sicp/029-ch3.3.1.md
;checked-pair?について。
;まず、パンくずリストが空っぽなら、
;新しく今のリストを追加する。
;そして、falseを返す。
;空っぽじゃないなら、
;パンくずリストの先頭に一致するリストがあるかをチェック。
;あるならtrue、無いならcdrを検査。

;count-procについて。
;まず、pair?じゃないなら0を返す。
;もう既にパンくずリストの中にあるかどうかをchecked-lstでチェック
;あるなら0を返す。
;無いなら、パンくずリストに追加しつつ、car, cdrを検索。
;今のリストの数は一つなので、今のリストを1として、
;(1 + (count-proc (car x)) (count-proc (cdr x)))
;とすればよい。
;シンプル！

(define (count-pairs x)
  (let ((bred-crumbs nil))
    (define (checked-pair? x)
      (define (iter crumbs)
        (if (null? crumbs)
          (begin
           (set! bred-crumbs
             (append bred-crumbs (list x)))
           false)
          (if (eq? x (car crumbs))
            true
            (iter (cdr crumbs)))
          ))
      (iter bred-crumbs))
    (define (count-proc x)
      (cond
        [(not (pair? x)) 0]
        [(checked-pair? x) 0]
        [else
          (+ (count-proc (car x))
            (count-proc (cdr x))
            1)
        ])
      )
    (count-proc x)
    ))



(define a1 (cons 'a 'a))
(define a2 (cons a1 a1))
(define a3 (cons 'a a2))
(define a4 (cons a2 a2))
(count-pairs a1)

(count-pairs a4)
(newline)
(define a5 (cons a2 a1))
(display "a5 ")
(count-pairs a5)
(newline)
(define a6 (cons a1 nil))
(define a7 (cons a6 a1))
(count-pairs a7)
(newline)
(define a8 (cons 'a (cons 'b (cons 'c nil))))
(count-pairs a8)
