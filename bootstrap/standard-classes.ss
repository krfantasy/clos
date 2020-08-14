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

(library (clos bootstrap standard-classes)

  (export <class>
          <top>
          <object>
          <procedure-class>
          <entity-class>
          <generic>
          <method>

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

          bootstrap-make)

  (import (only (rnrs)
                define quote begin lambda let cond or eq? else error
                list if null? car pair? boolean? symbol? procedure?
                number? vector? hashtable? char? string? input-port?
                output-port? port? cons reverse not complex? real? rational? integer? fixnum? flonum?
                list? bytevector? eof-object?
                condition? warning? message-condition? irritants-condition? who-condition?
                serious-condition? error? violation? assertion-violation? non-continuable-violation?
                implementation-restriction-violation? lexical-violation? syntax-violation?
                undefined-violation?
                record? record-type-descriptor?
                )

          (clos private allocation)
          (clos private core-class-layout)
          (clos slot-access)
          (clos introspection)
          (clos std-protocols make)
          (clos std-protocols allocate-instance)
          (clos std-protocols initialize)
          (clos std-protocols class-initialization))

  (define <class>
    (really-allocate-instance 'ignore core-class-slot-count))

  (define <top>
    (really-allocate-instance <class> core-class-slot-count))

  (define <object>
    (really-allocate-instance <class> core-class-slot-count))

  (define bootstrap-initialize
    (begin

      (set-instance-class-to-self! <class>)
      (register-class-of-classes!  <class>)

      (lambda (inst init-args)
        (let ((class (class-of inst)))
          (cond
            ((or (eq? class <class>)
                 (eq? class <procedure-class>)
                 (eq? class <entity-class>)
                 (eq? class <primitive-class>))
             (class-initialize inst init-args
                               class-compute-precedence-list
                               class-compute-slots
                               class-compute-getter-and-setter))
            ((eq? class <generic>)
             (generic-initialize inst init-args))
            ((eq? class <method>)
             (method-initialize inst init-args))
            (else
             (error 'bootstrap-initialize
                    "cannot initialize instance of class ~a" class)))))))

  (define bootstrap-allocate-instance
    (begin

      (bootstrap-initialize <top>
        (list 'definition-name '<top>
              'direct-supers   (list)
              'direct-slots    (list)))

      (bootstrap-initialize <object>
        (list 'definition-name '<object>
              'direct-supers   (list <top>)
              'direct-slots    (list)))

      (bootstrap-initialize <class>
        (list 'definition-name '<class>
              'direct-supers   (list <object>)
              'direct-slots    core-class-slot-names))

      (lambda (class)
        (let ((class-of-class (class-of class)))
          (cond
            ((eq? class-of-class <class>)
             (class-allocate-instance class))
            ((eq? class-of-class <entity-class>)
             (entity-class-allocate-instance class))
            (else
             (error 'bootstrap-allocate-instance
                    "cannot allocate instance for class ~a" class)))))))

  (define (bootstrap-make class . init-args)
    (class-make class init-args
                bootstrap-allocate-instance
                bootstrap-initialize))

  (define <procedure-class>
    (bootstrap-make <class>
      'definition-name '<procedure-class>
      'direct-supers   (list <class>)
      'direct-slots    (list)))

  (define <entity-class>
    (bootstrap-make <class>
      'definition-name '<entity-class>
      'direct-supers   (list <procedure-class>)
      'direct-slots    (list)))

  (define <generic>
    (bootstrap-make <entity-class>
      'definition-name '<generic>
      'direct-supers   (list <object>)
      'direct-slots    (list 'methods)))

  (define <method>
    (bootstrap-make <class>
      'definition-name '<method>
      'direct-supers   (list <object>)
      'direct-slots    (list 'specializers
                             'qualifier
                             'procedure)))

  (define <primitive-class>
    (bootstrap-make <class>
      'definition-name '<primitive-class>
      'direct-supers   (list <class>)
      'direct-slots    (list)))

  (define (make-primitive-class name . class)
    (bootstrap-make (if (null? class) <primitive-class> (car class))
      'definition-name name
      'direct-supers   (list <top>)
      'direct-slots    (list)))

  (define (make-primitive-subclass name . supers)
    (bootstrap-make <primitive-class>
      'definition-name name
      'direct-supers   supers
      'direct-slots    (list)))

  (define <pair>        (make-primitive-class '<pair>))
  (define <list>        (make-primitive-subclass '<list> <pair>))
  (define <null>        (make-primitive-subclass '<null> <list>))
  (define <symbol>      (make-primitive-class '<symbol>))
  (define <boolean>     (make-primitive-class '<boolean>))
  (define <procedure>   (make-primitive-class '<procedure> <procedure-class>))

  ;; number
  (define <number>      (make-primitive-class '<number>))
  (define <complex>     (make-primitive-subclass '<complex> <number>))
  (define <real>        (make-primitive-subclass '<real> <complex>))
  (define <rational>    (make-primitive-subclass '<rational> <real>))
  (define <integer>     (make-primitive-subclass '<integer> <rational>))
  (define <fixnum>      (make-primitive-subclass '<fixnum> <integer>))
  (define <flonum>      (make-primitive-subclass '<flonum> <real>))

  (define <vector>      (make-primitive-class '<vector>))
  (define <hashtable>   (make-primitive-class '<hashtable>))
  (define <bytevector>  (make-primitive-class '<bytevector>))
  (define <char>        (make-primitive-class '<char>))
  (define <string>      (make-primitive-class '<string>))
  (define <eof-object>  (make-primitive-class '<eof-object>))

  ;; port
  (define <port>        (make-primitive-class '<port>))
  (define <input-port>  (make-primitive-subclass '<input-port> <port>))
  (define <output-port> (make-primitive-subclass '<output-port> <port>))
  (define <input/output-port>
    (make-primitive-subclass '<input/output-port> <input-port> <output-port>))

  (define <record>      (make-primitive-class '<record>))
  (define <record-type-descriptor> (make-primitive-subclass '<record-type-descriptor> <record>))

  ;; condition
  (define <condition>   (make-primitive-subclass '<condition> <record>))
  (define <warning> (make-primitive-subclass '<warning> <condition>))
  (define <message-condition> (make-primitive-subclass '<message-condition> <condition>))
  (define <irritants-condition> (make-primitive-subclass '<irritants-condition> <condition>))
  (define <who-condition> (make-primitive-subclass '<who-condition> <condition>))
  (define <serious-condition> (make-primitive-subclass '<serious-condition> <condition>))
  (define <error> (make-primitive-subclass '<error> <serious-condition>))
  (define <violation> (make-primitive-subclass '<violation> <serious-condition>))
  (define <assertion-violation> (make-primitive-subclass '<assertion-violation> <violation>))
  (define <non-continuable-violation>
    (make-primitive-subclass '<non-continuable-violation> <violation>))
  (define <implementation-restriction-violation>
    (make-primitive-subclass '<implementation-restriction-violation> <violation>))
  (define <lexical-violation> (make-primitive-subclass '<lexical-violation> <violation>))
  (define <syntax-violation> (make-primitive-subclass '<syntax-violation> <violation>))
  (define <undefined-violation> (make-primitive-subclass '<undefined-violation> <violation>))

  (define (primitive-class-of x)
    (cond
      ((null? x)        <null>)
      ((pair? x)        (if (list? x) <list> <pair>))
      ((boolean? x)     <boolean>)
      ((symbol? x)      <symbol>)
      ((procedure? x)   <procedure>)
      ((number? x)
       (cond
        ((fixnum? x)    <fixnum>)
        ((flonum? x)    <flonum>)
        ((integer? x)   <integer>)
        ((rational? x)  <rational>)
        ((real? x)      <real>)
        ((complex? x)   <complex>)
        (else           <number>)))

      ((char? x)        <char>)
      ((string? x)      <string>)
      ((vector? x)      <vector>)
      ((hashtable? x)   <hashtable>)
      ((bytevector? x)  <bytevector>)
      ((eof-object? x)  <eof-object>)

      ((port? x)
       (cond
        ((not (output-port? x)) <input-port>)
        ((not (input-port? x))  <output-port>)
        (else                   <input/output-port>)))

      ((condition? x)
       (cond
        ((warning? x)               <warning>)
        ((message-condition? x)     <message-condition>)
        ((irritants-condition? x)   <irritants-condition>)
        ((who-condition? x)         <who-condition>)
        ((serious-condition? x)     (cond
                                     ((error? x) <error>)
                                     ((violation? x) (cond
                                                      ((assertion-violation? x)
                                                       <assertion-violation>)
                                                      ((non-continuable-violation? x)
                                                       <non-continuable-violation>)
                                                      ((implementation-restriction-violation? x)
                                                       <implementation-restriction-violation>)
                                                      ((lexical-violation? x)
                                                       <lexical-violation>)
                                                      ((syntax-violation? x)
                                                       <syntax-violation>)
                                                      ((undefined-violation? x)
                                                       <undefined-violation>)
                                                      (else
                                                       <violation>)))
                                     (else <serious-condition>)))
        (else <condition>)))

      ((record? x)      (if (record-type-descriptor? x) <record-type-descriptor> <record>))
      (else             <top>)))

  (set-primitive-class-of! primitive-class-of)

  ) ;; library (clos bootstrap standard-classes)
