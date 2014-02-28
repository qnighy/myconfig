(if window-system
    (progn
      (defface hlline-face
        '((((class color)
            (background dark))
           ;;(:background "dark state gray"))
           (:background "#1a1a1a"
                        :underline "#3d3d3d"))
          (((class color)
            (background light))
           (:background "#fffacd"
                        :underline nil))
          (t ()))
  "*Face used by hl-line.")))
(setq hl-line-face 'hlline-face)
;;(setq hl-line-face 'underline)
(global-hl-line-mode)
;(add-to-list 'default-frame-alist '(foreground-color . "#000000"))
;(add-to-list 'default-frame-alist '(background-color . "#FFFFFF"))
