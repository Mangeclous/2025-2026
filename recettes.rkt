#lang racket

(require "utils.rkt")

(take recettes 10)
(displayln "")
(define cp-recettes (remove-duplicates (map first recettes)))
(for ([cp cp-recettes])
  (printf "~a\n" cp))
(displayln (length cp-recettes))
(displayln "")

; Lignes de dépenses par contrepartie (hashtable)
(define cp->recettes
  (make-hash (map (lambda (lignes-cp) (cons (first (first lignes-cp)) lignes-cp)) partition-recettes)))

(displayln (hash-ref cp->recettes "acp mars"))
(displayln "")



; Lignes de dépenses par contrepartie (hashtable)
;(define cp->depenses
;  (make-hash (map (lambda (lignes-cp) (cons (first (first lignes-cp)) lignes-cp)) partition-depenses)))

;(define cp-recettes1 (remove-duplicates (map first data1)))
;(displayln cp-recettes1)
;(displayln (length cp-recettes1))
