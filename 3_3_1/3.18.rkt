#lang debug racket
(require sicp)
(require racket/trace)
;5m+5m+30m
;16:27->16:39
;解答を見たら、carがループするケースを考慮していなかった模様
;あと、ペアの同一性で判断するべきなのに、シンボルの同一性で判断していた。
;そのせいで、'(a a a)とかもループになってしまう。
;3章入ってから問題自力で解けない事が多くなってきたな〜
;まあ理解できればそれでよし

;模範解答
;http://uents.hatenablog.com/entry/sicp/029-ch3.3.1.md
;ここより拝借。写経。
;シンボルで判断するんじゃなくペアで判断する。
;まあ、eq?はペアのポインタの同一性で判断するし当たり前
;そしてペアで判断するならl4が#fになるのも必然か。
;これを踏まえて作り直してみよう。（3.18.re.rktにて）
(define (cycle-list? x)
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
            (iter (cdr crumbs)))))
            (memq x bred-crumbs))
;(iter bred-crumbs))
    (define (check-proc x)
      (cond ((not (pair? x)) false)
        ((checked-pair? x) true)
        (else (check-proc (cdr x)))
        ))
    (check-proc x)))

(define (has a lst)
  (cond
    [(null? lst) #f]
    [(eq? a (car lst)) #t]
    [else (has a (cdr lst))])
  )

(define (cycle-list lst)
  (define checked_lst nil)
  (define (check-sub lst)
    (cond
      [(not (pair? lst)) #f]
      [(has (car lst) checked_lst)
       #t]
      [else
      (begin (set! checked_lst (cons (car lst) checked_lst)) (or (check-sub (car lst))　(check-sub (cdr lst))))
       ]
      )
    )
  (check-sub lst)
  )
(define (last-pair x)
  (if (null? (cdr x))
      x
    (last-pair (cdr x)))
  )
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define z (make-cycle (list 'a 'b 'c)))
(display (cycle-list z)) ;#t
(newline)
(display (cycle-list (list 'a 'b 'c))) ;#f
(newline)
(display (cycle-list nil)) ;#f
(newline)
(display (cycle-list (cons z '(1 2 3)))) ;#t
(newline)
(display (cycle-list (cons '(1 2 3) z))) ;#t
(newline)
(display (cycle-list (list 'a 'a 'a))) ;#fになるはずが#t！
(newline)

;不安なのでテストデータ拝借
;https://wizardbook.wordpress.com/2010/12/16/exercise-3-18/
;;4が#fになるはずが#tになっている。
(define l1 (list 'a 'b 'c))
(define l2 (list 'a 'b 'c))
(set-cdr! (cdr (cdr l2)) l2)
(define l3 (list 'a 'b 'c 'd 'e))
(set-cdr! (cdddr l3) (cdr l3))
(define l4 (list 'a 'b 'c 'd 'e))
(set-car! (cdddr l4) (cddr l4))
(printf "~a, ~a, ~a, ~a, ~a \n" l4 (cadr l4) (caddr l4) (cadddr l4) (car (cddddr l4)))
(define l5 (cadddr l4))
(printf "~a, ~a, ~a, ~a \n" l5 (car l5) (cadr l5) (caddr l5))
(define l6 (cadr l5))
(printf "~a, ~a, ~a, ~a \n" l6 (car l6) (cadr l6) (caddr l6))
;l4, 循環はしてないけど無限再帰リストだし…ループで良いんじゃない？
(cycle-list l1)
;#f

(cycle-list l2)
;#t

(cycle-list l3)
;#t

(cycle-list l4)
;#f
