Black needs Vim with python3 support. For this to work on MacOS, you need to install Vim from
Homebrew doing 'brew install vim'. Then, to make sure you use the recently installed and not
the system default, '/usr/local/bin' should be before '/usr/bin' in the path.
If everything is done correctly, 'vim --version' should show 'Compiled by Homebrew' and not
the one 'Compiled by root@apple.com'

Once downloaded the .vimrc. Open a new terminal (this will source the .vimrc) and open the
.vimrc with Vim, this will download vim-plug and install the listed plugins.
