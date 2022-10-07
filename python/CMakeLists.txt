
set(PYTHON_VERSION "3.10.2")

set(PYTHON_URL https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz)
set(PYTHON_HASH "e8fe2dc94c5cb5d3ad19d646881f3fc351cba7d4")


set(python_args
--prefix=<INSTALL_DIR>
CC=${CC}
--with-system-expat
)
# if(CMAKE_BUILD_TYPE STREQUAL "Release")
list(APPEND python_args --enable-optimizations)
# endif()

set(python_cflags "${CMAKE_C_FLAGS} -I${OPENSSL_ROOT_DIR}/include")
# set(python_ldflags "${LDFLAGS}")
list(APPEND python_args "--with-openssl=${OPENSSL_ROOT_DIR}")

find_package(OpenSSL REQUIRED)

ExternalProject_Add(python
  URL ${PYTHON_URL}
  URL_HASH SHA1=${PYTHON_HASH}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure ${python_args} CFLAGS=${python_cflags} #LDFLAGS=${python_ldflags}
  BUILD_COMMAND make -j${CMAKE_BUILD_PARALLEL_LEVEL}
  INSTALL_COMMAND make install
  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
  DOWNLOAD_EXTRACT_TIMESTAMP ON
)

ExternalProject_Get_property(python INSTALL_DIR)
install( DIRECTORY "${INSTALL_DIR}/" DESTINATION .)

set(PYTHON_INSTALL_PATH ${INSTALL_DIR} PARENT_SCOPE)
# add_library(python::python SHARED IMPORTED GLOBAL )
# set_target_properties( python::python PROPERTIES
  # # INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
  # # IMPORTED_LOCATION "${INSTALL_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}tbb${CMAKE_SHARED_LIBRARY_SUFFIX}"
  # INSTALL_PATH "${INSTALL_DIR}" )

