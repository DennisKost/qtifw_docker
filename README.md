Qt Installer Framework Linux/Windows

With this docker image you can build installer for Linux and Windows inside docker container

# Prerequisites
- download and unpack Qt Installer 4.6.1 for windows and copy into Dockerfile folder

# Use
## Linux
Qt binary folder added to PATH, you can use through variables from bin folder:  
`archivegen /path/to/archive.7z /path/to/data/*`  
`binarycreator --config /path/to/config.xml --packages /path/to/packages /path/to/installer.run`  
## Windows
With wine utility you can run creation installer:  
`xvfb-run wine /QtIFW/bin/binarycreator.exe --config /path/to/config.xml --packages /path/to/packages /path/to/installer.exe`  
