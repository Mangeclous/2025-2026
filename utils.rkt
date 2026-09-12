#lang racket
(require csv-reading
         gregor
         threading)

(provide recettes
         depenses
         partition-depenses
         partition-recettes
         )


(define lire-avec-point-virgule
  (make-csv-reader-maker '((separator-chars . (#\;)))))

(define (lire-csv csv-file)
  (call-with-input-file csv-file
    (lambda (port)
      (csv->list (lire-avec-point-virgule port)))))

; Sélection des champs utiles
(define (selectionner ligne)
  (list (list-ref ligne 5)    ; contrepartie
        (list-ref ligne 9)    ; date valeur
        (list-ref ligne 10)   ; montant
        (list-ref ligne 14))) ; communication

; Traitement des lignes de frais bancaires (Belfius)
(define (belfius ligne)
  (if (string=? (list-ref ligne 0) "")
      (list "Belfius" (list-ref ligne 1) (list-ref ligne 2) "Frais bancaires")
      ligne))

; Conversion de strings numériques et de strings date
(define (nombre-date ligne)
  (define dt (parse-date (list-ref ligne 1) "dd/MM/yyyy"))
  (define montant (string->number (string-replace (list-ref ligne 2) "," ".")))
  (list (list-ref ligne 0) dt montant (list-ref ligne 3)))

; Normalisation des contreparties
(define (normalize-contrepartie ligne)
  (define normalized-cp (string-downcase (first ligne)))
  (cons normalized-cp (rest ligne)))

(define (molderez ligne)
         (list
          (string-replace (list-ref ligne 0) "jean francois emile molderez" "molderez jean francois emi")
          (list-ref ligne 1)
          (list-ref ligne 2)
          (list-ref ligne 3)))

; Obtention du résultat : lignes à 4 champs & normalisation du champ contrepartie
(define resultat
  (~> (lire-csv "csv/compte_courant.csv")
      (drop _ 12)
      rest         ; enlever entête
      (map selectionner _)
      (map belfius _)
      (map nombre-date _)
      (sort _ date<? #:key (lambda (r) (second r)))
      (map normalize-contrepartie _)
      (map molderez _)))

; Séparation des recettes et des dépenses !!!!
(define-values (recettes depenses)
  (partition (lambda (ligne) (>= (list-ref ligne 2) 0)) resultat))

; Partition des dépenses suivant les contreparties
(define partition-depenses
  (group-by (lambda (ligne) (first ligne)) depenses))

; Partition des recettes suivant les contreparties
(define partition-recettes
  (group-by (lambda (ligne) (first ligne)) recettes))




