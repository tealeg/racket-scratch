#lang racket

(require racket/draw)

;; Wood types
;; Konstruktionsholz NSI Fichte/Tanne 40x60x2500@4.72
;; Brettschichtholz SI Fichte/Tanne 60x120x3000@22.47

(struct block (length width height x y z colour))

(define (rotate-90-degrees source)
  (struct-copy block source
               [length (block-width source)]
               [width (block-length source)]))

(define (render-block dc x y width height colour)
    ;; (display (~a (list x y width height)))
    ;; (newline)
    (send dc set-brush colour 'solid)
    (send dc draw-rectangle x y width height))
  

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

(define (register-wood b)
  (display (sort (list (block-width b) (block-height b) (block-length b)) <)))

(define bedroom (block 2000 3050 2300 0 0 0 "gray"))
(define nordli-1200 (block 470 1200 540 0 0 0 "white"))
(define nordli-800 (block 470 800 540 0 0 0 "white"))
(define width-of-frame 2800)
(define bed-plane 540)
(define length-of-frame (- (block-length bedroom) (block-length nordli-1200)))


;; Shelf unit in corner
(define shelf-back (block 5 400 540 0 length-of-frame 0 "white"))
(define top-shelf 
  (block (- 470 (block-length shelf-back)) 400 10 0 (+ length-of-frame (block-length shelf-back)) (- bed-plane 6) "white"))
(define middle-shelf
  (block (- 470 (block-length shelf-back)) 400 10 0 (+ length-of-frame (block-length shelf-back)) (/ (- bed-plane 6) 2) "white"))
(define bottom-shelf
  (block (- 470 (block-length shelf-back)) 400 10 0 (+ length-of-frame (block-length shelf-back)) 0 "white"))

;; Side panel
(define side-panel
  (block (- (block-length bedroom) (block-length nordli-1200) (block-width nordli-800)) 5 540 (- width-of-frame 5) 0 0 "white"))

;; Ikea units
(define nordli-1
  (struct-copy block nordli-1200 [x (block-width top-shelf)] [y length-of-frame] [z 0]))
(define nordli-2
  (struct-copy block nordli-1200 [x (+ (block-width top-shelf) (block-width nordli-1))] [y length-of-frame] [z 0]))
(define nordli-3
  (struct-copy block (rotate-90-degrees nordli-800) [x (- width-of-frame (block-length nordli-800))] [y (- length-of-frame (block-width nordli-800))] [z 0]))

;; Cross struts
(define cross-strut-1-a
  (block 60 (/ (- width-of-frame (block-width side-panel)) 2.0) 40 0 0 (- bed-plane 40 60) "yellow"))
(define cross-strut-1-b
  (block 60 (/ (- width-of-frame (block-width side-panel)) 2.0) 40 (/ (- width-of-frame (block-width side-panel)) 2.0) 0 (- bed-plane 40 60) "yellow"))

(define cross-strut-2
  (block 60 (- width-of-frame (block-width nordli-3)) 40 0 (- length-of-frame 60) (- bed-plane 40 60) "yellow"))

;; Struts
(define strut-1
  (block length-of-frame 120 60 0 0 (- bed-plane 60) "yellow"))
(define strut-1-top-leg (block 60 120 (- bed-plane 60 (block-height cross-strut-1-a)) 0 0 0 "yellow"))
(define strut-1-bottom-leg (block 60 120 (- bed-plane 60 (block-height cross-strut-1-a)) 0 (- length-of-frame 60) 0 "yellow"))
(define strut-1-middle-leg (block 60 120 (- bed-plane 60) 0 (/ (- length-of-frame 60) 2) 0 "yellow"))


(define strut-2
  (block length-of-frame 120 60 (/ (- width-of-frame 120) 2) 0 (- bed-plane 60) "yellow"))
(define strut-2-top-leg (block 60 120 (- bed-plane 60 (block-height cross-strut-1-a)) (/ (- width-of-frame 120) 2) 0 0 "yellow"))
(define strut-2-bottom-leg (block 60 120 (- bed-plane 60 (block-height cross-strut-1-a)) (/ (- width-of-frame 120) 2) (- length-of-frame 60) 0 "yellow"))
(define strut-2-middle-leg (block 60 120 (- bed-plane 60) (/ (- width-of-frame 120) 2) (/ (- length-of-frame 60) 2) 0 "yellow"))

(define strut-3
  (block (- length-of-frame (block-width nordli-800)) 120 60 (- width-of-frame (block-width side-panel) 120) 0 (- bed-plane 60) "yellow"))
(define strut-3-top-leg (block 60 120 (- bed-plane 60 (block-height cross-strut-1-a)) (- width-of-frame (block-width side-panel) 120) 0 0 "yellow"))
(define strut-3-middle-leg (block 60 120 (- bed-plane 60) (- width-of-frame (block-width side-panel) 120) (- length-of-frame (block-width nordli-800) 60) 0 "yellow"))

;; Removable struts
(define removable-strut-1
  (block length-of-frame 120 60 (- (/ width-of-frame 4.0) (/ 120 2.0)) 0 (- bed-plane 60) "yellow"))
(define removable-strut-1-middle-leg
  (block 60 120 (- bed-plane 60) (- (/ width-of-frame 4.0) (/ 120 2.0)) (/ (- length-of-frame 60) 2) 0 "yellow"))

(define removable-strut-2
  (block length-of-frame 120 60 (- (* (/ width-of-frame 4.0) 3.0) (/ 120 2.0)) 0 (- bed-plane 60) "yellow"))
(define removable-strut-2-middle-leg
  (block 60 120 (- bed-plane 60) (- (* (/ width-of-frame 4.0) 3.0) (/ 120 2.0)) (/ (- length-of-frame 60) 2) 0 "yellow"))

;; Slats


(define scene (list bedroom
                    shelf-back
                    top-shelf

                    nordli-1
                    nordli-2
                    nordli-3
                    side-panel

                    cross-strut-1-a
                    cross-strut-1-b
                    cross-strut-2

                    strut-1  strut-1-top-leg strut-1-middle-leg strut-1-bottom-leg
                    strut-2  strut-2-top-leg strut-2-middle-leg strut-2-bottom-leg
                    strut-3  strut-3-top-leg strut-3-middle-leg

                    removable-strut-1 removable-strut-1-middle-leg
                    removable-strut-2 removable-strut-2-middle-leg ))

(render-top-down 3050 2000 scene "frame-top-down.png")

(define at-left-wall
  (list bedroom cross-strut-1-a cross-strut-2 strut-1 strut-1-top-leg strut-1-bottom-leg strut-1-middle-leg top-shelf shelf-back middle-shelf bottom-shelf))
(render-from-left-side 2000 2030 at-left-wall "strut-1.png")

(define at-removable-strut-1
  (list bedroom cross-strut-1-a cross-strut-2 removable-strut-1 removable-strut-1-middle-leg nordli-1))
(render-from-left-side 2000 2030 at-removable-strut-1 "removable-strut-1.png")

(define at-centre
  (list bedroom cross-strut-1-a cross-strut-2 strut-2 strut-2-top-leg strut-2-middle-leg strut-2-bottom-leg nordli-1))
(render-from-left-side 2000 2030 at-centre "strut-2.png")

(define at-removable-strut-2
  (list bedroom cross-strut-1-b cross-strut-2 removable-strut-2 removable-strut-2-middle-leg nordli-1))
(render-from-left-side 2000 2030 at-removable-strut-2 "removable-strut-2.png")

(define at-right-end
  (list bedroom cross-strut-1-b nordli-2 nordli-3 strut-3 strut-3-top-leg strut-3-middle-leg))
(render-from-left-side 2000 2030 at-right-end "strut-3.png")


(for ([wood (list
             cross-strut-1-a
             cross-strut-1-b
             cross-strut-2
             )])
  (register-wood wood))

  
