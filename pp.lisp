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
			  (phase 0) (phases 3) (line-width 4))
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

(defparameter *phase* 0)
(let ((bla nil))
 (defun draw-screen ()
   (clear :color-buffer-bit)
   (let ((phases 3))
     (loop for (p c) in '((0 (.8 .3 0)) (1 (.3 .6 .2)) (2 (.3 .3 .9))) do
      (apply #'color c)
      (draw-grating-disk 150 150 100 :phase p
			 :phases phases :line-width 4)))))

#+nil
(let ((x 790)
      (y 100))
  (sb-thread:make-thread
   #'(lambda ()
       (gui:with-gui (300 300 x y)
	 (draw-screen)))
   :name "camera-display"))

