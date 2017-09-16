#lang racket/load
(require sicp)
(require racket/trace)

;4m+
;9:49->10:24

;題意がどうしても理解できず、いきなり答えを見た。
;どうやら、引数に型タグ付きを数を渡す、つまり
;(magnitude-part (make-complex-from-real-imag (make-scheme-number 4) (make-scheme-number 3)))
;こうやるとこれまではエラーが出てしまうが、
;その理由は型タグ付きの数でsquareとか出来ないからであり（magnitudeではsqrtを使う）
;逆に言えば型タグ付きの数でsquareやsqrt,sinなどが使えるようになれば上の式が動くようになる
;こちらを参照した
;http://uents.hatenablog.com/entry/sicp/024-ch2.5.2.md
;自分でも書いてみよう。（解答をチラチラ見ながら挑戦）

;cos, sin, atan, sqrt, square
;をscheme-number, rational, realのパッケージに実装すればいいだけ。
;一応出来た

(define (square z) (apply-generic 'square z))
(define (square-root z) (apply-generic 'square-root z))
(define (sine z) (apply-generic 'sine z))
(define (cosine z) (apply-generic 'cosine z))
(define (atang x y) (apply-generic 'atang  x y))

(define (is-numeric x)
  (cond
    ((and (not (pair? x))) (number? x) #t)
    ((not (pair? x)) #f)
    ((and (pair? x) (symbol? (car x))) #t)
    (else #f)
    ))


(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (cond
    ((number? datum) 'scheme-number)
    ((pair? datum) (car datum))
      (else (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
  ;(display "contents datum ")(display datum)(newline)
  (cond
    ((number? datum) datum)
    ((pair? datum)(cdr datum))
      (else (error "Bad tagged datum -- CONTENTS" datum))))


;;; 演算テーブルと型変換テーブルを別々で作成する

(define (put-table table key1 key2 item)
  (if (not (hash-has-key? table key1))
	  (hash-set! table key1 (make-hash))
	  true)
  (hash-set! (hash-ref table key1) key2 item))

(define (get-table table key1 key2)
  (define (not-found . msg)
;	(display msg (current-error-port))
;	(display "\n")
	false)
  (if (hash-has-key? table key1)
	  (if (hash-has-key? (hash-ref table key1) key2)
		  (hash-ref (hash-ref table key1) key2)
		  (not-found "Bad key -- KEY2" key2))
	  (not-found "Bad key -- KEY1" key1)))

(define *op-table* (make-hash))
(define (put op type item)
  (put-table *op-table* op type item))
(define (get op type)
  (get-table *op-table* op type))

(define *coercion-table* (make-hash))
(define (put-coercion type1 type2 item)
  (put-table *coercion-table* type1 type2 item))
(define (get-coercion type1 type2)
(get-table *coercion-table* type1 type2))
;;;; ---------------------------
;;;; type-tag system
;;;; ---------------------------

(define (attach-tag type-tag contents)
  (cons type-tag contents))

#|
(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))
|#

;;;; ---------------------------
;;;;  generic operators
;;;; ---------------------------


(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude-part z) (apply-generic 'magnitude-part z))
(define (angle-part z) (apply-generic 'angle-part z))

(define (numer r) (apply-generic 'numer r))
(define (denom r) (apply-generic 'denom r))

(define (equ? x y) (apply-generic 'equ? x y))
(define (zero? x) (apply-generic 'zero? x))


;;;; ---------------------------
;;;; rectangular and polar package
;;;; ---------------------------

(define (install-rectangular-package)
  ;; internal
  (define (real-part z)
	(car z))
  (define (imag-part z)
	(cdr z))
  (define (magnitude-part z)
  	(let ((x (real-part z))
  		  (y (imag-part z)))
  	  (square-root (add (square x) (square y)))))
  (define (angle-part z)
    (atang (imag-part z) (real-part z)))
  (define (make-from-real-imag x y)
	(cons x y))
  (define (make-from-mag-ang r a)
    (cons (* r (cosine a)) (* r (sine a))))

  ;; interface
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude-part '(rectangular) magnitude-part)
  (put 'angle-part '(rectangular) angle-part)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))

  'done)

(define (install-polar-package)
  ;; internal
  (define (magnitude-part z) (car z))
  (define (angle-part z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (mul (magnitude-part z) (cosine (angle-part z))))
  (define (imag-part z)
    (mul (magnitude-part z) (sine (angle-part z))))
  (define (make-from-real-imag x y)
    (cons (square-root (add (square x) (square y)))
          (atang y x)))

  ;; interface
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude-part '(polar) magnitude-part)
  (put 'angle-part '(polar) angle-part)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))

  'done)

;; constructors
(define (make-from-real-imag x y)
  ((get 'make-from-real-imag 'rectangular) x y))
(define (make-from-mag-ang r a)
  ((get 'make-from-mag-ang 'polar) r a))

(install-rectangular-package)
(install-polar-package)


;;;; ---------------------------
;;;; complex package
;;;; ---------------------------

(define (install-complex-package)
  ;; internal
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))
                         (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude-part z1) (magnitude-part z2))
                       (add (angle-part z1) (angle-part z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude-part z1) (magnitude-part z2))
                       (sub (angle-part z1) (angle-part z2))))
  (define (project z)
    (make-real (real-part z))
    )
  ;; interface
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'equ? '(complex complex)
       (lambda (x y)
               (and (equ? (real-part x) (real-part y)) (equ? (imag-part x) (imag-part y)))))
  (put 'zero? '(complex)
       (lambda (x)
               (and (= (real-part x) 0) (= (imag-part x) 0))))
  (put 'project '(complex) project)
  ;; ex 2.77
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude-part '(complex) magnitude-part)
  (put 'angle-part '(complex) angle-part)
  'done)

;; constructors
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))

(install-complex-package)


;;;; ---------------------------
;;;; rational package
;;;; ---------------------------

(define (install-rational-package)
  ;; internal
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  (define (sine x)
    (make-real (sin (/ (numer x) (denom x)))))
  (define (cosine x)
    (make-real (cos (/ (numer x) (denom x)))))
  (define (atang x)
    (make-real (atan (/ (numer x) (denom x)))))
  (define (square x)
    (make-real (/ (* (numer x) (numer x)) (* (denom x) (denom x)))))
  (define (square-root x)
    (make-real (/ (sqrt (numer x)) (sqrt (denom x)))))
  ;; interface
  (define (tag x) (attach-tag 'rational x))

  (define (raise-rat x)
  (make-real (/ (* (numer x) 1.0) (denom x))))

  (put 'numer 'rational
	   (lambda (r) (numer r)))
  (put 'denom 'rational
	   (lambda (r) (denom r)))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  (put 'equ? '(rational rational)
       (lambda (x y)
               (and (= (numer x) (numer y)) (= (denom x) (denom y)))))
  (put 'zero? '(rational)
       (lambda (x) (= (numer x) 0)))
  (put 'raise '(rational)
       (lambda (x) (raise-rat x)))
  (put 'project '(rational)
       (lambda (x) (round (/ (numer x) (denom x)))))
  (put 'sine '(rational) sine)
  (put 'cosine '(rational) cosine)
  (put 'atang '(rational rational) atang)
  (put 'square '(rational) square)
  (put 'square-root '(rational) square-root)
  'done)

;; constructor
(define (make-rational n d)
  ((get 'make 'rational) n d))

(install-rational-package)


;;;; ---------------------------
;;;; scheme number package
;;;; ---------------------------

(define (install-scheme-number-package)
  ;; interface
  (define (tag x) (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (tag (* x y))))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (tag (/ x y))))
  (put 'make 'scheme-number
       (lambda (x) (tag x)))
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y)))
  (put 'zero? '(scheme-number)
       (lambda (x) (= x 0)))
  (put 'raise '(scheme-number)
       (lambda (x) (make-rational x 1)))
  (put 'square '(scheme-number)
       (lambda (z) (tag (* z z))))
  (put 'square-root '(scheme-number)
       (lambda (z) (tag (sqrt z))))
  (put 'sine '(scheme-number)
       (lambda (z) (tag (sin z))))
  (put 'cosine '(scheme-number)
       (lambda (z) (tag (cos z))))
  (put 'atang '(scheme-number scheme-number)
      (lambda (x y) (tag (atan x y))))
  'done)

;; constructor
(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(install-scheme-number-package)




;; 実数算術演算パッケージ
(define (install-real-package)
  (define (tag x)
    (attach-tag 'real x))
  (put 'add '(real real)
       (lambda (x y) (tag (+ x y))))
  (put 'sub '(real real)
       (lambda (x y) (tag (- x y))))
  (put 'mul '(real real)
       (lambda (x y) (tag (* x y))))
  (put 'div '(real real)
       (lambda (x y) (tag (/ x y))))
  (put 'equ? '(real real)
       (lambda (x y) (= x y)))
  (put '=zero? '(real)
       (lambda (x) (= x 0.0)))
  (put 'make 'real
       (lambda (x) (tag x)))
  (put 'raise '(real)
       (lambda (x) (make-complex-from-real-imag x 0)))
  (put 'project '(real)
       (lambda (x) (make-rational (round (* 100 x)) 100)))
  (put 'square '(real)
       (lambda (z) (tag (* z z))))
  (put 'square-root '(real)
       (lambda (z) (tag (sqrt z))))
  (put 'sine '(real)
       (lambda (z) (tag (sin z))))
  (put 'cosine '(real)
       (lambda (z) (tag (cos z))))
  (put 'atang '(real real)
       (lambda (x y) (tag (atan x y))))
'done)

(define (make-real n)
  ((get 'make 'real) n))

(install-real-package)

(define (raise x)
(let ((proc (get 'raise (list (type-tag x)))))
  (if proc
      (proc (contents x))
      x)))
(define (project x)
  (let ((proc (get 'project (list (type-tag x)))))
    (if proc
        (proc (contents x))
        x)))

(define (project-n a n)
    (cond
        ((equal? (type-tag a) 'scheme-number) a)
        ((= n 0) a)
        (else (project-n (project a) (- n 1)))
      )
)
(define (raise-n a n)
  (cond
    ((equal? (type-tag a) 'complex) a)
    ((= n 0) a)
    (else (raise-n (raise a) (- n 1)))
  ))

(define (drop a)
  (define (drop-iter a n result)
        (let ((n-down (project-n a n)))
          (let ((n-back (raise-n n-down n)))
            (cond
                ((equ? a n-back)
                  (if (equal? (type-tag n-down) 'scheme-number)
                      n-down
                    (drop-iter a (+ n 1) (cons n-down result))))
                 (else
                  (if (= n 1)
                    a
                    (car result))
                  )
              )
          )
      )
    )
  (cond
    ((number? a) a)
    ((not (pair? a)) a)
    ((equal? (car a) 'scheme-number) a)
    ((equal? (car a) 'rational) (drop-iter a 1 nil))
    ((equal? (car a) 'real) (drop-iter a 1 nil))
    ((equal? (car a) 'complex) (drop-iter a 1 nil))
    (else a))
)

;可変長でも対応可能になる
(define (apply-generic op . args)
  ;(display "apply-generic ")(display op)(display " ")(display args)(newline)
  (define (apply-generic-iter op args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
        (drop (apply proc (map contents args)))
        (apply-generic-iter op (uniform-height (highest? args) args))))))
    (apply-generic-iter op args))


(define type-tower '(complex real rational scheme-number))

(define (highest? args)
  (define (highest-iter1 args type)
        (cond
          ((null? args) nil)
          ((equal? (type-tag (car args)) type) (car args))
          (else
            (highest-iter1 (cdr args) type)
           )
          )
    )
  (define (highest-iter2 args tower)
    (cond
      ((null? tower) (error "異常な型" args))
      (else
       (let ((highest (highest-iter1 args (car tower))))
          (if (null? highest)
            (highest-iter2 args (cdr tower))
            highest)
         ))
    ))
  (highest-iter2 args type-tower)
)

(define (uniform-height highest other)
  (define (uniform-height-iter highest another)
    (if (equal? (type-tag highest) (type-tag another))
      another
      (uniform-height-iter highest (raise another))
      )
    )
  (cond
    ((null? other) nil)
    (else (cons (uniform-height-iter highest (car other))
                (uniform-height highest (cdr other))))
    )
  )


;以下のテスト用コードは以下から拝借したもの
;http://www.serendip.ws/archives/1070
(put 'add '(scheme-number scheme-number scheme-number)
     (lambda (x y z) (+ x y z)))

;これは自分で追加
(put 'add '(real real real)
    (lambda (x y z) (+ x y z)))

(put 'add '(complex complex complex)
     (lambda (x y z) (add (add (cons 'complex x)
                               (cons 'complex y))
                          (cons 'complex z))))

(define (add . args) (apply apply-generic (cons 'add args)))
;ここまで拝借



(display (make-complex-from-real-imag (make-rational 1 2) 2))
(newline)
(display (add (make-complex-from-real-imag (make-rational 1 2) 2)
              (make-complex-from-real-imag (make-rational 1 2) 2)))
(newline)
(display (magnitude-part (make-complex-from-real-imag (make-rational 1 2) 2)))
(newline)
(display (magnitude-part (make-complex-from-real-imag 4 3)))
(newline)
(display (real-part (make-complex-from-mag-ang 5 0)))
