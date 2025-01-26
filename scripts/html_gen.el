(require 'org)

(setq org-publish-project-alist
	  '(
		("org-posts"
		 :base-directory "./posts/"
		 :base-extension "org"
		 :publishing-directory "./.site/temp_posts"
		 :recursive t
		 :publishing-function org-html-publish-to-html
		 :headline-levels 4
		 :html-extension "html"
		 :body-only t
		 )
		("my-logic-world" :components ("org-posts"))
		)
	  )

(org-publish-project "my-logic-world" t)
