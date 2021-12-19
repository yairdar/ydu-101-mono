FROM ubuntu:latest

ENV HUGO_VERSION 0.76.4
ENV HUGO_BINARY hugo_extended_${HUGO_VERSION}_Linux-64bit.deb

ARG asciidoctor_version=2.0.10
ARG asciidoctor_pdf_version=1.5.3

ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
    ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version}

ENV TZ America/Chicago
ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt --no-install-recommends -y install \
    git ruby-full build-essential cmake zlib1g-dev \
    bison flex jpegoptim optipng ghostscript default-jre \
    graphicsmagick graphicsmagick-imagemagick-compat \
    graphicsmagick-libmagick-dev-compat graphviz lsyncd \
    libffi-dev libxml2-dev libgdk-pixbuf2.0-dev \
    libcairo2-dev libpango1.0-dev fonts-lyx python3-pip \
    plantuml wget curl

# Install Node.js and npm

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - \
    && apt-get install --no-install-recommends -y nodejs

# Installing Ruby Gems needed in the image
# including asciidoctor itself

RUN gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    asciidoctor-bibtex \
    asciidoctor-confluence \
    asciidoctor-diagram \
    asciidoctor-mathematical \
    asciimath \
    "asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    asciidoctor-revealjs \
    asciidoctor-html5s \
    coderay \
    haml \
    pygments.rb \
    prawn-gmagick \
    rake \
    rghost \
    rouge \
    slim \
    thread_safe \
    tilt

# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN pip3 install --no-cache --upgrade pip setuptools wheel \
    && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi \
    && pip install --no-cache-dir \
    actdiag \
    'blockdiag[pdf]' \
    msal \
    nwdiag \
    Pygments \
    requests \
    seqdiag \
    pypdf2

# Install HUGO

RUN wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} \
    &&  dpkg -i ${HUGO_BINARY} \
    &&  rm -r ${HUGO_BINARY}

RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod
RUN mkdir -p /builds/thunderheadeng/web
RUN ln -s /workspace/support /builds/thunderheadeng/web/support
RUN chown -R gitpod:gitpod /builds