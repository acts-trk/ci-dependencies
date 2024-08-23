cmake_minimum_required(VERSION 3.20)
project(ActsDependencies)

option(USE_MINIMUM_VERSIONS "Use minimum versions for dependencies" OFF)
option(BUILD_ACTS "Build ACTS" OFF)
option(USE_SYSTEM_PYTHON "Do not build python but use the system installation" OFF)

include(ExternalProject)
include(GNUInstallDirs)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)


if(USE_MINIMUM_VERSIONS)
  set(GEANT4_VERSION 11.0.0)
  set(GEANT4_HASH SHA256=04d11d4d9041507e7f86f48eb45c36430f2b6544a74c0ccaff632ac51d9644f1)

  set(HEPMC3_VERSION 3.2.1)
  set(HEPMC3_HASH SHA256=6e4e4bb5708af105d4bf74efc2745e6efe704e942d46a8042f7dcae37a4739fe)

  set(PYTHIA8_VERSION 310)
  set(PYTHIA8_HASH SHA256=90c811abe7a3d2ffdbf9b4aeab51cf6e0a5a8befb4e3efa806f3d5b9c311e227)

  set(ROOT_VERSION 6.28.06)
  set(ROOT_HASH SHA256=af3b673b9aca393a5c9ae1bf86eab2672aaf1841b658c5c6e7a30ab93c586533)

  set(PODIO_VERSION 00-16-06)
  set(PODIO_HASH SHA256=859f7cd16bd2b833bee9c1f33eb4cdbc2a0c2b1a48a853f67c30e8a0301d16df)
  set(PODIO_PATCH "")

  set(EDM4HEP_VERSION 00-10)
  set(EDM4HEP_HASH SHA256=a95c917c19793cfad6b0959854a653c5ce698c965598cabd649d544da07712c0)

  set(DD4HEP_VERSION 01-26)
  set(DD4HEP_HASH SHA256=de2cc8d8e99217e23fdf0a55b879d3fd3a864690d6660e7808f1ff99eb47f384)

  set(BOOST_VERSION 1.81.0)
  set(BOOST_URL https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}.tar.xz)
  set(BOOST_HASH SHA256=06bc525a392650eb6248f40a13f40112b6c485eec7103b6dcde7196f2a3570e0)
else()
  set(GEANT4_VERSION 11.2.2)
  set(GEANT4_HASH SHA256=3a8d98c63fc52578f6ebf166d7dffaec36256a186d57f2520c39790367700c8d)

  set(HEPMC3_VERSION 3.3.0)
  set(HEPMC3_HASH SHA256=6f876091edcf7ee6d0c0db04e080056e89efc1a61abe62355d97ce8e735769d6)

  set(PYTHIA8_VERSION 312)
  set(PYTHIA8_HASH SHA256=bad98e2967b687046c4568c9091d630a0c31b628745c021a994aba4d1d50f8ea)

  set(ROOT_VERSION 6.32.04)
  set(ROOT_HASH SHA256=132f126aae7d30efbccd7dcd991b7ada1890ae57980ef300c16421f9d4d07ea8)

  set(PODIO_VERSION 01-00-01)
  set(PODIO_HASH SHA256=915531a2bcf638011bb6cc19715bbc46d846ec8b985555a1afdcd6abc017e21b)
  set(PODIO_PATCH "")

  set(EDM4HEP_VERSION 00-10-05)
  set(EDM4HEP_HASH SHA256=003c8e0c8e1d1844592d43d41384f4320586fbfa51d4d728ae0870b9c4f78d81)

  set(DD4HEP_VERSION 01-29)
  set(DD4HEP_HASH SHA256=435d25a7ef093d8bf660f288b5a89b98556b4c1c293c55b93bf641fb4cba77e9)
  set(DD4HEP_PATCH "PATCH_COMMAND;patch;-p1;-i;${CMAKE_CURRENT_SOURCE_DIR}/patches/dd4hep-python.patch;&&;patch;-p1;-i;${CMAKE_CURRENT_SOURCE_DIR}/patches/0001-CMake-allow-finding-newer-versions-of-podio.patch")
  set(BOOST_VERSION 1.86.0)
  set(BOOST_URL https://github.com/boostorg/boost/releases/download/boost-${BOOST_VERSION}/boost-${BOOST_VERSION}-cmake.tar.xz)
  set(BOOST_HASH SHA256=2c5ec5edcdff47ff55e27ed9560b0a0b94b07bd07ed9928b476150e16b0efc57)
endif()
set(PYTHON_VERSION 3.12.2)
set(PYTHON_HASH SHA256=a7c4f6a9dc423d8c328003254ab0c9338b83037bd787d680826a5bf84308116e)
set(TBB_VERSION 2021.13.0)
set(TBB_HASH SHA256=3ad5dd08954b39d113dc5b3f8a8dc6dc1fd5250032b7c491eb07aed5c94133e1)
set(EIGEN_VERSION 3.4.0)
set(EIGEN_HASH SHA256=8586084f71f9bde545ee7fa6d00288b264a2b7ac3607b974e54d13e7162c1c72)
set(GEOMODEL_VERSION 6.3.0)
set(GEOMODEL_HASH SHA256=9c646393763284bca414d39812fd8b578fe73ac6ea1c2cad34a64313f04289d1)
set(JSON_VERSION 3.11.3)
set(JSON_HASH SHA256=0d8ef5af7f9794e3263480193c491549b2ba6cc74bb018906202ada498a79406)

if(POLICY CMP0135)
  cmake_policy(SET CMP0135 NEW)
endif()

if(NOT DEFINED CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
endif()

set(CMAKE_BUILD_TYPE RelWithDebInfo)

if(NOT CMAKE_BUILD_PARALLEL_LEVEL)
  set(CMAKE_BUILD_PARALLEL_LEVEL 1)
endif()


if(APPLE)
  set(OS_NAME "macos")
else()
  execute_process(
    COMMAND bash "-c" "cat /etc/os-release | grep -e \"^PRETTY_NAME=\" | sed 's/PRETTY_NAME=\"\\(.*\\)\"/\\1/g'"
    OUTPUT_VARIABLE OS_NAME_PRETTY
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )

  message(STATUS "OS: ${OS_NAME_PRETTY}")


  if(${OS_NAME_PRETTY} MATCHES "AlmaLinux")
    set(OS_NAME "almalinux")
  elseif(${OS_NAME_PRETTY} MATCHES "Ubuntu")
    set(OS_NAME "ubuntu")
  else()
    message(FATAL_ERROR "Unsupported OS: ${OS_NAME_PRETTY}")
  endif()
endif()

macro(install_hint)
  set(options "")
  set(oneValueArgs MACOS UBUNTU ALMA)
  set(multiValueArgs "")
  cmake_parse_arguments(IHINT "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})
  if(APPLE)
    message(FATAL_ERROR "Install like:\n> brew install ${IHINT_MACOS}")
  elseif(${OS_NAME} STREQUAL "ubuntu")
    message(FATAL_ERROR "Install like:\n> sudo apt-get install -y ${IHINT_UBUNTU}")
  elseif(${OS_NAME} STREQUAL "almalinux")
    message(FATAL_ERROR "Install like:\n> sudo dnf install -y ${IHINT_ALMA}")
  endif()
endmacro()

macro(check_os_package)
  set(options PROGRAM)
  set(oneValueArgs NAME MACOS UBUNTU ALMA)
  set(multiValueArgs "")
  cmake_parse_arguments(OSPKG "${options}" "${oneValueArgs}"
                        "${multiValueArgs}" ${ARGN})

  message(CHECK_START "Checking for ${OSPKG_NAME}")
  if(${OSPKG_PROGRAM})
    find_program(${OSPKG_NAME}_exe ${OSPKG_NAME} NO_CACHE QUIET)
  else()
    find_package(${OSPKG_NAME} QUIET)
  endif()

  if("${${OSPKG_NAME}_FOUND}" OR (${OSPKG_PROGRAM} AND (NOT ${OSPKG_NAME}_exe STREQUAL "${OSPKG_NAME}_exe-NOTFOUND")))
    message(CHECK_PASS "found")
  else()
    message(CHECK_FAIL "not found")
    install_hint(MACOS ${OSPKG_MACOS} UBUNTU ${OSPKG_UBUNTU} ALMA ${OSPKG_ALMA})
  endif()
endmacro()

check_os_package(NAME OpenSSL
                 MACOS openssl@3
                 UBUNTU libssl-dev
                 ALMA openssl-devel)

check_os_package(NAME ZLIB
                 MACOS zlib
                 UBUNTU zlib1g-dev
                 ALMA zlib-devel)

check_os_package(NAME ZSTD
                 MACOS zstd
                 UBUNTU libzstd-dev
                 ALMA libzstd-devel)


check_os_package(NAME Curses
                 MACOS ncurses
                 UBUNTU libncurses5-dev
                 ALMA ncurses-devel)

check_os_package(NAME EXPAT
                 MACOS expat
                 UBUNTU libexpat-dev
                 ALMA expat-devel)

check_os_package(NAME XercesC
                 MACOS xerces-c
                 UBUNTU libxerces-c-dev
                 ALMA "epel-release xerces-c-devel")

check_os_package(PROGRAM
                 NAME rsync
                 MACOS rsync
                 UBUNTU rsync
                 ALMA rsync)

check_os_package(NAME Freetype
                 MACOS freetype
                 UBUNTU libfreetype-dev
                 ALMA freetype-devel)

check_os_package(NAME LibLZMA
                 MACOS xz # not sure about the name
                 UBUNTU liblzma-dev
                 ALMA xz-devel)

check_os_package(NAME LZ4
                 MACOS lz4
                 UBUNTU liblz4-dev
                 ALMA lz4-devel)

check_os_package(NAME X11
                 MACOS libx11
                 UBUNTU libx11-dev
                 ALMA libX11-devel)

if(NOT X11_Xpm_FOUND)
  install_hint(MACOS libxpm UBUNTU libxpm-dev ALMA libXpm-devel)
endif()

if(NOT X11_Xft_FOUND)
  install_hint(MACOS libxft UBUNTU libxft-dev ALMA libXft-devel)
endif()

if(NOT X11_Xext_FOUND)
  install_hint(MACOS libxext UBUNTU libxext-dev ALMA libXext-devel)
endif()

check_os_package(NAME OpenGL
                 MACOS this-should-already-exist
                 UBUNTU libglu1-mesa-dev
                 ALMA "mesa-libGL-devel mesa-libGLU-devel")

if(NOT OPENGL_GLU_FOUND)
  install_hint(MACOS glu
               UBUNTU libglu1-mesa-dev
               ALMA mesa-libGLU-devel)
endif()

check_os_package(NAME LibXml2
                 MACOS libxml2
                 UBUNTU libxml2-dev
                 ALMA libxml2-devel)

check_os_package(PROGRAM NAME git
                 MACOS git
                 UBUNTU git
                 ALMA git)

set(openssl_option "")
if(APPLE)
  execute_process(COMMAND brew --prefix openssl
                  OUTPUT_VARIABLE OPENSSL_DIR)
  set(openssl_option "--with-openssl=${OPENSSL_DIR}")
  message(STATUS "Sysroot: ${CMAKE_OSX_SYSROOT}")
endif()


# Determine current platform as minimum from SYSROOT
if(APPLE)
  execute_process(COMMAND jq -r .MinimalDisplayName ${CMAKE_OSX_SYSROOT}/SDKSettings.json
                  COMMAND_ERROR_IS_FATAL ANY
                  OUTPUT_VARIABLE CMAKE_OSX_DEPLOYMENT_TARGET
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  message(STATUS "Minimal macOS Deployment Target determined to: ${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()

set(python_sdkroot "")
set(python_deployment_target "")
set(python_cflags "-fPIC")
if(APPLE)
  set(python_sdkroot "SDKROOT=${CMAKE_OSX_SYSROOT}")
  set(python_deployment_target "MACOSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()


if(USE_SYSTEM_PYTHON)
  message(STATUS "Using SYSTEM python installation")

  find_package(Python REQUIRED Development Interpreter)
  
  if ("${Python3_EXECUTABLE}" STREQUAL "" AND NOT "${Python_EXECUTABLE}" STREQUAL "")
    set(Python3_EXECUTABLE ${Python_EXECUTABLE})
  endif()

  if("${Python_EXECUTABLE}" STREQUAL "" AND NOT "${Python3_EXECUTABLE}" STREQUAL "")
    set(Python_EXECUTABLE ${Python3_EXECUTABLE})
  endif()


  add_custom_target(PythonExeExists)
else()

  ExternalProject_Add(python
  PREFIX python
  URL https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
  URL_HASH ${PYTHON_HASH}
  BUILD_IN_SOURCE ON
  CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "CFLAGS=${python_cflags}" ${python_sdkroot} ${python_deployment_target} ./configure --prefix=${CMAKE_INSTALL_PREFIX} --enable-optimizations --with-lto ${openssl_option}
  BUILD_COMMAND make -j${CMAKE_BUILD_PARALLEL_LEVEL}
)

  string(REGEX MATCH "^([0-9]+\\.[0-9]+)\\.[0-9]+$" _temp ${PYTHON_VERSION})
  set(PYTHON_VERSION_MAJOR_MINOR ${CMAKE_MATCH_1})

  # We're guessing / expecting this file to be there when it's needed
  set(Python_EXECUTABLE "${CMAKE_INSTALL_PREFIX}/bin/python${PYTHON_VERSION_MAJOR_MINOR}")

  set(_python_stamp_file "${CMAKE_CURRENT_BINARY_DIR}/python_exe_exists.stamp")
  add_custom_command(OUTPUT ${_python_stamp_file}
    COMMAND ${CMAKE_COMMAND} -E env sh -c "( test -e ${Python_EXECUTABLE} && touch ${_python_stamp_file} ) || ( echo 'Python executable not found at ${Python_EXECUTABLE}!' && exit 1 )"
    VERBATIM
    COMMENT "Checking for Python executable"
    DEPENDS python)
  add_custom_target(PythonExeExists DEPENDS ${_python_stamp_file})
endif()

message(STATUS "Python executable: ${Python_EXECUTABLE}")


ExternalProject_Add(boost
  PREFIX boost
  URL ${BOOST_URL}
  URL_HASH ${BOOST_HASH}
  CMAKE_ARGS
  -DBUILD_SHARED_LIBS=ON
  -DBoost_VERBOSE=ON
  # Revisit in boost 1.86.0 ish with BOOST_NUMERIC_ODEINT_NO_ADAPTORS
  -DBOOST_EXCLUDE_LIBRARIES=numeric/odeint
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)

ExternalProject_Add(eigen
  PREFIX eigen
  URL https://gitlab.com/libeigen/eigen/-/archive/${EIGEN_VERSION}/eigen-${EIGEN_VERSION}.tar.gz
  URL_HASH ${EIGEN_HASH}
  CMAKE_ARGS
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
)

ExternalProject_Add(tbb
  PREFIX tbb
  URL https://github.com/oneapi-src/oneTBB/archive/refs/tags/v${TBB_VERSION}.tar.gz
  URL_HASH ${TBB_HASH}
  CMAKE_ARGS
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
  -DTBB_TEST=OFF
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)

ExternalProject_Add(geant4
  PREFIX geant4
  URL https://gitlab.cern.ch/geant4/geant4/-/archive/v${GEANT4_VERSION}/geant4-v${GEANT4_VERSION}.tar.gz
  URL_HASH ${GEANT4_HASH}
  CMAKE_ARGS
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
  -DGEANT4_BUILD_TLS_MODEL=global-dynamic
  -DGEANT4_INSTALL_DATA=OFF
  -DGEANT4_USE_GDML=ON
  -DGEANT4_USE_SYSTEM_EXPAT=ON
  -DGEANT4_USE_SYSTEM_ZLIB=ON
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)


ExternalProject_Add(hepmc3
  PREFIX hepmc3
  URL https://gitlab.cern.ch/hepmc/HepMC3/-/archive/${HEPMC3_VERSION}/HepMC3-${HEPMC3_VERSION}.tar.gz
  URL_HASH ${HEPMC3_HASH}
  CMAKE_ARGS
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
  -DHEPMC3_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DHEPMC3_BUILD_STATIC_LIBS=OFF
  -DHEPMC3_ENABLE_PYTHON=OFF
  -DHEPMC3_ENABLE_ROOTIO=OFF
  -DHEPMC3_ENABLE_SEARCH=OFF
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)

# Hard-coding the compile flags is not ideal, but seems needed
set(pythia_configure  "./configure")
list(APPEND pythia_configure "--prefix=${CMAKE_INSTALL_PREFIX}")
set(pythia_cxx_common "-O2 -std=c++${CMAKE_CXX_STANDARD} -pedantic -W -Wall -Wshadow -fPIC -pthread")
if(APPLE)
  list(APPEND pythia_configure "--cxx-common='-isysroot ${CMAKE_OSX_SYSROOT} ${pythia_cxx_common}'")
else()
  list(APPEND pythia_configure "--cxx-common='${pythia_cxx_common}'")
endif()

ExternalProject_Add(pythia8
  PREFIX pythia8
  DEPENDS PythonExeExists
  URL https://pythia.org/download/pythia83/pythia8${PYTHIA8_VERSION}.tgz
  URL_HASH ${PYTHIA8_HASH}
  BUILD_IN_SOURCE ON
  PATCH_COMMAND patch -p1 -i ${CMAKE_CURRENT_SOURCE_DIR}/pythia8-forward-decl.patch
  CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env CXX=${CMAKE_CXX_COMPILER} CC=${CMAKE_C_COMPILER} ${pythia_configure}
  BUILD_COMMAND make -j${CMAKE_BUILD_PARALLEL_LEVEL}
)

ExternalProject_Add(nlohmann_json
  PREFIX nlohmann_json
  URL https://github.com/nlohmann/json/archive/refs/tags/v${JSON_VERSION}.tar.gz
  URL_HASH ${JSON_HASH}
  CMAKE_ARGS
  -DJSON_BuildTests=OFF
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)

ExternalProject_Add(geomodel
  PREFIX geomodel
  DEPENDS nlohmann_json geant4 eigen
  URL https://gitlab.cern.ch/GeoModelDev/GeoModel/-/archive/${GEOMODEL_VERSION}/GeoModel-${GEOMODEL_VERSION}.tar.gz
  URL_HASH ${GEOMODEL_HASH}
  CMAKE_ARGS
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
  -DGEOMODEL_BUILD_GEOMODELG4=ON
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)


# the builtin vdt build requires a python to be on path: we happen to have one ready
set(root_vdt_path "${CMAKE_INSTALL_PREFIX}/bin:$ENV{PATH}")

ExternalProject_Add(root
  PREFIX root
  DEPENDS nlohmann_json PythonExeExists tbb
  URL https://root.cern/download/root_v${ROOT_VERSION}.source.tar.gz
  URL_HASH ${ROOT_HASH}
  LIST_SEPARATOR |
  CMAKE_ARGS
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DPython_EXECUTABLE=${Python_EXECUTABLE}
  -DPython3_EXECUTABLE=${Python_EXECUTABLE}
  -Dfail-on-missing=ON
  -Dgdml=ON
  -Dx11=ON
  -Dpyroot=ON
  -Ddataframe=ON
  -Dmysql=OFF
  -Doracle=OFF
  -Dpgsql=OFF
  -Dsqlite=OFF
  -Dpythia6=OFF
  -Dpythia8=OFF
  -Dfftw3=OFF
  -Dgfal=OFF
  -Ddavix=OFF
  -Dxrootd=OFF
  -Dtmva=OFF
  -Dbuiltin_cfitsio=ON
  -Dbuiltin_xxhash=ON
  -Dbuiltin_afterimage=ON
  -Dbuiltin_ftgl=ON
  -Dbuiltin_gsl=ON
  -Dbuiltin_gl2ps=ON
  -Dbuiltin_glew=ON
  -Dbuiltin_pcre=ON
  -Dbuiltin_tbb=OFF
  -Dbuiltin_openssl=OFF
  -Dbuiltin_vdt=ON
  BUILD_COMMAND ${CMAKE_COMMAND} -E env PATH=${root_vdt_path} CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)


ExternalProject_Add(podio
  PREFIX podio
  DEPENDS root PythonExeExists
  URL https://github.com/AIDASoft/podio/archive/refs/tags/v${PODIO_VERSION}.tar.gz
  URL_HASH ${PODIO_HASH}
  ${PODIO_PATCH}
  CMAKE_ARGS
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DPython_EXECUTABLE=${Python_EXECUTABLE}
  -DPython3_EXECUTABLE=${Python_EXECUTABLE}
  -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
  -DBUILD_TESTING=OFF
  -DUSE_EXTERNAL_CATCH2=OFF
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
)

set(venv_dir ${CMAKE_CURRENT_BINARY_DIR}/venv)
set(venv_python_exe ${venv_dir}/bin/python)

add_custom_command(OUTPUT ${venv_python_exe}
                   COMMAND ${Python_EXECUTABLE} -m venv ${venv_dir} && ${venv_python_exe} -m pip install --upgrade pip jinja2 pyyaml
                   COMMENT "Creating virtualenv for edm4hep build"
                   DEPENDS PythonExeExists)

add_custom_target(PythonVenv DEPENDS ${venv_python_exe})

ExternalProject_Add(edm4hep
  PREFIX edm4hep
  DEPENDS podio PythonVenv
  URL https://github.com/key4hep/EDM4hep/archive/refs/tags/v${EDM4HEP_VERSION}.tar.gz
  URL_HASH ${EDM4HEP_HASH}
  LIST_SEPARATOR |
  CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env PYTHONPATH=${CMAKE_INSTALL_PREFIX}/lib
  ${CMAKE_COMMAND} -S <SOURCE_DIR> -B <BINARY_DIR>
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DPython_EXECUTABLE=${venv_python_exe}
  -DBUILD_TESTING=OFF
  -DUSE_EXTERNAL_CATCH2=OFF
  BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL}
    ${CMAKE_COMMAND} --build <BINARY_DIR>
)

ExternalProject_Add(dd4hep
  PREFIX dd4hep
  DEPENDS edm4hep geant4 PythonExeExists boost nlohmann_json
  URL https://github.com/AIDASoft/DD4hep/archive/v${DD4HEP_VERSION}.tar.gz
  URL_HASH ${DD4HEP_HASH}
  LIST_SEPARATOR |
  ${DD4HEP_PATCH}
  BUILD_COMMAND ${CMAKE_COMMAND} -E env LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR} CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND}  --build <BINARY_DIR>
  CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env LD_LIBRARY_PATH=${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}  ${CMAKE_COMMAND} -S <SOURCE_DIR> -B <BINARY_DIR>
  -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
  -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
  -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
  -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
  -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
  -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}
  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
  -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
  -DPython_EXECUTABLE=${Python_EXECUTABLE}
  -DBUILD_TESTING=OFF
  -DDD4HEP_BUILD_PACKAGES=DDG4|DDDetectors|DDRec|UtilityApps
  -DDD4HEP_USE_GEANT4=ON
  -DDD4HEP_USE_XERCESC=ON
  -DDD4HEP_USE_EDM4HEP=ON
)


if(BUILD_ACTS)
  message(STATUS "Building ACTS")
  ExternalProject_Add(acts
    PREFIX acts
    DEPENDS root podio edm4hep geant4 nlohmann_json boost dd4hep tbb eigen pythia8 hepmc3 PythonVenv
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/acts
    LIST_SEPARATOR |
    CMAKE_ARGS
    -DCMAKE_CXX_COMPILER_LAUNCHER=${CMAKE_CXX_COMPILER_LAUNCHER}
    -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}/acts
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -DPython_EXECUTABLE=${venv_python_exe}
    # ACTS args
    -DACTS_BUILD_EVERYTHING=ON
    BUILD_COMMAND ${CMAKE_COMMAND} -E env CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL} ${CMAKE_COMMAND} --build <BINARY_DIR>
  )
endif()
