FROM ubuntu:20.04

ENV TL_VERSION      2020
ENV TL_PATH         /usr/local/texlive
ENV PATH            ${TL_PATH}/bin/x86_64-linux:/bin:${PATH}

WORKDIR /tmp

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    fontconfig \
    ghostscript \
    perl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install TeX Live
RUN mkdir install-tl-unx && \
    # Download installer
    curl https://texlive.texjp.org/${TL_VERSION}/tlnet/install-tl-unx.tar.gz | \
    tar -xz -C ./install-tl-unx --strip-components=1 \
    # full install (except for src and docs)
    && printf "%s\n" \
    "TEXDIR ${TL_PATH}" \
    "selected_scheme scheme-full" \
    "option_doc 0" \
    "option_src 0" \
    > ./install-tl-unx/texlive.profile \
    && ./install-tl-unx/install-tl \
    -repository https://texlive.texjp.org/${TL_VERSION}/tlnet/ \
    -profile ./install-tl-unx/texlive.profile \
    # Update TeX Live Manager
    && tlmgr update --self --all \
    # Clean up
    && rm -rf *

# Set up fonts
RUN \
    # Run cjk-gs-integrate
    cjk-gs-integrate --cleanup --force \
    && cjk-gs-integrate --force \
    # Copy CMap: 2004-{H,V}
    && cp -b ${TL_PATH}/texmf-dist/fonts/cmap/ptex-fontmaps/2004-* /var/lib/ghostscript/CMap/ \
    && kanji-config-updmap-sys --jis2004 haranoaji \
    # Re-index LuaTeX font database
    && luaotfload-tool -u -f

VOLUME ["/usr/local/texlive/${TL_VERSION}/texmf-var/luatex-cache"]

WORKDIR /workdir

CMD [ "sh", "-c", "echo", "Hello, TeX Live!!" ]