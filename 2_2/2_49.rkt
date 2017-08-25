#lang racket
(require (planet "sicp.ss" ("soegaard" "sicp.plt" 2 1)))
;19:30->19:40
;19:41->20:12


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


(define (make-segment v1 v2) (cons v1 v2))
(define (start-segment v) (car v))
(define (end-segment v) (cdr v))


(define q1
  (segments->painter
   (list (make-segment (make-vect 0 0) (make-vect 0 1))
         (make-segment (make-vect 0 0) (make-vect 1 0))
         (make-segment (make-vect 0 0.99) (make-vect 0.99 0.99))
         (make-segment (make-vect 0.99 0) (make-vect 0.99 0.99)))))
(paint q1)

(define q2
  (segments->painter
   (list (make-segment (make-vect 0 0) (make-vect 1 1))
         (make-segment (make-vect 1 0) (make-vect 0 1))
         )))
(paint q2)

(define q3
  (segments->painter
   (list (make-segment (make-vect 0.5 0) (make-vect 1 0.5))
         (make-segment (make-vect 1 0.5) (make-vect 0.5 1))
         (make-segment (make-vect 0 0.5) (make-vect 0.5 1))
         (make-segment (make-vect 0.5 0) (make-vect 0 0.5)))))
(paint q3)
