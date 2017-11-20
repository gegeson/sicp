;3.32検証.rktの対照実験として、
;キューのまま3.32検証.rktと同じコードを動かしてみる。

#lang debug racket
(require sicp)
(require racket/trace)

;(or-gate a1 a2 output)
;とすると、
;a1, a2それぞれに対して、
;「その時保持しているa1, a2の値に応じて
;outputに送る値を計算し、かつ、
;一定のディレイの後に、
;その新しい値に基づいてoutputが保持しているアクションを起動させる」
;というアクションをセットする

(define (inverter input output)
  (define (invert-input)
	(let ((new-value (logical-not (get-signal input))))
	  (after-delay *inverter-delay*
				   (lambda ()
					 (set-signal! output new-value)))))
  (add-action! input invert-input)
  'ok)

(define (logical-not s)
  (if (= s 0)
	   1
	   0))

(define (and-gate a1 a2 output)
  (define (and-action-procedure)
	(let ((new-value (logical-and (get-signal a1) (get-signal a2))))
	  (after-delay *and-gate-delay*
				   (lambda ()
					 (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)

(define (logical-and x y)
  (if (and (= x 1) (= y 1))
    1
    0)
  )

(define (logical-or x y)
  (if (or (= x 1) (= y 1))
    1
    0))

(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value (logical-or (get-signal a1) (get-signal a2))))
      (after-delay *or-gate-delay*
                   (lambda ()
                           (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)


(define (half-adder a b s c)
  (let ((d (make-wire))
		(e (make-wire)))
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


;;; 回線の実装

(define (make-wire)
  (let ((signal-value 0)
		(action-procedures '()))
	(define (call-each procedures)
	  (if (null? procedures)
		  'done
		  (begin ((car procedures))
				 (call-each (cdr procedures)))))
	(define (set-my-signal! new-value)
	  (if (not (= signal-value new-value))
		  (begin (set! signal-value new-value)
				 (call-each action-procedures))
		  'done))
;;	(define (accept-action-procedure! proc)
;;	  (set! action-procedures (cons proc action-procedures))
;;	  (proc))
	(define (accept-action-procedure! proc) ;; for ex 3.31
	  (set! action-procedures (cons proc action-procedures)))
	(define (dispatch m)
	  (cond ((eq? m 'get-signal) signal-value)
			((eq? m 'set-signal!) set-my-signal!)
			((eq? m 'add-action!) accept-action-procedure!)
			(else (error "Unknown operation -- WIRE" m))))
	dispatch))

(define (get-signal wire)
  (wire 'get-signal))
(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))
(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))


;;;; -----------------------------------
;;;; シミュレーションの実装
;;;; -----------------------------------

;; 手続きを遅延時間後に実行させるようアジェンダに登録する
(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time *the-agenda*))
				  action
				  *the-agenda*))

;; アジェンダに登録されている手続きを全て実行させる
(define (propagate)
  (if (empty-agenda? *the-agenda*)
	  'done
	  (begin ((first-agenda-item *the-agenda*))
			 (remove-first-agenda-item! *the-agenda*)
			 (propagate))))

;; 回線の値の変更時に現在値をプリントさせる
(define (probe name wire)
  (add-action! wire
			   (lambda ()
				 (display name)
				 (display " ")
				 (display (current-time *the-agenda*))
				 (display " New-value = ")
				 (display (get-signal wire))
				 (newline))))


;;;; -----------------------------------
;;;; アジェンダの実装
;;;; -----------------------------------

;;; アジェンダ
(define (make-agenda) (cons 0 '()))
(define (current-time agenda) (car agenda))
(define (set-current-time! agenda time)
  (set-car! agenda time))
(define (segments agenda) (cdr agenda))
(define (set-segments! agenda segments)
  (set-cdr! agenda segments))

;;; セグメント
(define (make-time-segment time queue)
  (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))


;;; アジェンダの操作手続き

;; アジェンダが空かどうかチェック
(define (empty-agenda? agenda)
  (null? (segments agenda)))

;; アジェンダに手続きを追加
(define (add-to-agenda! time action agenda)
  ; segmentsの終端かtimeの直前にsegmentがあればtrueを返す
  (define (belongs-before? segs)
;	(display (format "belongs-before? ~a ~%" segs))
	(or (null? segs)
		(< time (segment-time (car segs)))))
  ; segmentを作成
  (define (make-new-time-segment)
;	(display (format "make-new-time-segments! ~%"))
	(let ((q (make-queue)))
	  (insert-queue! q action)
	  (make-time-segment time q)))
  ; segmentを追加
  (define (add-to-segments! segs)
;	(display (format "add-to-segments! ~a ~%" segs))
	(if (= time (segment-time (car segs)))
		(insert-queue! (segment-queue (car segs))
					   action)
		(if (belongs-before? (cdr segs))
			(set-cdr! segs (cons (make-new-time-segment)
								 (cdr segs)))
			(add-to-segments! (cdr segs)))))

  (let ((segs (segments agenda)))
	(if (belongs-before? segs)
		(set-cdr! agenda (cons (make-new-time-segment)
							   segs))
		(add-to-segments! segs))))

;; アジェンダの先頭セグメントを取り出す
(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
	  (error "Agenda is empty -- FIRST-AGENDA-ITEM")
	  (let ((seg (car (segments agenda))))
		(set-current-time! agenda (segment-time seg))
		(front-queue (segment-queue seg)))))

;; アジェンダの先頭セグメントを削除
(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (car (segments agenda)))))
	(delete-queue! q)
	(if (empty-queue? q)
		(set-segments! agenda (cdr (segments agenda)))
		false)))


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


;;;; -----------------------------------
;;;; シミュレーションの設定
;;;; -----------------------------------
(define *inverter-delay* 2)
(define *and-gate-delay* 3)
(define *or-gate-delay* 5)
(define *the-agenda* (make-agenda))

(define q (make-queue))
(insert-queue! q 1)
(insert-queue! q 2)
(insert-queue! q 3)
(insert-queue! q 4)
(print-queue q)
(delete-queue! q)
(print-queue q)

(define in-1 (make-wire))
(define in-2 (make-wire))
(define out (make-wire))
(probe 'in-1 in-1)
(probe 'in-2 in-2)
(probe 'out out)
(and-gate in-1 in-2 out)

(set-signal! in-1 0)

(set-signal! in-2 1)

(propagate)

(set-signal! in-1 1)

(set-signal! in-2 0)

(propagate)
