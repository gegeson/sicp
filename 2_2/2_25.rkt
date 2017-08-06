#lang racket
(require racket/trace)
(require sicp)
(display (car (cdr (car (cdr (cdr '(1 3 (5 7) 9)))))))
(newline)
(display (car (car '((7)))))
(newline)
(display (cadr (cadr (cadr (cadr (cadr (cadr '(1 (2 (3 (4 (5 (6 7)))))))))))))
(newline)
