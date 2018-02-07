; 8:18->8:21
こう？
(define (application? exp) (eq? (car exp) 'call))
(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))

いや、違った。

これを使用して
(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (application? exp) (tagged-list? exp 'call))

こうだな
