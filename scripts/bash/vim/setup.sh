
THISDIR=$(dirname "$0")

cp ${THISDIR}/.vimrc ~

mkdir -p ~/.vim/bundle

if [ ! -d ~/.vim/bundle/vim-airline ]; then
  git clone https://github.com/vim-airline/vim-airline.git ~/.vim/bundle/vim-airline
fi
