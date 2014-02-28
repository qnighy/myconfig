(add-to-list 'load-path (concat myconfig-site-lisp "/evil"))
(require 'evil)
(evil-mode 1)

; tabs
(define-key evil-normal-state-map "gT" 'tabbar-backward-tab)
(define-key evil-normal-state-map "gt" 'tabbar-forward-tab)

; ProofGeneral
(define-key evil-normal-state-map "gj" 'proof-assert-next-command-interactive)
(define-key evil-normal-state-map "gk" 'proof-undo-last-successful-command)
(define-key evil-normal-state-map "gpj" 'proof-process-buffer)
(define-key evil-normal-state-map "gpk" 'proof-retract-buffer)
