FROM archlinux:latest

RUN pacman-key --init && \
    pacman-key --populate archlinux

RUN pacman -Sy --noconfirm reflector
RUN reflector --verbose --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
RUN pacman -Syu --noconfirm --needed \
  archiso \
  mkinitcpio \
  cdrtools \
  asp \
  base-devel \
  haveged \
  wget \
  dos2unix \
  gettext

RUN curl -L https://github.com/github-release/github-release/releases/download/v0.10.0/linux-amd64-github-release.bz2 | tar -jx --strip-components 3 -C /usr/local/bin bin/linux/amd64/github-release

RUN mkdir -p /work/overlay /work/fakeroot

#RUN useradd -ms /bin/bash -d /work build

#USER build

COPY build.sh /work
COPY settings /work
COPY groovy-ux-repo.conf /work
COPY groovy-ux-repo.conf /etc/pacman.d
COPY globals /work
COPY groovyarcade /work/groovyarcade

RUN grep -q groovy-ux-repo.conf /etc/pacman.conf || sed -i "/^\[core\]$/i Include = \/etc\/pacman.d\/groovy-ux-repo.conf\n" /etc/pacman.conf

WORKDIR /work

#ENTRYPOINT ["/bin/bash", "-x", "./build.sh"]
#ENTRYPOINT ["./build.sh"]
#CMD ["/bin/bash", "-x", "/work/build.sh"]
CMD ["/bin/bash", "/work/build.sh"]
