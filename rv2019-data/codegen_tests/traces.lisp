;;;;
;;;; Random traces generation with partial observability
;;;;

(in-package :cl-user)

;; There're 6 system variables (p, q, r, s, t, z), 3^6 states in total
;; p : 0, q : 1, r : 2, s : 3, t : 4, z : 5

(defun get-next-state ()
  (vector (random 3) (random 3) (random 3) (random 3) (random 3) (random 3)))

(defparameter *number-of-traces*    500)
(defparameter *default-trace-length* 50)

(defun make-trace (&optional (length *default-trace-length*))
  (loop for i from 0 below length
	collect (get-next-state)))

(defvar *traces*) ; all states

(defun make-traces ()
  (setq *traces*
	(loop for i from 0 below *number-of-traces*
	      collect (make-trace))))

(defun write-traces-lisp (filename varname traces)
  (let ((file (merge-pathnames filename #.*compile-file-pathname*)))
    (with-open-file (s file :direction :output :if-exists :supersede)
      (format s ";;;; generated by (write-traces-1)~%~%")
      (format s "(in-package :cl-user)~%~%")
      (format s "(defparameter ~A '(~%" varname)
      (loop for i from 0 below *number-of-traces*
	    for trace in traces do
	(format s "  ~A ; trace ~A ~%" trace i))
      (format s " ))~%"))
    file))

(defun print-variable (stream state name index)
  (case (elt state index)
    (1 (format stream "    <value variable=\"~A\">TRUE</value>~%" name))
    (2 (format stream "    <value variable=\"~A\">FALSE</value>~%" name))
    (t nil)))

(defun write-trace-xml (trace &optional (id 0) (stream t))
  (format stream "<?xml version=\"1.0\" encoding=\"UTF-8\"?>~%")
  (format stream "<counter-example type=\"0\" id=\"~D\" desc=\"LTL Counterexample\">~%" id)
  (loop for i from 1
	for state in trace do
    (format stream "  <node><state id=\"~D\">~%" i)
    (print-variable stream state "p" 0)
    (print-variable stream state "q" 1)
    (print-variable stream state "r" 2)
    (print-variable stream state "s" 3)
    (print-variable stream state "t" 4)
    (print-variable stream state "z" 5)
    (format stream "  </state></node>~%"))
  (format stream "</counter-example>~%"))

(defun write-traces-xml (filename traces)
  (format t "writing traces in XML format: ")
  (ensure-directories-exist (merge-pathnames "traces/" #.*compile-file-pathname*))
  (loop for id from 1
	for trace in traces
	do
    (format t "~D " id)
    (let ((file (merge-pathnames (format nil "traces/~A-~D.xml" filename id)
				 #.*compile-file-pathname*)))
      (with-open-file (s file :direction :output :if-exists :supersede)
	(write-trace-xml trace id s))))
  (format t "~%"))

(defun print-variable-csv (stream state index)
  (case (elt state index)
    (1 (format stream ", true"))
    (2 (format stream ", false"))
    (t (format stream ", "))))

(defun write-trace-csv (trace &optional (stream t))
  (format stream "time, p, q, r, s, t, z~%")
  (loop for i from 1
	for state in trace do
    (format stream "~D" i)
    (print-variable-csv stream state 0)
    (print-variable-csv stream state 1)
    (print-variable-csv stream state 2)
    (print-variable-csv stream state 3)
    (print-variable-csv stream state 4)
    (print-variable-csv stream state 5)
    (format stream "~%")))

(defun write-traces-csv (filename traces)
  (format t "writing traces in CSV format: ")
  (ensure-directories-exist (merge-pathnames "traces/" #.*compile-file-pathname*))
  (loop for id from 1
	for trace in traces do
    (format t "~D " id)
    (let ((file (merge-pathnames (format nil "traces/~A-~D.csv" filename id)
				 #.*compile-file-pathname*)))
      (with-open-file (s file :direction :output :if-exists :supersede)
	(write-trace-csv trace s))))
  (format t "~%"))

;; This generates 2*500 random partial-observable traces in "traces/" directory
(defun run ()
  (make-traces)
  (write-traces-csv "trace" *traces*)
  (write-traces-xml "trace" *traces*))
