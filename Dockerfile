FROM archlinux:latest

RUN export patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
  curl -LO https://repo.archlinuxcn.org/x86_64/$patched_glibc && \
  bsdtar -C / -xvf $patched_glibc

RUN sed -i "/#VerbosePkgLists/a ParallelDownloads = 5" /etc/pacman.conf

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

RUN curl -L https://github.com/github-release/github-release/releases/download/v0.10.0/linux-amd64-github-release.bz2 | bzip2 -d > /usr/local/bin/github-release && chmod +x /usr/local/bin/github-release

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
