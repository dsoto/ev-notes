all: instructor student

student: docs_student site_student
instructor: docs_instructor site_instructor

# create list of targets from markdown source files

MD_SRC = $(wildcard raw_docs/*.md)
STUDENT_GENERATED = $(patsubst raw_docs/%.md,docs_student/%.md, $(MD_SRC))
INSTRUCTOR_GENERATED = $(patsubst raw_docs/%.md,docs_instructor/%.md, $(MD_SRC))

# added pdf-engine to deal with memory error
FLAGS = --katex --from markdown --to html --overwrite --pdf-engine=/Library/TeX/texbin/pdflatex

# convert from markdown to HTML for MkDocs to assemble later

docs_student/%.md: raw_docs/%.md
	@echo
	@echo --- build student doc ---
	@echo
	echo "import os; os.chdir('docs_student/')" > set_figure_location.py
	codebraid pandoc $< -o $@ $(FLAGS) \
	                 --filter ./filters/remove-solution-divs.py \
		             --filter ./filters/remove-instructor-divs.py

docs_instructor/%.md: raw_docs/%.md
	@echo
	@echo --- build instructor doc ---
	@echo
	echo "import os; os.chdir('docs_instructor/')" > set_figure_location.py
	codebraid pandoc $< -o $@ $(FLAGS)

# generate MkDocs site with custom site_dir and docs_dir

site_student: $(STUDENT_GENERATED) mkdocs_base.yml
	@echo
	@echo --- build student site ---
	@echo
	rsync -at raw_docs/figures_static/ docs_student/figures_static/
	echo "docs_dir: docs_student" > site_dir.yml
	echo "site_dir: site_student" >> site_dir.yml
	cat mkdocs_base.yml site_dir.yml > mkdocs.yml
	mkdocs build --no-directory-urls

site_instructor: $(INSTRUCTOR_GENERATED) mkdocs_base.yml
	@echo
	@echo --- build instructor site ---
	@echo
	rsync -a raw_docs/figures_static/ docs_instructor/figures_static/
	echo "site_dir: site_instructor" > site_dir.yml
	echo "docs_dir: docs_instructor" >> site_dir.yml
	cat mkdocs_base.yml site_dir.yml > mkdocs.yml
	mkdocs build --no-directory-urls

# delete generated documents

clean:
	rm docs_student/*.md
	rm docs_solution/*.md
	rm docs_instructor/*.md

rackspace: student
	rsync -at site_student/ root@50.56.226.226:/var/www/ev-notes

# rackspace_instructor: instructor
# 	rsync -av site_instructor/ root@50.56.226.226:/var/www/em-instructor-notes
