FROM debian:bookworm-slim

# install Qt installer framework for linux
ENV QTIFW_VERSION=4.2.0
ENV QTIFW_INSTALLER=/qtifw.run
RUN apt-get update && \
    apt-get install --fix-missing -y wget dos2unix rsync libfontconfig libdbus-1-3 libxcb-glx0 libx11-xcb-dev libxrender-dev \
    libxext-dev libxkbcommon-x11-0 libgl-dev apt-transport-https xvfb cabextract
RUN wget -O $QTIFW_INSTALLER https://download.qt.io/official_releases/qt-installer-framework/$QTIFW_VERSION/QtInstallerFramework-linux-x64-$QTIFW_VERSION.run
RUN chmod +x $QTIFW_INSTALLER
RUN $QTIFW_INSTALLER install --accept-licenses --confirm-command --root /QTIFW
RUN rm $QTIFW_INSTALLER
ENV PATH="${PATH}:/QTIFW/bin"

# install Qt installer framework for windows
# https://betterprogramming.pub/how-to-run-any-windows-cli-app-in-a-linux-docker-container-318cd49bdd25

# Add 32-bit architecture
RUN dpkg --add-architecture i386

# Install Wine
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
RUN apt-get update && apt-get install -y --install-recommends --fix-missing winehq-stable winbind

# Turn off Fixme warnings
ENV WINEDEBUG=fixme-all

# Setup a Wine prefix
ENV WINEPREFIX=/root/.qtifw
ENV WINEARCH=win64
RUN winecfg

# Install Winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN chmod +x winetricks
RUN cp winetricks /usr/local/bin

# Install Visual C++ Redistributable
RUN wineboot -u && xvfb-run winetricks -q vcrun2008

# copy Qt installer framework for windows
COPY ./QtIFW-4.6.1 /QtIFW

CMD ["/bin/bash"]
