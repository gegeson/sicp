
;テスト用関数定義  
(define (inc x) (+ x 1))
(define (dec x) (- x 1))
(define (plus a b)
 (if (= a 0)
     b
     (inc (plus (dec a) b))))

; traceを設定する
(use slib)
(require 'trace) 
(trace plus)
(set! debug:max-count 10)

;traceを出力する
(print (plus 4 5))


(define (length l) 
  (cond 
    ((null? (car l)) 0)
    (else
      (+ 1 (length (cdr l))))))
 
(print (length '(1 2 3)))
(define (length l)
  (cond 
    ((null? (car l)) 0)
    (else (+ 1 (length))) (cdr l))) 
(define (length l)
  (cond 
    (
     ))
  )
                    
  
                  
                           
                      

                  
  
  