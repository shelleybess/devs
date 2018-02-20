RUN apt-get install neovim -y
RUN apt-get install curl -y
RUN apt-get install apt-utils -y
RUN apt-get install gcc -y
# YCM Req
RUN apt-get install -y build-essential cmake python-dev python3-dev mono-xbuild
# Ruby Req
RUN apt-get install -y libssl-dev libreadline-dev zlib1g-dev

RUN PATH="$HOME/.homebrew/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"

RUN mkdir ~/.homebrew && \
    curl -LsSf https://github.com/Homebrew/homebrew/tarball/master | tar --strip-components=1 -zxf - -C ~/.homebrew

RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv

RUN cd ~/.rbenv && src/configure && make -C src

RUN mkdir -p /root/.config/nvim/autoload /root/.config/nvim/bundle && \
    curl -LSso /root/.config/nvim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    cd /root/.config/nvim/bundle && \
    git clone --depth 1 https://github.com/fatih/vim-go.git && \
    git clone --depth 1 https://github.com/vim-syntastic/syntastic.git && \
    git clone --depth 1 https://github.com/icymind/NeoSolarized.git && \
    git clone --depth 1 https://github.com/vim-airline/vim-airline.git && \
    git clone --depth 1 https://github.com/ggreer/the_silver_searcher.git && \
    git clone --depth 1 https://github.com/gacha/nvim-config.git && \
    git clone --depth 1 --recurse-submodules https://github.com/Valloric/YouCompleteMe.git && \
    mkdir -p /src

RUN cd /root/.config/nvim/bundle/YouCompleteMe && \
    ./install.py --clang-completer

RUN echo 'export PATH="/root/.rbenv/bin:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc && \
    echo 'export PATH="/root/.homebrew/bin:$PATH"' >> /root/.bashrc && \
    echo 'export PATH="/root/.rbenv/shims:$PATH"' >> /root/.bashrc

RUN mkdir -p /root/.rbenv/plugins && \
    git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build

COPY .vimrc /root/.config/nvim/init.vim

WORKDIR /src

ENV SHELL bash

ENTRYPOINT ["/pause"]