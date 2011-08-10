(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf asdf:*central-registry* '("/home/martin/0505/mma/"))
  (require :gui))
(defpackage :r
  (:use :cl :gl))

(in-package :r)

#+nil(dotimes (i 100)
  (sleep (/ 16))
  (defparameter *r* (/ i 100s0))
  (format t "~a~%" *x*))

(defparameter *x* 0)
(defparameter *y* 0)

;; find intersection of vertical line and circle
;; (x-cx)^2+ (y-cy)^2=R^2
;; x=const=q
;; y=sqrt [R^2- (q-cx)^2]+cy

(defun draw-grating-disk (center-x center-y radius &key 
			  (phase 0) (phases 4) (line-width 8))
  (with-primitive :lines
    (let ((pl (* phases line-width)))
     (loop for xx from (round (- center-x radius))
	upto (round (+ center-x radius)) by pl do
	(let ((xxx (+ xx (* phase line-width))))
	  (loop for x from xxx below (+ xxx line-width) do
	       (let* ((q (- (expt radius 2)
			    (expt (- center-x x) 2))))
		 (when (< 0 q)
		   (let ((y (sqrt q)))
		     (vertex x (round (+ center-y y)))
		     (vertex x (round (- center-y y))))))))))))

(defun draw-grating-disk-50 (center-x center-y radius &key
			     (phase 0) (phases 4) (line-width 16))
  (unless (integerp (/ (* 2 line-width) phases))
    (break "can't divide line-width into an integer number of phase steps ~a"
	   (list line-width phases (/ (* 2 line-width) phases))))
  (with-primitive :lines
    (loop for x from (round (- center-x radius))
       upto (round (+ center-x radius)) do
	 (let* ((q (- (expt radius 2)
		      (expt (- center-x x) 2))))
	   (when (and (<= line-width (mod (+ (/ (* 2 line-width phase) phases) x) 
					  (* 2 line-width))) 
		      (< 0 q))
	     (let ((y (sqrt q)))
	       (vertex x (round (+ center-y y)))
	       (vertex x (round center-y))))))))


(defparameter *phase* 0)

(let ((bla nil))
 (defun draw-screen ()
   (clear :color-buffer-bit)
   (color 1 1 1)
   (let ((phases 2))
     (draw-grating-disk
      150 150 100
      :phase (setf *phase* (mod (1+ *phase*)
				phases))
      :phases phases :line-width 8)
     (color 1 0 0)
     (let ((phases 3))
       (draw-grating-disk-50 150 150 100
			     :phases phases
			     :phase 0
			     :line-width (* 2 phases 2))
       (color 0 1 0)
       (draw-grating-disk-50 150 150 100
			     :phases phases
			     :phase 1
			     :line-width (* 2 phases 2))))))

#+nil
(let ((x 790)
      (y 0))
  (sb-thread:make-thread
   #'(lambda ()
       (gui:with-gui (300 300 x y)
	 (draw-screen)))
   :name "camera-display"))

