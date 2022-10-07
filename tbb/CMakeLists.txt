
set(TBB_VERSION "2021.5.0")

if(APPLE)
  set(TBB_URL https://github.com/oneapi-src/oneTBB/releases/download/v${TBB_VERSION}/oneapi-tbb-${TBB_VERSION}-mac.tgz)
  set(TBB_HASH "a76fd9dbd65dc951fed56a4548eec1733248fdb9")
else()
  message(SEND_FATAL "Non macOS currently unsupported")
endif()


ExternalProject_Add(tbb
  URL ${TBB_URL}
  URL_HASH SHA1=${TBB_HASH}
  BUILD_IN_SOURCE 1
  UPDATE_COMMAND ""
  PATCH_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND  ""
  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/install
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory "<SOURCE_DIR>" "<INSTALL_DIR>"
  DOWNLOAD_EXTRACT_TIMESTAMP ON
)
ExternalProject_Get_property(tbb SOURCE_DIR)
ExternalProject_Get_property(tbb INSTALL_DIR)

set(TBB_INSTALL_PATH ${INSTALL_DIR} PARENT_SCOPE)

install( DIRECTORY "${INSTALL_DIR}/include" DESTINATION .)
install( DIRECTORY "${INSTALL_DIR}/lib" DESTINATION .)

