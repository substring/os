FROM archlinux:latest

RUN sed -i "/#VerbosePkgLists/a ParallelDownloads = 25" /etc/pacman.conf

RUN pacman-key --init && \
    pacman-key --populate archlinux

RUN pacman -Syu --noconfirm reflector curl rsync
RUN curl "https://archlinux.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4&use_mirror_status=on" | sed 's/^#\(.*\)/\1/' > /etc/pacman.d/mirrorlist
RUN reflector --verbose --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
RUN pacman -Syu --noconfirm --needed \
  archiso \
  mkinitcpio \
  cdrtools \
  base-devel \
  haveged \
  wget \
  dos2unix \
  gettext \
  github-cli

RUN mkdir -p /work/overlay /work/fakeroot

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
