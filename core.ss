; *************************************************************************
; Copyright (c) 1992 Xerox Corporation.
; All Rights Reserved.
;
; Use, reproduction, and preparation of derivative works are permitted.
; Any copy of this software or of any derivative work must include the
; above copyright notice of Xerox Corporation, this paragraph and the
; one after it.  Any distribution of this software or derivative works
; must comply with all applicable United States export control laws.
;
; This software is made available AS IS, and XEROX CORPORATION DISCLAIMS
; ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
; PURPOSE, AND NOTWITHSTANDING ANY OTHER PROVISION CONTAINED HEREIN, ANY
; LIABILITY FOR DAMAGES RESULTING FROM THE SOFTWARE OR ITS USE IS
; EXPRESSLY DISCLAIMED, WHETHER ARISING IN CONTRACT, TORT (INCLUDING
; NEGLIGENCE) OR STRICT LIABILITY, EVEN IF XEROX CORPORATION IS ADVISED
; OF THE POSSIBILITY OF SUCH DAMAGES.
; *************************************************************************
;
; port to R6RS -- 2007 Christian Sloma
;

(library (clos core)

  (export

   ;; classes

   <class>
   <top>
   <object>
   <procedure-class>
   <entity-class>
   <generic>
   <method>

   ;; primitive classes
   <pair>
   <list>
   <null>
   <symbol>
   <boolean>
   <procedure>

   <number>
   <complex>
   <real>
   <rational>
   <integer>
   <fixnum>
   <flonum>

   <vector>
   <hashtable>
   <bytevector>
   <char>
   <string>
   <eof-object>

   <port>
   <input-port>
   <output-port>
   <input/output-port>

   <condition>
   <warning>
   <serious-condition>
   <message-condition>
   <irritants-condition>
   <who-condition>
   <serious-condition>
   <error>
   <violation>
   <assertion-violation>
   <non-continuable-violation>
   <implementation-restriction-violation>
   <lexical-violation>
   <syntax-violation>
   <undefined-violation>

   <record>
   <record-type-descriptor>

   ;; generic functions

   make
   initialize
   allocate-instance
   compute-getter-and-setter
   compute-precedence-list
   compute-slots
   add-method
   compute-apply-generic
   compute-methods
   compute-method-more-specific?
   compute-apply-methods
   print-object

   ;; slot access

   slot-ref
   slot-set!

   ;; introspection

   class-of
   class-direct-supers
   class-direct-slots
   class-precedence-list
   class-slots
   class-definition-name
   generic-methods
   method-specializers
   method-procedure
   method-qualifier
   instance?
   class?
   primitive-class?
   subclass?
   generic?
   method?
   instance-of?

   ;; helpers

   get-arg
   unmangle-class-name
   print-unreadable-object
   print-object-with-slots
   initialize-direct-slots

   ) ;; export

  (import (clos bootstrap standard-classes)
          (only (clos bootstrap generic-functions)
                print-object compute-apply-methods
                compute-method-more-specific?
                compute-methods compute-apply-generic add-method
                compute-slots compute-precedence-list
                compute-getter-and-setter allocate-instance initialize
                make)
          (clos slot-access)
          (clos introspection)
          (clos private compat)
          (clos helpers))

  ) ;; library (clos core)
