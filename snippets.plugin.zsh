#!/usr/bin/env zsh
# snippets for expansion anywhere in the command line
# taken from http://zshwiki.org/home/examples/zleiab and expanded somewhat
#
# use: add-snippet <key> <expansion>
# then, with cursor just past <key>, run snippet-expand

typeset -Ag snippets

snippet-add() {
    # snippet-add <key> <expansion>
    snippets[$1]="$2"
}

snippet-expand() {
    emulate -L zsh
    setopt extendedglob
    local MATCH

    LBUFFER=${LBUFFER%%(#m)[.\-+:|_a-zA-Z0-9]#}
    LBUFFER+=${snippets[$MATCH]:-$MATCH}
    # mlowery begin
    zle self-insert
    # mlowery end
}
zle -N snippet-expand

help-list-snippets(){
    local help="$(print "Add snippet:";
        print "snippet-add <key> <expansion>";
        print "Snippets:";
        print -a -C 2 ${(kv)snippets})"
    if [[ "$1" = "inZLE" ]]; then
        zle -M "$help"
    else
        echo "$help" | ${PAGER:-less}
    fi
}
run-help-list-snippets(){
    help-list-snippets inZLE
}
zle -N run-help-list-snippets


# mlowery begin

# disable default snippets
# set up key bindings like http://zshwiki.org/home/examples/zleiab

snippet-noexpand() {
  LBUFFER+=' '
}
zle -N snippet-noexpand

bindkey " " snippet-expand
bindkey "^x " snippet-noexpand
bindkey -M isearch " " self-insert

# mlowery end
