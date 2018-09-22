# Wrapper for ssh to automatically source bash config file on remote machine.
# Sources ~/.bashrc_remote
#
# author Jonah Dahlquist
# license CC0

sshs() {
    ssh ${*:1} "cat > /tmp/.zshrc_temp" < ~/.zshrc_remote
    ssh -t ${*:1} "zsh --rcfile /tmp/.zshrc_temp ; rm /tmp/.zshrc_temp"
}
