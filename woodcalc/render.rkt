#lang racket/base


(require racket/class)
(require racket/draw)

(require "block.rkt")


(define (render-block dc x y width height colour)
  (send dc set-brush colour 'solid)
  (send dc draw-rectangle x y width height)
  (send dc set-font (make-font #:size 20))
  (send dc draw-text (string-append (number->string x) "," (number->string y)) x y)
)

(provide render-block)

(struct point (x y z))

(define (iso-translate-point point offset-x offset-y)
    (values (+ (- (point-x point) (point-y point)) offset-x)
            (+ (point-z point) (/ (+ (point-x point) (point-y point)) 2.0) offset-y)))


(define (render-path-isometric dc offset-x offset-y points)
  (define b-path (new dc-path%))
  (let-values ([(x y) (iso-translate-point (car points) offset-x offset-y)])
    (send b-path move-to x y)
    )
 
  (for ([p (cdr points)])
    (let-values ([(x y) (iso-translate-point p offset-x offset-y)])
      (send b-path line-to x y)
      ))
  (send dc draw-path b-path)
  )

(define (render-block-isometric dc obj offset-x offset-y)
  (send dc set-brush (block-colour obj) 'solid)

  (render-path-isometric dc offset-x offset-y
                         (list (point  (block-x obj) (block-y obj) (block-z obj))
                               (point (+ (block-x obj) (block-width obj))
                                     (block-y obj)
                                     (block-z obj))
                               (point (+ (block-x obj) (block-width obj))
                                      (+ (block-y obj) (block-length obj))
                                      (block-z obj))
                               (point (block-x obj)
                                     (+ (block-y obj) (block-length obj))
                                     (block-z obj))
                               (point (block-x obj)
                                     (block-y obj)
                                     (block-z obj))                               
                               ))
    (render-path-isometric dc offset-x offset-y
                         (list (point  (block-x obj) (block-y obj)
                                       (+ (block-z obj) (block-height obj)))
                               (point (+ (block-x obj) (block-width obj))
                                     (block-y obj)
                                     (+ (block-height obj)(block-z obj)))
                               (point (+ (block-x obj) (block-width obj))
                                      (+ (block-y obj) (block-length obj))
                                      (+ (block-height obj)(block-z obj)))
                               (point (block-x obj)
                                     (+ (block-y obj) (block-length obj))
                                     (+ (block-height obj) (block-z obj)))
                               (point (block-x obj)
                                     (block-y obj)
                                     (+ (block-height obj)(block-z obj)))
                               ))

  (render-path-isometric dc offset-x offset-y
                         (list (point (block-x obj)
                                      (block-y obj)
                                      (block-z obj))
                               (point (block-x obj)
                                      (block-y obj)
                                      (+ (block-z obj) (block-height obj)))
                               (point (block-x obj)
                                      (+ (block-y obj) (block-length obj))
                                      (+ (block-z obj) (block-height obj)))
                               (point (block-x obj)
                                      (+ (block-y obj) (block-length obj))
                                      (block-z obj))
                               (point (block-x obj)
                                      (block-y obj)
                                      (block-z obj))
                               ))
  (render-path-isometric dc offset-x offset-y
                         (list (point (block-x obj)
                                      (block-y obj)
                                      (block-z obj))
                               (point (block-x obj)
                                      (block-y obj)
                                      (+ (block-z obj) (block-height obj)))
                               (point (+ (block-x obj) (block-width obj))
                                      (block-y obj)
                                      (+ (block-z obj) (block-height obj)))
                               (point (+ (block-x obj) (block-width obj))
                                      (block-y obj)
                                      (block-z obj))
                               (point (block-x obj)
                                      (block-y obj)
                                      (block-z obj))
                               ))

  )
  

(define (render-top-down width height blocks filename)
  (define target (make-bitmap width height))
  (define dc (new bitmap-dc% [bitmap target]))

  (for ([obj blocks])
    (render-block dc 
     (block-x obj)
     (block-y obj)
     (block-width obj)
     (block-length obj)
     (block-colour obj)))

  (send target save-file filename 'png))
(provide render-top-down)  

(define (render-from-left-side width height blocks filename)
  (define target (make-bitmap width height))
  (define dc (new bitmap-dc% [bitmap target]))

  (for ([obj blocks])
    (render-block
     dc
     (block-y obj)
     (- height (+ (block-z obj) (block-height obj)))
     (block-length obj)
     (block-height obj)
     (block-colour obj)))

  (send target save-file filename 'png))
(provide render-from-left-side)




(define (render-isometric width height blocks filename)
  (define target (make-bitmap width height))
  (define dc (new bitmap-dc% [bitmap target]))

  (for ([obj blocks])
    (render-block-isometric
     dc
     obj (/ width 2.0) 0))

  (send target save-file filename 'png)
  )

(provide render-isometric)
