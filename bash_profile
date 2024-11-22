# source bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# activate work_sshid
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/workd_sshid
clear && neofetch;
