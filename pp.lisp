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

(defun draw-grating-disk (center-x center-y radius phase width)
  (loop for xx from (round (- center-x radius))
     upto (round (+ center-x radius)) by width do
       (let* ((x (+ xx phase))
	      (q (- (expt radius 2)
		    (expt (- center-x x) 2))))
	 (when (< 0 q)
	   (let ((y (sqrt q)))
	     (vertex x (+ center-y y))
	     (vertex x (- center-y y)))))))

(defparameter *phase* 0)
(let ((bla nil))
 (defun draw-screen ()
   (clear :color-buffer-bit)
   (line-width 1)
   (let ((width 3))
    (with-primitive :lines
      (incf *phase*)
      (when (< width *phase*)
	(setf *phase* 0))
      (draw-grating-disk 150 150 100 *phase* width)))))

#+nil
(let ((x 790)
      (y 100))
  (sb-thread:make-thread
   #'(lambda ()
       (gui:with-gui (300 300 x y)
	 (draw-screen)))
   :name "camera-display"))

