;;; vague-theme.el -- Just a copy of the vague.nvim color palette for emacs...
;;; Commentary:

(deftheme vague "Usese vague.nvim color palette: https://github.com/vague-theme/vague.nvim")

(let* ((bg        "#141415")
       (fg        "#cdcdcd")
       (cursor    "#cdcdcd")
       (sel-bg    "#333738")

       ;; normal
       (black     "#141415")
       (red       "#d8647e")
       (green     "#7fa563")
       (yellow    "#e0a363")
       (blue      "#6e94b2")
       (magenta   "#bb9dbd")
       (cyan      "#9bb4bc")
       (white     "#cdcdcd")

       ;; bright
       (bblack    "#606079")
       (bred      "#d8647e")
       (bgreen    "#7fa563")
       (byellow   "#f3be7c")
       (bblue     "#7e98e8")
       (bmagenta  "#bb9dbd")
       (bcyan     "#b4d4cf")
       (bwhite    "#c3c3d5"))

  (custom-theme-set-faces
   'vague

   ;; Core UI
   `(default               ((t (:background ,bg :foreground ,fg))))
   `(cursor                ((t (:background ,cursor))))
   `(fringe                ((t (:background ,bg :foreground ,bblack))))
   `(region                ((t (:background ,sel-bg :foreground ,fg))))
   `(highlight             ((t (:background ,sel-bg))))
   `(shadow                ((t (:foreground ,bblack))))
   `(minibuffer-prompt     ((t (:background ,bg :foreground ,bblue :weight bold))))
   `(minibuffer-message    ((t (:background ,bg :foreground ,bblue :weight bold))))
   `(link                  ((t (:foreground ,bblue :underline t))))
   `(error                 ((t (:foreground ,red :weight bold))))
   `(warning               ((t (:foreground ,yellow :weight bold))))
   `(success               ((t (:foreground ,green :weight bold))))
   `(vertical-border       ((t (:foreground ,sel-bg))))
   `(line-number           ((t (:foreground ,bblack :background ,bg))))
   `(line-number-current-line ((t (:foreground ,fg :background ,bg :weight bold))))
   `(doom-dashboard        ((t (:background ,bg :foreground ,fg))))

   ;; Mode line
   `(mode-line             ((t (:background ,bg :foreground ,fg :box nil))))
   `(mode-line-inactive    ((t (:background ,bg :foreground ,bblack :box nil))))

   ;; Font lock (syntax)
   `(font-lock-builtin-face       ((t (:foreground ,magenta))))
   `(font-lock-comment-face       ((t (:foreground ,bblack :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,bblack))))
   `(font-lock-constant-face      ((t (:foreground ,cyan))))
   `(font-lock-function-name-face ((t (:foreground ,bblue :weight bold))))
   `(font-lock-keyword-face       ((t (:foreground ,magenta :weight bold))))
   `(font-lock-string-face        ((t (:foreground ,green))))
   `(font-lock-type-face          ((t (:foreground ,blue))))
   `(font-lock-variable-name-face ((t (:foreground ,fg))))
   `(font-lock-warning-face       ((t (:foreground ,red :weight bold))))

   ;; Search
   `(isearch              ((t (:background ,yellow :foreground ,black :weight bold))))
   `(lazy-highlight       ((t (:background ,sel-bg :foreground ,fg))))

   ;; Org (nice defaults)
   `(org-level-1          ((t (:foreground ,bblue :weight bold :height 1.15))))
   `(org-level-2          ((t (:foreground ,blue  :weight bold :height 1.10))))
   `(org-level-3          ((t (:foreground ,cyan  :weight bold))))
   `(org-code             ((t (:foreground ,bwhite))))
   `(org-verbatim         ((t (:foreground ,bwhite))))
   `(org-block            ((t (:background ,bg :foreground ,fg))))
   `(org-block-begin-line ((t (:foreground ,bblack))))
   `(org-block-end-line   ((t (:foreground ,bblack))))

   ;; Show parens
   `(show-paren-match     ((t (:background ,sel-bg :foreground ,bwhite :weight bold))))
   `(show-paren-mismatch  ((t (:background ,red :foreground ,black :weight bold)))))

  ;; Make Emacs' ANSI colors match your terminal palette (useful in M-x shell, compilation, etc.)
  (setq ansi-color-names-vector
        (vector black red green yellow blue magenta cyan white))
  (setq ansi-color-faces-vector
        [default
         (ansi-color-red) (ansi-color-green) (ansi-color-yellow)
         (ansi-color-blue) (ansi-color-magenta) (ansi-color-cyan) (ansi-color-white)]))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'vague)

;; Enable it:
;; (load-theme 'vague t)

;;; vague-theme.el ends here
