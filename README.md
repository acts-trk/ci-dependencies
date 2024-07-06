# ACTS super-project with dependencies

This repository contains instructions to build ACTS including all dependencies,
except for common ones usually found in package managers.

To get started, clone this repository like:

```bash
git clone --recursive git@github.com:acts-project/ci-dependencies.git
```

You can then run the main build script, where you can supply a custom build and install directory.

```bash
./build.sh [BUILD_DIR] [INSTALL_DIR] # both arguments are optional
```

The build script will build ACTS (which you checked out as a submodule with the command above).
The source code is found in `$REPOSITORY/acts`, and can be modified.

> [!NOTE]
> The script and CMake configuration will tell you about missing packages.
> If you're just getting started, try running one of these one-liners depending on your operating system:
>
> ### Ubuntu
>
> ```bash
> sudo apt-get install -y cmake build-essential libssl-dev zlib1g-dev libncurses5-dev libexpat-dev libxerces-c-dev rsync libfreetype-dev liblzma-dev liblz4-dev libx11-dev libxpm-dev libxft-dev libxext-dev libglu1-mesa-dev libxml2-dev git libzstd-dev"
> ```
>
> ### AlmaLinux9
>
> ```bash
> sudo dnf group install -y "Development Tools" && sudo dnf install -y epel-release && sudo dnf install -y cmake  openssl-devel zlib-devel ncurses-devel expat-devel xerces-c-devel rsync freetype-devel xz-devel lz4-devel libX11-devel libXpm-devel libXft-devel libXext-devel mesa-libGLU-devel libxml2-devel git libzstd-devel
> ```
>
> ### macOS
>
> 1. Install homebrew from <https://brew.sh>
>
> ```bash
> xcode-select --install
> brew install cmake openssl@3 zlib zstd ncurses expat xerces-c rsync freetype xz lz4 libx11 libxml2 git"
> ```

If you want to run only the ACTS build, use

```bash
cmake --build $YOUR_BUILD_DIR --target acts
```
