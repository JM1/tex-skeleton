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
    # Using HTTPS instead of SSH for anonymous cloning of public git submodules.
    #
    # Cloning with SSH instead of HTTPs always requires a valid username
    # and supplying a public SSH keys at your Git server, e.g. git.inf.h-brs.de!
    #
    # Both GitLab.com and GitHub.com do not allow anonymous access through SSH.
    # "Public projects can be cloned without any authentication over HTTPS." [1]
    # "SSH URLs provide access to a Git repository via SSH, a secure protocol.
    #  To use these URLs, you must generate an SSH keypair on your computer
    #  and add the public key to your GitHub account." [2]
    #
    # Ref.:
    # [1] https://docs.gitlab.com/ce/public_access/public_access.html
    # [2] https://help.github.com/en/github/using-git/which-remote-url-should-i-use#cloning-with-ssh-urls
    git submodule add "https://git.inf.h-brs.de/jmeng2m/${submodule}.git"
    git config -f .gitmodules "submodule.${submodule}.update" rebase
    (cd "$submodule" && git checkout master) # Enables 'git pull' in submodule dirs
done

for fgmt in \
    bibliography/references.bib \
    tex_skeleton/.gitattributes \
    tex_skeleton/.gitignore \
    tex_skeleton/Makefile \
; do
    ln -s "$fgmt" "$(basename "$fgmt")"
done

# GitLab CI is configured e.g. to fetch submodules recursively in .gitlab-ci.yml,
# which means .gitlab-ci.yml must be available as a copy (not a link) during clone.
# Also note that including local files through Git submodules paths is not supported.
# Ref.: https://gitlab.com/gitlab-org/gitlab/issues/25249
cp -raiv tex_skeleton/.gitlab-ci.yml.example .gitlab-ci.yml

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
