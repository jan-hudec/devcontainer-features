#! /bin/sh
set -e

echo "Activating feature 'nood'"

# TODO: Initialize the inner and outer profile:
# - Outer profile: The user's default profile should be included in profiles and path.
# - Inner profile: The profile set up by the init script by default should be
#   - mounted somewhere so the outer and inner path match - so /nix/var/nix/gcroots/auto
#     work correctly
#   - We can't default environment, so it will probably have to be hardcoded(ish) as
#     $HOME/.local/state/nixood/<container-id>/

prepend_rc() {
  if [ -f "$1" ]; then
    mv "$1" "$1~"
    cat - "$1~" <<EOF >"$1"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

EOF
  fi
}

prepend_rc /etc/bashrc
prepend_rc /etc/bash.bashrc
prepend_rc /etc/zshrc
prepend_rc /etc/zshrc
prepend_rc /etc/profile.d/nix.sh
# TODO: & nix.csh & nix.fish

# TODO: This be kinda wrong, because the vscode server will _not_ be running below a login shell, so
# where we actually need to inject the environment variables is the environment setting of the
# container itself (the entrypoint is not the right place either, because that one doesn't apply to
# `exec`, but that is how everything is actually run).
