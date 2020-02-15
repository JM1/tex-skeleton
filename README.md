# Setup a new Git repository

```
REPO=myname
mkdir "$REPO"
cd "$REPO"

git init

# Setup Git LFS
git lfs install --local

# Setup Git submodules
for submodule in bibliography tex_skeleton; do
    git submodule add "git@vm-2d21.inf.h-brs.de:jmeng2m/${submodule}.git"
    git config -f .gitmodules "submodule.${submodule}.update" rebase
    (cd "$submodule" && git checkout master) # Enables 'git pull' in submodule dirs
done

for fgmt in \
    tex_skeleton/.gitattributes \
    tex_skeleton/.gitignore \
    tex_skeleton/Makefile \
; do
    ln -s "$fgmt" "$(basename "$fgmt")"
done

# for report only
for fgmt in \
    tex_skeleton/report/fgmt_*.tex \
    tex_skeleton/report/language-*.dict \
; do
    ln -s "$fgmt" "$(basename "$fgmt")"
done

# for report only
for fgmt in \
    tex_skeleton/report/*.example \
; do
    cp -raiv "${fgmt}" "$(basename --suffix '.example' "$fgmt")"
done

make

```
