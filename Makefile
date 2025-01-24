CSS_FILES := $(wildcard style/*.css)

.site/style.css: $(CSS_FILES) | .site/
	julia scripts/style_gen.jl

.site/:
	mkdir .site

clean:
	rm -rf .site
