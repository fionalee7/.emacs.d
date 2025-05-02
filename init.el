(add-to-list 'load-path "/Users/jam/.emacs.d/elpa/eglot/")
(add-to-list 'load-path "/Users/jam/.emacs.d/elpa/go-mode/")
(cua-mode t)
(custom-set-variables
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages '(company eglot-inactive-regions))
)
(custom-set-faces
 '(default ((t (:inherit nil :stipple nil :background "#181a26" :foreground "gray80" :inverse-video nil :box nil :strike-through nil :extend nil :overline nil :underline nil :slant normal :weight normal :height 240 :width normal :foundry "nil" :family "Trebuchet MS")))))
;;
(setq shift-select-mode 'nil)
(recentf-mode 1)
(electric-pair-mode 1)
(setq electric-pair-pairs
      '(
	(?\" . ?\")
	(?\' . ?\')
	(?\( . ?\))
	(?\" . ?\")
	(?\[ . ?\])
	(?\{ . ?\})))
;; (global-set-key (kbd "C-S-<tab>") 'previous-buffer)		
(global-set-key (kbd "C-r") 'undo-redo)		
(global-set-key (kbd "C-f") 'isearch-forward)		
(global-set-key (kbd "C-s") 'save-buffer)		
(global-set-key (kbd "C-'") 'execute-extended-command)		
(global-set-key (kbd "C-,") 'tab-to-tab-stop)		
(global-set-key (kbd "M-x") 'comment-line)
(global-set-key (kbd "C-M-j") 'backward-sentence)
(global-set-key (kbd "C-M-m") 'forward-sentence)
(global-set-key (kbd "M-f") 'eval-buffer)
(global-set-key (kbd "C-M-,") 'move-end-of-line)
(global-set-key (kbd "C-M-n") 'move-beginning-of-line)
(global-set-key (kbd "M-h") 'backward-char)
(global-set-key (kbd "M-k") 'forward-char)
(global-set-key (kbd "M-n") 'backward-word)
(global-set-key (kbd "M-,") 'forward-word)
(global-set-key (kbd "M-m") 'next-line)
(global-set-key (kbd "M-j") 'previous-line)
(global-set-key (kbd "C-c 1") 'dired)
(global-set-key (kbd "C-c 2") 'recentf-open-files)
(global-set-key (kbd "C-<tab>") 'next-buffer)
(global-set-key (kbd "C-S-<tab>") 'previous-buffer)
(global-set-key (kbd "M-<f4>") 'save-buffers-kill-terminal)
(global-set-key (kbd "C-0") 'describe-bindings)
(global-set-key (kbd "C-w") 'kill-buffer)
(global-set-key (kbd "C-c w") 'kill-buffer-and-window)
(global-set-key (kbd "C-x w") 'delete-other-windows)
(global-set-key (kbd "M-l") 'kill-whole-line)
(global-set-key (kbd "M-.") 'set-mark-command)
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(when (>= emacs-major-version 28)
  (progn
    (setq completion-styles '(flex))
    (icomplete-vertical-mode)))

;; Optional: load other packages before eglot to enable eglot integrations.
(require 'company)
;; (require 'yasnippet)
(company-mode t)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-text-face-extra-attributes '(:weight bold :slant italic))
(setq company-show-quick-access 'left)
(setq company-backends '((company-capf company-dabbrev-code)))
(setq company-search-words-in-any-order-regexp t)
(setq company-tooltip-align-annotations t)
(setq company-tooltip-limit 7)
(setq company-dabbrev-code t)
(setq company-keywords t)
(setq company-clang t)
(setq company-semantic t)
(setq company-etags t)
(setq-local company-backends '(company-dabbrev)
            company-dabbrev-other-buffers nil
            company-dabbrev-ignore-case nil
            company-dabbrev-downcase nil)
(setq company-tooltip-margin 4)
;; (global-set-key (kbd "<tab>") #'company-indent-or-complete-common)
(require 'go-mode)
(require 'eglot)
(add-hook 'go-mode-hook 'eglot-ensure)

(require 'project)

(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

;; Optional: install eglot-format-buffer as a save hook.
;; The depth of -10 places this before eglot's willSave notification,
;; so that that notification reports the actual contents that will be saved.
(defun eglot-format-buffer-before-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
(add-hook 'go-mode-hook #'eglot-format-buffer-before-save)

(setq-default eglot-workspace-configuration
    '((:gopls .
        ((staticcheck . t)
         (matcher . "CaseSensitive")))))

(add-hook 'before-save-hook
    (lambda ()
        (call-interactively 'eglot-code-action-organize-imports))
    nil t)


