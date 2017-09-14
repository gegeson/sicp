#lang racket/load
(require sicp)
(require racket/trace)
;8:55->
(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (cond
    ((number? datum) 'scheme-number)
    ((pair? datum) (car datum))
      (else (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (contents datum)
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

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types -- APPLY-GENERIC"
            (list op type-tags))))))

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
  	  (sqrt (+ (* x x) (* y y)))))
  (define (angle-part z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-real-imag x y)
	(cons x y))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))

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
    (* (magnitude-part z) (cos (angle-part z))))
  (define (imag-part z)
    (* (magnitude-part z) (sin (angle-part z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (* x x) (* y y)))
          (atan y x)))

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
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude-part z1) (magnitude-part z2))
                       (+ (angle-part z1) (angle-part z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude-part z1) (magnitude-part z2))
                       (- (angle-part z1) (angle-part z2))))

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
               (and (= (real-part x) (real-part y)) (= (imag-part x) (imag-part y)))))
  (put 'zero? '(complex)
       (lambda (x)
               (and (= (real-part x) 0) (= (imag-part x) 0))))
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

  ;; interface
  (define (tag x) (attach-tag 'rational x))
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
  'done)

;; constructor
(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

(install-scheme-number-package)

;; Coercion

(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))

(put-coercion 'scheme-number 'complex scheme-number->complex)


(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                (list op type-tags))))))
              (error "No method for these types"
                     (list op type-tags)))))))

;; EXERCISE 2.81

(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)

(put-coercion 'scheme-number 'scheme-number
               scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)
(display (add (make-complex-from-real-imag 2 3) (make-complex-from-real-imag 1 2)))

;型が同じなら、(get op type-tags)で適切なprocを見つけ出す事が可能なので、
;特に必要ないと思う。
;2.81.aのような無限ループが起こりうるしむしろ要らない？
;->2.82で　(add 複素数、複素数、整数)が計算できず、
;同じ型変換を追加すると動いた、という現象があった。
;つまり自分の実装した2.82では必要である。
;2.82にも書いたその理由
;complex->complexが必要な理由
;もし単に(add 複素数、整数1、整数2）とするなら問題はない。
;coercionは第一引数と第二引数以降から一つずつ選んで
;型変換関数を探す、という手順を踏むので、
;この場合は複素数と整数1、複素数と整数2の組み合わせを調べることになる。
;しかし、(add 複素数1、複素数2、整数)とする場合は、
;複素数1と複素数2、複素数1と整数、という組み合わせで型変換関数を探すことになる。
;これをやりたい場合、複素数同士を受け取り型変換する関数がないと出来ないので、
;ここで必要になる。
