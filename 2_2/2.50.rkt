#lang racket
(require (planet "sicp.ss" ("soegaard" "sicp.plt" 2 1)))
;19:30->19:40
;19:41->20:12

;20:46->21:14
;21:26->21:59


(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cadr v))

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

(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
          (let ((m (frame-coord-map frame)))
            (let ((new-origin (m origin)))
              (painter (make-frame
                        (new-origin
                         (sub-vect (m corner1) new-origin)
                         (sub-vect (m corner2) new-origin))))))))
;要は座標変換

(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))
(define (shrink-to-upper-right painter)
  (transform-painter
   painter
   (make-vect 0.5 0.5) (make-vect 1.0 0.5) (make-vect 0.5 1.0)))

(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))
(define (rotate90 painter)
 (transform-painter painter
                    (make-vect 0.0 0.0)
                    (make-vect 0.65 0.35)
                    (make-vect 0.35 0.65)))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
           (transform-painter
            painter1
            (make-vect 0.0 0.0)
            split-point
            (make-vect 0.0 1.0)))
          (paint-right
           (transform-painter
            painter2
            split-point
            (make-vect 1.0 0.0)
            (make-vect 0.5 1.0))))
      (lambda (frame)
              (paint-left frame)
              (paint-right frame)))))
(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0)
                     (make-vect 0 0)
                     (make-vect 1.0 1.0)))

(define (rotate180 painter)
 (transform-painter painter
                    (make-vect 1.0 1.0)
                    (make-vect 0 1.0)
                    (make-vect 1.0 0)))

(define (rotate270 painter)
(transform-painter painter
                  (make-vect 0 1.0)
                  (make-vect 0 0)
                  (make-vect 1.0 1.0)))


(define (below1 painter1 painter2)
(let ((split-point (make-vect 0.0 0.5)))
(let ((paint-bottom
     (transform-painter
      painter1
      (make-vect 0.0 0.0)
      (make-vect 1.0 0.0)
      split-point))
    (paint-top
     (transform-painter
      painter2
      split-point
      (make-vect 1.0 0.5)
      (make-vect 0.0 1.0))))
(lambda (frame)
        (paint-bottom frame)
        (paint-top frame)))))
(define (below2 painter1 painter2)
  ((rotate270 (rotate180 (beside (rotate270 painter1) (rotate270 painter2))))))
