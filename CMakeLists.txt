project(ACTSExternals)
cmake_minimum_required(VERSION 3.19)

set(CMAKE_CXX_STANDARD 17)

add_subdirectory(boost)
add_subdirectory(tbb)
add_subdirectory(xercesc)
add_subdirectory(python)
add_subdirectory(root)
add_subdirectory(geant4)
add_subdirectory(podio)
add_subdirectory(edm4hep)
add_subdirectory(dd4hep)
