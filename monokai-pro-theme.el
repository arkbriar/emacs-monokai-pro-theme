;;; monokai-pro-theme.el --- A simple grayscale theme

;; Copyright (C) 2019  Kaleb Elwert

;; Author: Kaleb Elwert <kaleb@coded.io>
;; Maintainer: Kaleb Elwert <kaleb@coded.io>
;; Version: 0.1
;; URL: https://github.com/belak/emacs-monokai-pro-theme
;; Keywords: lisp

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This theme is a simple theme based on the monokai-pro colors.

;;; Code:

(defvar monokai-pro-colors
  '(;; Background and foreground colors
    :bg     "#2d2a2e"
    :bg+1   "#353236"
    :bg+2   "#403e41"
    :fg-4   "#5b595c"
    :fg-3   "#727072"
    :fg-2   "#939293"
    :fg-1   "#c1c0c0"
    :fg     "#fcfcfa"

    ;; General colors
    :white  "#ffffff"
    :red    "#ff6188"
    :orange "#fc9867"
    :yellow "#ffd866"
    :green  "#a9dc76"
    :blue   "#78dce8"
    :purple "#ab9df2"
    :pink   "#ff6188"))


(defun monokai-pro-theme-transform-spec (spec colors)
  "Transform a theme `SPEC' into a face spec using `COLORS'."
  (let ((output))
    (while spec
      (let* ((key       (car  spec))
             (value     (cadr spec))
             (color-key (if (symbolp value) (intern (concat ":" (symbol-name value))) nil))
             (color     (plist-get colors color-key)))

        ;; Append the transformed element
        (cond
         ((and (memq key '(:box :underline)) (listp value))
          (setq output (append output (list key (monokai-pro-theme-transform-spec value colors)))))
         (color
          (setq output (append output (list key color))))
         (t
          (setq output (append output (list key value))))))

      ;; Go to the next element in the list
      (setq spec (cddr spec)))

    ;; Return the transformed spec
    output))

(defun monokai-pro-theme-transform-face (spec colors)
  "Transform a face `SPEC' into an Emacs theme face definition using `COLORS'."
  (let* ((face             (car spec))
         (definition       (cdr spec)))

    (list face `((t ,(monokai-pro-theme-transform-spec definition colors))))))

(defun monokai-pro-theme-set-faces (theme-name colors faces)
  "Define the important part of `THEME-NAME' using `COLORS' to map the `FACES' to actual colors."
  (apply 'custom-theme-set-faces theme-name
         (mapcar #'(lambda (face)
                     (monokai-pro-theme-transform-face face colors))
                 faces)))

(deftheme monokai-pro)
(monokai-pro-theme-set-faces
 'monokai-pro
 monokai-pro-colors

 '(
;;; Built-in

;;;; basic colors
   ;;(border                                       :background bg+2)
   (cursor                                       :background fg)
   (default                                      :foreground fg :background bg)

   ;; TODO: bg matches what's in the sublime theme here, not bg+2
   (fringe                                       :background bg+2)

   ;;(gui-element                                  :background bg+1)
   (header-line                                  :background nil :inherit mode-line)

   ;; TODO: This matches highlight and findHighlight, but we may want
   ;; to look at findHighlightForeground which is simply bg.
   (highlight                                    :foreground fg-3 :background bg+1)

   (link                                         :foreground blue :underline t)
   (link-visited                                 :foreground purple :underline t)

   (minibuffer-prompt                            :foreground fg)
   (region                                       :background bg+2)
   (secondary-selection                          :background bg+2)
   (trailing-whitespace                          :foreground fg :background red)
   (widget-button                                :underline t)
   (widget-field                                 :background fg-1 :box (:line-width 1 :color bg+2))

   (error                                        :foreground red    :weight bold)
   (warning                                      :foreground orange :weight bold)
   (success                                      :foreground green  :weight bold)

;;;; font-lock
   (font-lock-builtin-face                       :foreground purple)
   (font-lock-comment-delimiter-face             :foreground fg-3)
   (font-lock-comment-face                       :foreground fg-3 :slant italic)
   (font-lock-constant-face                      :foreground purple)
   (font-lock-doc-face                           :foreground fg-3)
   (font-lock-doc-string-face                    :foreground fg-3)
   (font-lock-function-name-face                 :foreground green)
   (font-lock-keyword-face                       :foreground pink)
   ;;(font-lock-negation-char-face                 :foreground fg-1)
   ;;(font-lock-preprocessor-face                  :foreground fg-1)
   ;;(font-lock-regexp-grouping-backslash          :foreground fg-1)
   ;;(font-lock-regexp-grouping-construct          :foreground fg)
   (font-lock-string-face                        :foreground yellow)
   (font-lock-type-face                          :foreground blue)
   (font-lock-variable-name-face                 :foreground fg)
   (font-lock-warning-face                       :foreground orange)

;;;; isearch
   (match                                        :foreground yellow :background bg :inverse-video t)

   ;; TODO: Revisit this - doesn't seem to map properly onto tmThemes
   (isearch                                      :foreground bg :background yellow :weight bold)
   (lazy-highlight                               :foreground fg-1 :inverse-video t)
   (isearch-fail                                 :foreground red :background fg)

;;;; line-numbers
   (line-number                                  :foreground fg-2)
   (line-number-current-line                     :foreground bg+2 :inverse-video t :inherit line-number)

;;;; linum-mode
   (linum                                        :foreground fg-3 :inherit fringe)
   (linum-highlight-face                         :foreground bg+2 :background fg-2)

;;;; mode-line
   (mode-line                                    :foreground fg-2 :background bg+1)
   (mode-line-buffer-id                          :foreground yellow :background nil)
   (mode-line-emphasis                           :foreground fg-1 :slant italic)
   (mode-line-highlight                          :foreground fg :box nil :weight bold)
   (mode-line-inactive                           :foreground fg-2 :background bg+2)

;;; Third-party

;;;; anzu-mode
   ;;    (anzu-mode-line                               :foreground yellow)

;;;; company-mode
   ;; TODO: These don't feel quite right
   (company-tooltip                              :background bg+2 :inherit default)
   (company-scrollbar-bg                         :background bg+1)
   (company-scrollbar-fg                         :background fg-1)
   (company-tooltip-annotation                   :foreground red)
   (company-tooltip-common                       :foreground yellow)
   (company-tooltip-selection                    :background bg+1)
   (company-preview-common                       :foreground fg-1 :background blue)

   ;; ;;;; diff-hl-mode
   ;;    (diff-hl-change                               :background blue  :foreground blue+1)
   ;;    (diff-hl-delete                               :background red   :foreground red+1)
   ;;    (diff-hl-insert                               :background green :foreground green+1)

;;;; diff-mode
   (diff-added                                   :foreground green)
   (diff-changed                                 :foreground purple)
   (diff-removed                                 :foreground red)
   (diff-header                                  :background bg)
   (diff-file-header                             :background bg+1)
   (diff-hunk-header                             :foreground pink :background bg)

;;;; flycheck-mode
   (flycheck-error                               :underline (:style wave :color red))
   (flycheck-info                                :underline (:style wave :color yellow))
   (flycheck-warning                             :underline (:style wave :color orange))

;;;; flyspell-mode
   (flyspell-duplicate                           :underline (:style wave :color orange))
   (flyspell-incorrect                           :underline (:style wave :color red))

;;;; hl-line-mode
   (hl-line                                      :background bg+1)

;;;; ido-mode
   ;; TODO: These don't feel quite right
   (ido-subdir                                   :foreground fg-2)
   (ido-first-match                              :foreground orange)
   (ido-only-match                               :foreground green)
   (ido-indicator                                :foreground red :background bg+2)
   (ido-virtual                                  :foreground fg-2)

;;;; ido-vertical-mode
   (ido-vertical-match-face                      :foreground fg-1)

;;;; show-paren-mode
   (show-paren-match                             :inverse-video t)
   (show-paren-mismatch                          :background red :inverse-video t)

   ))

;; Anything leftover that doesn't fall neatly into a face goes here.
(let ((bg      (plist-get monokai-pro-colors :bg))
      (fg      (plist-get monokai-pro-colors :fg))
      (red     (plist-get monokai-pro-colors :red))
      (green   (plist-get monokai-pro-colors :green))
      (yellow  (plist-get monokai-pro-colors :yellow))
      (blue    (plist-get monokai-pro-colors :blue))
      (magenta (plist-get monokai-pro-colors :purple))
      (cyan    (plist-get monokai-pro-colors :pink)))
  (custom-theme-set-variables
   'monokai-pro
   `(ansi-color-names-vector
     ;; black, base08, base0B, base0A, base0D, magenta, cyan, white
     [,bg ,red ,green ,yellow ,blue ,magenta ,cyan ,fg])
   `(ansi-term-color-vector
     ;; black, base08, base0B, base0A, base0D, magenta, cyan, white
     [unspecified ,bg ,red ,green ,yellow ,blue ,magenta ,cyan ,fg])))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'monokai-pro)

(provide 'monokai-pro-theme)

;;; monokai-pro-theme.el ends here
