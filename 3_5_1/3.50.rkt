#lang racket/load
(require sicp)
(require "3_5_1/stream.rkt")
; 17:58->18:02
; 18:04->18:35

; このサイトにものすごく助けられた。
; http://uents.hatenablog.com/entry/sicp/035-ch3.5.1.md

; stream.rkt及びlist->streamおよびstream->listはここから拝借した。

; まず非ストリーム版を考えたらこうなった

(define (map2 proc . args)
  (if (null? (car args))
    nil
    (cons
     (apply proc (map car args))
     (apply map2 (cons proc (map cdr args))))
    )
  )

; そしてストリーム版
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
    the-empty-stream
    (stream-cons
     (apply proc (map stream-car argstreams))
     (apply stream-map
       (cons proc (map stream-cdr argstreams)))
     )
    ))


(define (list->stream sequence)
  (if (null? sequence)
      nil
      (cons-stream (car sequence)
                   (list->stream (cdr sequence)))))

(define (stream->list s)
  (if (stream-null? s)
      nil
      (cons (stream-car s)
            (stream->list (stream-cdr s)))))

; テスト
(display (stream->list
          (stream-map +
                      (list->stream (list 1 2 3))
                      (list->stream (list 4 5 6)))))
