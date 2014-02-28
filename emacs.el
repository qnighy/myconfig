(eval-when-compile (require 'cl))
(setq load-path (cons (concat (file-name-directory load-file-name) "/site-lisp") load-path))
(loop for x
      in (sort (remove-if-not (lambda (y) (string-match "/[0-9][0-9].*[.]el$" y))
                              (directory-files (concat (file-name-directory load-file-name) "/emacs.d") t)) 'string<)
      do (load-file x))
