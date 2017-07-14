#!/usr/bin/gosh
(use gl)
(use gl.glut)

;;; ==============================
;;; ベクタ関連
;;; ==============================
;構成子・選択子
(define (make-vect x y)
  (cons x y))

(define (xcor-vect v)
  (car v))

(define (ycor-vect v)
  (cdr v))

;ベクタ演算
(define (op-vect op v_1 v_2)
  (let ((x_1 (xcor-vect v_1))
    (y_1 (ycor-vect v_1))
    (x_2 (xcor-vect v_2))
    (y_2 (ycor-vect v_2)))
    (make-vect (op x_1 x_2) (op y_1 y_2))))

(define (add-vect v_1 v_2)
  (op-vect + v_1 v_2))

(define (sub-vect v_1 v_2)
  (op-vect - v_1 v_2))

(define (scale-vect s v)
  (op-vect * (make-vect s s) v))

;;; ==============================
;;; フレーム関連
;;; ==============================
;構成子・選択子
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (frame-origin frame)
  (car frame))

(define (frame-edge1 frame)
  (cadr frame))

(define (frame-edge2 frame)
  (caddr frame))

;フレーム座標写像
(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (frame-origin frame)
     (add-vect (scale-vect (xcor-vect v)
               (frame-edge1 frame))
           (scale-vect (ycor-vect v)
               (frame-edge2 frame))))))

;;; ==============================
;;; 有向線分関連
;;; ==============================
;構成子・選択子
(define (make-segment start end)
  (cons start end))

(define (start-segment segment)
  (car segment))

(define (end-segment segment)
  (cdr segment))

;;; ==============================
;;; 線画用ペインタ生成手続
;;; ==============================
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
    ((frame-coord-map frame) (start-segment segment))
    ((frame-coord-map frame) (end-segment segment))))
     segment-list)))

;;; ==============================
;;; フレームを生成
;;; ==============================
(define frame (make-frame (make-vect 0 0)
              (make-vect 1 0)
              (make-vect 0 1)))

;;; ==============================
;;; 菱形ペインタを生成
;;; ==============================
(define diamond
  (segments->painter (list
              (make-segment (make-vect 0.0 0.5)
                    (make-vect 0.5 1.0))
              (make-segment (make-vect 0.5 1.0)
                    (make-vect 1.0 0.5))
              (make-segment (make-vect 1.0 0.5)
                    (make-vect 0.5 0.0))
              (make-segment (make-vect 0.5 0.0)
                    (make-vect 0.0 0.5)))))


;;; ==============================
;;; 線分描画手続！
;;; ==============================
(define (draw-line p1 p2)
  (define (t z)
    (- (* 2 z) 1))
  (gl-vertex (t (xcor-vect p1)) (t (ycor-vect p1)))
  (gl-vertex (t (xcor-vect p2)) (t (ycor-vect p2))))

;;; ==============================
;;; 図形言語テスト用定形ロジック
;;; ==============================
(define (init)
  (gl-clear-color 1.0 1.0 1.0 1.0))

(define (disp)
  (gl-clear GL_COLOR_BUFFER_BIT)
  (gl-color 0.0 0.0 0.0 0.0)
  (gl-begin GL_LINE_LOOP)

  ;線画を描画！
  (diamond frame)

  (gl-end)
  (gl-flush))

(define (main args)
  (glut-init args)
  (glut-create-window "Painter Line Test")
  (glut-display-func disp)
  (init)
  (glut-main-loop)
  0)