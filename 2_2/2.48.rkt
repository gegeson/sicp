#lang racket
(require sicp)
;19:30->19:40
;19:41->

(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2)
  (let ((v1_x (xcor-vect v1))
        (v1_y (ycor-vect v1))
        (v2_x (xcor-vect v2))
        (v2_y (ycor-vect v2)))
      (make-vect (+ v1_x v2_x) (+ v1_y v2_y))
    )
  )
(define (sub-vect v1 v2)
  (let ((v1_x (xcor-vect v1))
        (v1_y (ycor-vect v1))
        (v2_x (xcor-vect v2))
        (v2_y (ycor-vect v2)))
    (make-vect (- v1_x v2_x) (- v1_y v2_y))
  ))
(define (scale-vect s v)
  (let ((vx (xcor-vect v))
        (vy (ycor-vect v)))
    (make-vect (* s vx) (* s vy))
  ))

(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (cadr frame))
(define (edge2-frame frame) (caddr frame))

(define (segments->painter segment-list)
  (lambda (frame)
          (for-each
           (lambda (segment)
                   (draw-line
                    ((frame-coord-map frame)
                     (start-segment segment))
                    ((frame-coord-map frame)
                     (end-segment segment))))
           segment-list)))
(define (make-segment v1 v2) (cons v1 v2))
(define (start-segment v) (car v))
(define (end-segment v) (cdr v))
