FROM archlinux/base:latest

RUN pacman-key --init && \
    pacman-key --populate archlinux

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

RUN curl -L https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 | tar -jx --strip-components 3 -C /usr/local/bin bin/linux/amd64/github-release

RUN mkdir -p /work/overlay /work/fakeroot

#RUN useradd -ms /bin/bash -d /work build

#USER build

COPY build.sh /work
COPY settings /work
COPY packages.x86_64 /work
COPY archiso_build.sh.patch /work
COPY mkarchiso.patch /work
COPY groovy-ux-repo.conf /work
COPY customize_airootfs_groovy.sh /work
COPY overlay /work/overlay
COPY groovy-ux-repo.conf /etc/pacman.d

RUN grep -q groovy-ux-repo.conf /etc/pacman.conf || echo -e "\nInclude = /etc/pacman.d/groovy-ux-repo.conf" >> /etc/pacman.conf

WORKDIR /work

#ENTRYPOINT ["/bin/bash", "-x", "./build.sh"]
#ENTRYPOINT ["./build.sh"]
#CMD ["/bin/bash", "-x", "/work/build.sh"]
CMD ["/bin/bash", "/work/build.sh"]
