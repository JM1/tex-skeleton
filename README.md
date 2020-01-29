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
    report/fgmt_*.tex \
    report/language-*.dict \
; do
    ln -s "tex_skeleton/$fgmt" "$(basename "$fgmt")"
done

for fgmt in \
    report/*.example \
; do
    cp -raiv "tex_skeleton/${fgmt}" "$(basename --suffix '.example' "$fgmt")"
done

make

```
