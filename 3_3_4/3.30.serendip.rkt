#lang debug racket
(require sicp)
(require racket/trace)

;3.30.rktが何故か動かないので、全文コピペでチャレンジ

;;NB. To use half-adder, need or-gate from exercise 3.28
(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'ok))

(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire))
        (c1 (make-wire))
        (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'ok))

(define (inverter input output)
  (define (invert-input)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define (logical-not s)
  (cond ((= s 0) 1)
        ((= s 1) 0)
        (else (error "Invalid signal" s))))

;; *following uses logical-and -- see ch3support.scm

(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
           (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)

  (define (logical-and x y)
    (if (and (= x 1) (= y 1))
  	  1
  0))

(define (or-gate a1 a2 output)
  (define (or-action-procedure)
	(let ((new-value (logical-or (get-signal a1) (get-signal a2))))
	  (after-delay or-gate-delay
				   (lambda ()
					 (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)

(define (logical-or x y)
  (if (or (= x 1) (= y 1))
	  1
	  0))


(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
          (begin (set! signal-value new-value)
                 (call-each action-procedures))
          'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-my-signal!)
            ((eq? m 'add-action!) accept-action-procedure!)
            (else (error "Unknown operation -- WIRE" m))))
    dispatch))

(define (call-each procedures)
  (if (null? procedures)
      'done
      (begin
        ((car procedures))
        (call-each (cdr procedures)))))

(define (get-signal wire)
  (wire 'get-signal))

(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))

(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))

(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
                  action
                  the-agenda))

(define (propagate)
  (if (empty-agenda? the-agenda)
      'done
      (let ((first-item (first-agenda-item the-agenda)))
        (first-item)
        (remove-first-agenda-item! the-agenda)
        (propagate))))

(define (probe name wire)
  (add-action! wire
               (lambda ()
                 (newline)
                 (display name)
                 (display " ")
                 (display (current-time the-agenda))
                 (display "  New-value = ")
                 (display (get-signal wire)))))

;;; Sample simulation

;: (define input-1 (make-wire))
;: (define input-2 (make-wire))
;: (define sum (make-wire))
;: (define carry (make-wire))
;:
;: (probe 'sum sum)
;: (probe 'carry carry)
;:
;: (half-adder input-1 input-2 sum carry)
;: (set-signal! input-1 1)
;: (propagate)
;:
;: (set-signal! input-2 1)
;: (propagate)


;; EXERCISE 3.31
;: (define (accept-action-procedure! proc)
;:   (set! action-procedures (cons proc action-procedures)))


;;;Implementing agenda

(define (make-time-segment time queue)
  (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))

(define (make-agenda) (list 0))

(define (current-time agenda) (car agenda))
(define (set-current-time! agenda time)
  (set-car! agenda time))

(define (segments agenda) (cdr agenda))
(define (set-segments! agenda segments)
  (set-cdr! agenda segments))
(define (first-segment agenda) (car (segments agenda)))
(define (rest-segments agenda) (cdr (segments agenda)))

(define (empty-agenda? agenda)
  (null? (segments agenda)))

(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
        (< time (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
        (insert-queue! (segment-queue (car segments))
                       action)
        (let ((rest (cdr segments)))
          (if (belongs-before? rest)
              (set-cdr!
               segments
               (cons (make-new-time-segment time action)
                     (cdr segments)))
              (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
        (set-segments!
         agenda
         (cons (make-new-time-segment time action)
               segments))
        (add-to-segments! segments))))

(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue? q)
        (set-segments! agenda (rest-segments agenda)))))

(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
      (error "Agenda is empty -- FIRST-AGENDA-ITEM")
      (let ((first-seg (first-segment agenda)))
        (set-current-time! agenda (segment-time first-seg))
        (front-queue (segment-queue first-seg)))))

;;;; -----------------------------------
;;;; キューの実装 (from §3.3.2)
;;;; -----------------------------------

(define (make-queue)
  (let ((front-ptr nil)
		(rear-ptr nil))
	(define (empty-queue?)
	  (null? front-ptr))
	(define (front-queue)
	  (if (empty-queue?)
		  (error "FRONT called with an empty queue")
		  (car front-ptr)))
	(define (insert-queue! item)
	  (let ((new-pair (cons item nil)))
		(if (empty-queue?)
			(begin
			  (set! front-ptr new-pair)
			  (set! rear-ptr new-pair))
			(begin
			  (set-cdr! rear-ptr new-pair)
			  (set! rear-ptr new-pair)))))
	(define (delete-queue!)
	  (if (empty-queue?)
		  (error "DELETE! called with an empty queue")
		  (set! front-ptr (cdr front-ptr))))
	(define (print-queue)
	  (display front-ptr (current-error-port))
	  (newline (current-error-port)))

	(define (dispatch m)
	  (cond ((eq? m 'empty-proc?) empty-queue?)
			((eq? m 'front-proc) front-queue)
			((eq? m 'insert-proc!) insert-queue!)
			((eq? m 'delete-proc!) delete-queue!)
			((eq? m 'print-proc) print-queue)
			(else (error "Unknown operation -- QUEUE" m))))
	dispatch))

(define (empty-queue? q)
  ((q 'empty-proc?)))
(define (front-queue q)
  ((q 'front-proc)))
(define (insert-queue! q item)
  ((q 'insert-proc!) item))
(define (delete-queue! q)
  ((q 'delete-proc!)))
(define (print-queue q)
  ((q 'print-proc)))

(define (ripple-carry-adder list-a list-b list-sum c-out)
  (define (iter list-a list-b list-sum c-in)
    (if (not (null? list-a))
        (let ((c-out (make-wire)))
             (full-adder (car list-a) (car list-b) c-in (car list-sum) c-out)
             (iter (cdr list-a) (cdr list-b) (cdr list-sum) c-out))
        'ok))
  (iter list-a list-b list-sum c-out))

  (define the-agenda (make-agenda))
  (define inverter-delay 2)
  (define and-gate-delay 3)
  (define or-gate-delay 5)

  (define a1 (make-wire))
  (define a2 (make-wire))
  (define a3 (make-wire))
  (define a4 (make-wire))

  (define b1 (make-wire))
  (define b2 (make-wire))
  (define b3 (make-wire))
  (define b4 (make-wire))

  (define s1 (make-wire))
  (define s2 (make-wire))
  (define s3 (make-wire))
  (define s4 (make-wire))

  (define a (list a1 a2 a3 a4))
  (define b (list b1 b2 b3 b4))
  (define s (list s1 s2 s3 s4))
  (define c (make-wire))

  (probe 's1 s1)
  (probe 's2 s2)
  (probe 's3 s3)
  (probe 's4 s4)
  (probe 'c c)

  (ripple-carry-adder a b s c)
  (set-signal! a1 1)
  (propagate)

  (set-signal! b1 1)
  (propagate)

  (set-signal! a2 1)
  (propagate)
