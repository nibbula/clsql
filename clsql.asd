;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:          clsql.system
;;;; Purpose:       Defsystem-3/4 for CLSQL
;;;; Programmer:    Kevin M. Rosenberg
;;;; Date Started:  Feb 2002
;;;;
;;;; $Id: clsql.asd,v 1.2 2002/08/18 04:04:34 kevin Exp $
;;;;
;;;; This file, part of CLSQL, is Copyright (c) 2002 by Kevin M. Rosenberg
;;;;
;;;; CLSQL users are granted the rights to distribute and use this software
;;;; as governed by the terms of the Lisp Lesser GNU Public License
;;;; (http://opensource.franz.com/preamble.html), also known as the LLGPL.
;;;; *************************************************************************

(declaim (optimize (debug 3) (speed 3) (safety 1) (compilation-speed 0)))
(in-package :make)

;; For use with non-Debian installations
(let ((helper-pathname (make-pathname :name "set-cl-library" :type "cl"
				      :defaults *load-truename*)))
  (when (probe-file helper-pathname)
      (load helper-pathname)))

(in-package :asdf)

;;; System definitions

(unless (ignore-errors (find-class 'clsql-cl-source-file))
  (defclass clsql-cl-source-file (cl-source-file) ())
  (defmethod source-file-type ((c clsql-cl-source-file) (s module)) 
    "cl"))

(defsystem clsql
    :default-component-class clsql-cl-source-file
    :pathname "cl-library:clsql;"
    :perform (load-op :after (op clsql)
		      (pushnew :clsql cl:*features*))
    :components ((:file "package")
		 (:file "pool" :depends-on ("package"))
		 (:file "loop-extension")
		 (:file "sql" :depends-on ("pool"))
		 (:file "transactions" :depends-on ("sql"))
		 (:file "functional" :depends-on ("sql"))
		 (:file "usql" :depends-on ("sql")))
    :depends-on (:clsql-base)
    )
