; 21:41->21:43
#lang racket
(require sicp)
(require racket/trace)
(display (car ''abracadabra))
;(quote (quote abracadabra))
;の一番最初のquoteを無視すると、quoteが先頭にあるリスト。
