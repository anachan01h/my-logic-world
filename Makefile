CSS_FILES := $(wildcard style/*.css)
TEMPLATES := $(wildcard templates/*.html)
ORG_FILES := $(wildcard posts/*.org)
TEMP_FILES := $(patsubst posts/%.org, .site/temp_posts/%.html, $(ORG_FILES))
POSTS := $(patsubst posts/%.org, .site/posts/%.html, $(ORG_FILES))

all: .site/style.css .site/img/ .site/index.html clean-temp

# Create blog folder
.site/:
	mkdir .site/

# Copy img folder
.site/img/: | .site
	cp -r img/ .site/

# Merge .css files into style.css
.site/style.css: $(CSS_FILES) scripts/style_gen.jl | .site/
	julia scripts/style_gen.jl

# Create folder for the body of posts
.site/temp_posts/: | .site/
	mkdir .site/temp_posts/

# Generate the body of posts from .org files
$(TEMP_FILES) &: $(ORG_FILES) scripts/html_gen.el | .site/temp_posts/
	emacs --script scripts/html_gen.el

# Create folder for posts
.site/posts/: | .site/
	mkdir .site/posts/

# Generate posts from template and body
.site/posts/%.html: .site/temp_posts/%.html scripts/posts_gen.jl $(TEMPLATES) | .site/posts/
	julia scripts/posts_gen.jl $*

# Generate index.html
.site/index.html: scripts/index_gen.jl $(POSTS) $(TEMPLATES)
	julia scripts/index_gen.jl

# Clean temporary files
clean-temp:
	rm -rf .site/temp_posts/
	rm -f .site/index.csv

clean:
	rm -rf .site/
