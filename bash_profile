# ~/.bash_profile

# source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# export additional paths
export PATH=$PATH:$HOME/myfiles/system/bin:$HOME/myfiles/system/scripts
