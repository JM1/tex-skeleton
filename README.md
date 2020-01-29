# Setup a new Git repository

```
REPO=myname
mkdir "$REPO"
cd "$REPO"

# Setup Git LFS
git lfs install --local

# Setup Git submodules
for submodule in bibliography tex_skeleton; do
    git submodule add "git@vm-2d21.inf.h-brs.de:jmeng2m/${submodule}.git"
    git config -f .gitmodules "submodule.${submodule}.update" rebase
done

for fgmt in \
    .gitattributes \
    .gitignore \
    Makefile \
; do
    ln -s "tex_skeleton/$fgmt" "$fgmt"
done

# report

for fgmt in \
    report/fgmt_01_setup.tex \
    report/fgmt_02_configure.tex \
    report/fgmt_03_preface.tex \
    report/fgmt_99_bibliography.tex \
; do
    ln -s "tex_skeleton/$fgmt" "$(basename "$fgmt")"
done

for fgmt in \
    report/fgmt_00_about.tex \
    report/fgmt_09_abstract.tex \
    report/master.tex \
; do
    cp -raiv "tex_skeleton/${fgmt}.example" "$(basename "$fgmt")"
done

make

```
