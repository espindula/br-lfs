<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
<!ENTITY docbook.dsl SYSTEM "docbook.dsl" CDATA dsssl>
]>

<style-sheet>

<style-specification use="docbook">
<style-specification-body>

(define %generate-legalnotice-link%
#t)

(define ($legalnotice-link-file$ legalnotice)
(string-append "legalnotice"%html-ext%))

(define %html-ext%
".html")

(define %root-filename%
"index")

(define %use-id-as-filename%
#t)

(define %body-attr%
  (list
    (list "BGCOLOR" "#FFFFFF")
    (list "TEXT" "#000000")
    (list "LINK" "#0000FF")
    (list "VLINK" "#840084")
    (list "ALINK" "#006000")))

</style-specification-body>
</style-specification>

<external-specification id="docbook" document="docbook.dsl">

</style-sheet>

