CSS_FILES := $(wildcard style/*.css)
ORG_FILES := $(wildcard posts/*.org)
TEMP_FILES := $(patsubst posts/%.org, .site/temp_posts/%.html, $(ORG_FILES))
POSTS := $(patsubst posts/%.org, .site/posts/%.html, $(ORG_FILES))
TEMPLATES := $(wildcard templates/*.html)

all: .site/style.css $(POSTS)

.site/posts/%.html: .site/temp_posts/%.html scripts/posts_gen.jl $(TEMPLATES) | .site/posts/
	julia scripts/posts_gen.jl $*

.site/posts/: | .site/
	mkdir .site/posts/

$(TEMP_FILES) &: $(ORG_FILES) scripts/html_gen.el | .site/temp_posts/
	emacs --script scripts/html_gen.el

.site/temp_posts/: | .site/
	mkdir .site/temp_posts/

.site/style.css: $(CSS_FILES) scripts/style_gen.jl | .site/
	julia scripts/style_gen.jl

.site/:
	mkdir .site/

clean:
	rm -rf .site/
