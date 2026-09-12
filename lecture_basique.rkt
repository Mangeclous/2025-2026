#lang racket
(require csv-reading)
(require gregor)
(require racket/list)


(define lire-avec-point-virgule
  (make-csv-reader-maker '((separator-chars . (#\;)))))

(define toutes-les-lignes
  (call-with-input-file "csv/compte_courant.csv"
    (lambda (port)
      (csv->list (lire-avec-point-virgule port)))))

(define utile (drop toutes-les-lignes 12))
(define entete (first utile))
(define data0 (rest utile))

(define (selectionner ligne)
  (list (list-ref ligne 5)    ; contrepartie
        (list-ref ligne 9)    ; date valeur
        (list-ref ligne 10)   ; montant
        (list-ref ligne 14))) ; communication
(define  data1 (map selectionner data0))

(define (belfius ligne)
  (if (string=? (list-ref ligne 0) "")
      (list "Belfius" (list-ref ligne 1) (list-ref ligne 2) "Frais bancaires")
      ligne))
(define data2 (map belfius data1))

(define (nombre_date ligne)
  (define dt (parse-date (list-ref ligne 1) "dd/MM/yyyy"))
  (define montant (string->number (string-replace (list-ref ligne 2) "," ".")))
  (list (list-ref ligne 0) dt montant (list-ref ligne 3)))
(define data3 (map nombre_date data2))

(define data4 (sort data3 date<? #:key (lambda (r) (second r))))

; Normalisation des contreparties
(define (normalize-contrepartie ligne)
  (define normalized-cp (string-downcase (first ligne)))
  (cons normalized-cp (rest ligne)))
(define data5 (map normalize-contrepartie data4))

(take data5 3)

; Séparation des recettes et des dépenses !!!!
(define-values (recettes depenses)
  (partition (lambda (ligne) (>= (list-ref ligne 2) 0)) data5))

(take recettes 10)
(displayln "\n\n\n")
(take depenses 10)
(displayln "\n\n\n")

; # Lignes de dépenses
(displayln (format "Nombre de lignes dépenses : ~a" (length depenses)))
; Total des dépenses
(define total-depenses (apply + (map (lambda (ligne) (third ligne)) depenses)))
(displayln (format "Total des dépenses : ~a\n" (abs total-depenses)))

; Contreparties uniques (depenses)
(define contreparties
  (remove-duplicates (map (lambda (ligne) (first ligne)) depenses)))
(displayln contreparties)
(displayln "")

#|
; Lignes traitées (pour but de vérification)
(define depenses-traitees 0)

; Dépenses frais bancaires
(define lignes-belfius
  (filter (lambda (ligne) (string=? (first ligne) "belfius")) depenses))
(define total-belfius
  (apply + (map (lambda (ligne) (third ligne)) lignes-belfius)))
(displayln lignes-belfius)
(displayln (abs total-belfius))
(displayln "")

(set! depenses-traitees (+ depenses-traitees (length lignes-belfius)))
(displayln (format "Lignes dépenses : ~a    Lignes traitées : ~a" (length depenses) depenses-traitees))
(displayln "")
|#

; Partition des dépenses suivant les contreparties
(define partition-depenses
  (group-by (lambda (ligne) (first ligne)) depenses))

; Lignes de dépenses par contrepartie (hashtable)
(define cp->depenses
  (make-hash (map (lambda (lignes-cp) (cons (first (first lignes-cp)) lignes-cp)) partition-depenses)))

(displayln (hash-ref cp->depenses "belfius"))
(displayln "")

; Totaux des dépenses par contrepartie (hashtable)
(define cp->total
  (make-hash (map (lambda (lignes-cp)
                    (cons
                     (first (first lignes-cp))
                     (real->decimal-string (abs (apply + (map (lambda (ligne) (third ligne)) lignes-cp))) 2)))
                  partition-depenses)))

(hash-for-each cp->total
               (lambda (cp total) (printf "~a : ~a\n" cp total)))
               



