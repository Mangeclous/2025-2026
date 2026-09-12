#lang racket
(require txexpr
         "utils.rkt")

(provide (all-defined-out))

; Lignes de dépenses par contrepartie (hashtable)
(define cp->depenses
  (make-hash (map (lambda (lignes-cp) (cons (first (first lignes-cp)) lignes-cp)) partition-depenses)))

; Totaux des dépenses par contrepartie (hashtable)
(define cp->total
  (make-hash (map (lambda (lignes-cp)
                    (cons
                     (first (first lignes-cp))
                     (real->decimal-string (abs (apply + (map (lambda (ligne) (third ligne)) lignes-cp))) 2)))
                  partition-depenses)))

#|
(displayln (hash-ref cp->depenses "belfius"))
(displayln "")

(hash-for-each cp->total
               (lambda (cp total) (printf "~a : ~a\n" cp total)))
|#               

#|
      =============
      FONCTIONS TAG
      =============
|#

; Titres
(define (heading . elements)
  (txexpr 'h2 empty elements))

; Image des comptes Belfius
(define (figure src legende #:alt [alt legende] #:width [width #f])
  `(figure
     (img ((src ,src)
         (alt ,alt)
         ,@(if width
               `((style ,(format "width: ~apx; height: auto;" width)))
               '())))
     (figcaption ,legende)))

; Affichage html de la table des totaux dépenses
(define (tableau-depenses table)
  `(table
    (thead (tr (th "Contrepartie") (th "Total (€)")))
    (tbody
     ,@(for/list ([cle (sort (hash-keys table) string<?)])
         `(tr (td ,(string-titlecase cle))
              (td ,(hash-ref table cle)))))))

