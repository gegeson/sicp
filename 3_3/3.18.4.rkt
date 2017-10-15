#lang debug racket
(require sicp)
(require racket/trace)

;has-circulate?は訪問済みかどうかを調べ、
;訪問済みなら#tを、
;訪問済みでないならwalksリストに追加し#fを返す。
;circulate?-iterは、ペアでないなら#f,
;ペアであるならcarが訪問済みかをチェックした後、cdrに進む。
;ん？これ、間違ってるじゃん(´・ω・｀)

;(display (circulate? (cons z '(1 2 3)))) ;#f（循環リストの定義上これは#fで正しい。）
;(newline)
;(display (circulate? (list 'a 'a 'a)))
;明らかに#fになるべきはずが#tになっている
;(newline)
;手直しして次に進むぞ。

(define (circulate? items)
  (define walks nil)
  (define (has-circulate? x)
    (if (memq x walks)
      #t
      (begin (set! walks (cons x walks)) #f)))
  (define (circulate?-iter i)
    (if (not (pair? i))
      #f
      (if (begin (printf "walks ~a\n" walks)
                 (has-circulate? (car i)))
        #t
        (circulate?-iter (cdr i)))))
  (circulate?-iter items))

(define (last-pair x)
  (if (null? (cdr x))
      x
    (last-pair (cdr x)))
  )
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
(define z (make-cycle (list 'a 'b 'c)))
;(display (circulate? z)) ;#t
;(newline)
;(display (circulate? (list 'a 'b 'c))) ;#f
;(newline)
;(display (circulate? nil)) ;#f
;(newline)
;(display (circulate? (cons z '(1 2 3)))) ;#f（循環リストの定義上これは#fで正しい。）
;(newline)
;(display (circulate? (cons '(1 2 3) z))) ;#t
;(newline)
(display (circulate? (list 'a 'a 'a))) ;明らかに#fになるべきが#tになっている
(newline)
(newline)

(define l1 (list 'a 'b 'c))
(define l2 (list 'a 'b 'c))
(set-cdr! (cdr (cdr l2)) l2)
(define l3 (list 'a 'b 'c 'd 'e))
(set-cdr! (cdddr l3) (cdr l3))
(define l4 (list 'a 'b 'c 'd 'e))
(set-car! (cdddr l4) (cddr l4))
;
;(circulate? l1)
;;#f
;
;(circulate? l2)
;;#t
;
;(circulate? l3)
;;#t
;
;(circulate? l4)
;;#f
