;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Package: odbc -*-
;;;; *************************************************************************
;;;; FILE IDENTIFICATION
;;;;
;;;; Name:     odbc-ff-interface.lisp
;;;; Purpose:  Function definitions for UFFI interface to ODBC
;;;; Author:   Kevin M. Rosenberg
;;;;
;;;; $Id: odbc-package.lisp 7061 2003-09-07 06:34:45Z kevin $
;;;;
;;;; This file, part of CLSQL, is Copyright (c) 2004 by Kevin M. Rosenberg
;;;; and Copyright (C) Paul Meurer 1999 - 2001. All rights reserved.
;;;;
;;;; CLSQL users are granted the rights to distribute and use this software
;;;; as governed by the terms of the Lisp Lesser GNU Public License
;;;; (http://opensource.franz.com/preamble.html), also known as the LLGPL.
;;;; *************************************************************************

(in-package #:odbc)

(def-foreign-type sql-handle (* :void))
(def-foreign-type sql-handle-ptr (* sql-handle))
(def-foreign-type string-ptr (* :void))

(def-type long-ptr-type '(* :long))


(def-function "SQLAllocEnv"
    ((*phenv sql-handle-ptr)    ; HENV   FAR *phenv
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLAllocConnect"
    ((henv sql-handle)          ; HENV        henv
     (*phdbc sql-handle-ptr)    ; HDBC   FAR *phdbc
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLConnect"
    ((hdbc sql-handle)          ; HDBC        hdbc
     (*szDSN string-ptr)        ; UCHAR  FAR *szDSN
     (cbDSN :short)             ; SWORD       cbDSN
     (*szUID string-ptr)        ; UCHAR  FAR *szUID 
     (cbUID :short)             ; SWORD       cbUID
     (*szAuthStr string-ptr)    ; UCHAR  FAR *szAuthStr
     (cbAuthStr :short)         ; SWORD       cbAuthStr
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLDriverConnect"
    ((hdbc sql-handle)          ; HDBC        hdbc
     (hwnd sql-handle)          ; SQLHWND     hwnd
     (*szConnStrIn string-ptr)  ; UCHAR  FAR *szConnStrIn
     (cbConnStrIn :short)       ; SWORD       cbConnStrIn
     (*szConnStrOut string-ptr) ; UCHAR  FAR *szConnStrOut
     (cbConnStrOutMax :short)   ; SWORD       cbConnStrOutMax
     (*pcbConnStrOut :pointer-void)      ; SWORD  FAR *pcbConnStrOut
     (fDriverCompletion :short) ; UWORD       fDriverCompletion
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLDisconnect"
    ((hdbc sql-handle))         ; HDBC        hdbc
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API
  
(def-function "SQLAllocStmt"
    ((hdbc sql-handle)          ; HDBC        hdbc
     (*phstmt sql-handle-ptr)   ; HSTMT  FAR *phstmt
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLGetInfo"
    ((hdbc sql-handle)          ; HDBC        hdbc
     (fInfoType :short)         ; UWORD       fInfoType
     (rgbInfoValue :pointer-void)        ; PTR         rgbInfoValue
     (cbInfoValueMax :short)    ; SWORD       cbInfoValueMax
     (*pcbInfoValue :pointer-void)       ; SWORD  FAR *pcbInfoValue
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLPrepare"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (*szSqlStr string-ptr)     ; UCHAR  FAR *szSqlStr
     (cbSqlStr :long)           ; SDWORD      cbSqlStr
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLExecute"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLExecDirect"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (*szSqlStr string-ptr)     ; UCHAR  FAR *szSqlStr
     (cbSqlStr :long)           ; SDWORD      cbSqlStr
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLFreeStmt"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (fOption :short))          ; UWORD       fOption
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

  (def-function "SQLCancel"
      ((hstmt sql-handle)         ; HSTMT       hstmt
       )
    :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLError"
    ((henv sql-handle)          ; HENV        henv
     (hdbc sql-handle)          ; HDBC        hdbc
     (hstmt sql-handle)         ; HSTMT       hstmt
     (*szSqlState string-ptr)   ; UCHAR  FAR *szSqlState
     (*pfNativeError :pointer-void)      ; SDWORD FAR *pfNativeError
     (*szErrorMsg string-ptr)   ; UCHAR  FAR *szErrorMsg
     (cbErrorMsgMax :short)     ; SWORD       cbErrorMsgMax
     (*pcbErrorMsg :pointer-void)        ; SWORD  FAR *pcbErrorMsg
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLNumResultCols"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (*pccol :pointer-void)              ; SWORD  FAR *pccol
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLRowCount"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (*pcrow :pointer-void)              ; SDWORD FAR *pcrow
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLDescribeCol"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (icol :short)              ; UWORD       icol
     (*szColName string-ptr)    ; UCHAR  FAR *szColName
     (cbColNameMax :short)      ; SWORD       cbColNameMax
     (*pcbColName :pointer-void)         ; SWORD  FAR *pcbColName
     (*pfSqlType :pointer-void)          ; SWORD  FAR *pfSqlType
     (*pcbColDef :pointer-void)          ; UDWORD FAR *pcbColDef
     (*pibScale :pointer-void)           ; SWORD  FAR *pibScale
     (*pfNullable :pointer-void)         ; SWORD  FAR *pfNullable
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLColAttributes"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (icol :short)              ; UWORD       icol
     (fDescType :short)         ; UWORD       fDescType
     (rgbDesc :pointer-void)             ; PTR         rgbDesc
     (cbDescMax :short)         ; SWORD       cbDescMax
     (*pcbDesc :pointer-void)            ; SWORD  FAR *pcbDesc
     (*pfDesc :pointer-void)             ; SDWORD FAR *pfDesc
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLColumns"
    ((hstmt sql-handle)             ; HSTMT       hstmt
     (*szTableQualifier string-ptr) ; UCHAR  FAR *szTableQualifier
     (cbTableQualifier :short)      ; SWORD       cbTableQualifier
     (*szTableOwner string-ptr)     ; UCHAR  FAR *szTableOwner
     (cbTableOwner :short)          ; SWORD       cbTableOwner
     (*szTableName string-ptr)      ; UCHAR  FAR *szTableName
     (cbTableName :short)           ; SWORD       cbTableName
     (*szColumnName string-ptr)     ; UCHAR  FAR *szColumnName
     (cbColumnName :short)          ; SWORD       cbColumnName
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLBindCol"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (icol :short)              ; UWORD       icol
     (fCType :short)            ; SWORD       fCType
     (rgbValue :pointer-void)            ; PTR         rgbValue
     (cbValueMax :long)         ; SDWORD      cbValueMax
     (*pcbValue :pointer-void)           ; SDWORD FAR *pcbValue
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLFetch"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLTransact"
    ((henv sql-handle)          ; HENV        henv
     (hdbc sql-handle)          ; HDBC        hdbc
     (fType :short)             ; UWORD       fType ($SQL_COMMIT or $SQL_ROLLBACK)
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

;; ODBC 2.0
(def-function "SQLDescribeParam"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (ipar :short)              ; UWORD       ipar
     (*pfSqlType :pointer-void)          ; SWORD  FAR *pfSqlType
     (*pcbColDef :pointer-void)          ; UDWORD FAR *pcbColDef
     (*pibScale :pointer-void)           ; SWORD  FAR *pibScale
     (*pfNullable :pointer-void)         ; SWORD  FAR *pfNullable
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

;; ODBC 2.0
(def-function "SQLBindParameter"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (ipar :short)              ; UWORD       ipar
     (fParamType :short)        ; SWORD       fParamType
     (fCType :short)            ; SWORD       fCType
     (fSqlType :short)          ; SWORD       fSqlType
     (cbColDef :long)           ; UDWORD      cbColDef
     (ibScale :short)           ; SWORD       ibScale
     (rgbValue :pointer-void)            ; PTR         rgbValue
     (cbValueMax :long)         ; SDWORD      cbValueMax
     (*pcbValue :pointer-void)           ; SDWORD FAR *pcbValue
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

;; level 1
(def-function "SQLGetData"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (icol :short)              ; UWORD       icol
     (fCType :short)            ; SWORD       fCType
     (rgbValue :pointer-void)            ; PTR         rgbValue
     (cbValueMax :long)         ; SDWORD      cbValueMax
     (*pcbValue :pointer-void)           ; SDWORD FAR *pcbValue
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLParamData"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (*prgbValue :pointer-void)          ; PTR    FAR *prgbValue
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLPutData"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (rgbValue :pointer-void)            ; PTR         rgbValue
     (cbValue :long)            ; SDWORD      cbValue
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLGetConnectOption"
    ((hdbc sql-handle)          ; HDBC        hdbc
     (fOption :short)           ; UWORD       fOption
     (pvParam :pointer-void)             ; PTR         pvParam
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLSetConnectOption"
    ((hdbc sql-handle)          ; HDBC        hdbc
     (fOption :short)           ; UWORD       fOption
     (vParam :long)             ; UDWORD      vParam
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLSetPos"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (irow :short)              ; UWORD       irow
     (fOption :short)           ; UWORD       fOption
     (fLock :short)             ; UWORD       fLock
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

					; level 2
(def-function "SQLExtendedFetch"
    ((hstmt sql-handle)         ; HSTMT       hstmt
     (fFetchType :short)        ; UWORD       fFetchType
     (irow :long)               ; SDWORD      irow
     (*pcrow :pointer-void)              ; UDWORD FAR *pcrow
     (*rgfRowStatus :pointer-void)       ; UWORD  FAR *rgfRowStatus
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLDataSources"
    ((henv sql-handle)          ; HENV        henv
     (fDirection :short)
     (*szDSN string-ptr)        ; UCHAR  FAR *szDSN
     (cbDSNMax :short)          ; SWORD       cbDSNMax
     (*pcbDSN :pointer-void)             ; SWORD      *pcbDSN
     (*szDescription string-ptr) ; UCHAR     *szDescription
     (cbDescriptionMax :short)  ; SWORD       cbDescriptionMax
     (*pcbDescription :pointer-void)     ; SWORD      *pcbDescription
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API

(def-function "SQLFreeEnv"
    ((henv sql-handle)          ; HSTMT       hstmt
     )
  :module :odbc
  :returning :short)              ; RETCODE_SQL_API


;;; foreign type definitions

;;(defmacro %sql-len-data-at-exec (length) 
;;  `(- $SQL_LEN_DATA_AT_EXEC_OFFSET ,length))


(def-struct sql-c-time 
    (hour   :short)
  (minute :short)
  (second :short))

(def-struct sql-c-date
    (year  :short)
    (month :short)
    (day   :short))
  
(def-struct sql-c-timestamp
    (year     :short)
    (month    :short)
    (day      :short)
    (hour     :short)
    (minute   :short)
    (second   :short)
    (fraction :long))
