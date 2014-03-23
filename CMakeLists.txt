# main cmake configuration file

cmake_minimum_required(VERSION 2.8.7)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Sets the configuration to build (Release, Debug, etc...)")
endif()

project(shilling)

if (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANGXX)
    #set(CMAKE_CXX_FLAGS_RELEASE "-O2 -pipe -g -ansi -pedantic -Wall -Wno-format -Wno-long-long -Wno-variadic-macros")
    # -ansi fails with utils.cpp
	
    set(CMAKE_CXX_FLAGS_RELEASE "-O2 -static-libgcc -pipe -g -Wall -Wno-unused-local-typedefs -Wno-format -Wno-long-long -Wno-variadic-macros -Wno-unused-value -Wno-maybe-uninitialized -Wno-unused-function -Wno-unused-variable -Wno-reorder -Wno-strict-aliasing")
    set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "-static -Wl,--no-undefined -static-libgcc -Wl,-O1 -Wl,--as-needed -Wl,--sort-common -s")
endif ()
 
if(MSVC)
    # MSVC complain a lot of possible unsecure std function
    add_definitions(-D_SCL_SECURE_NO_WARNINGS)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif(MSVC)
 
set(SHILLING_VERSION_MAJOR 0)
set(SHILLING_VERSION_MINOR 8)
set(SHILLING_VERSION_PATCH 6)
set(SHILLING_VERSION ${SHILLING_VERSION_MAJOR}.${SHILLING_VERSION_MINOR}.${SHILLING_VERSION_PATCH}) 

set(PACKAGE_NAME \"${PROJECT_NAME}\")
set(PACKAGE_VERSION \"${SHILLING_VERSION}\")
set(PACKAGE_BUGREPORT \"Shilling Developers\")
set(PACKAGE_AUTHORS \"Shilling Developers\")

################################################################################
# Check for libs and other packages we might use.
################################################################################

include(CheckIncludeFileCXX)

if (MSVC)
    find_package(Boost 1.46.0 COMPONENTS thread system chrono date_time)
elseif (WIN32)	    
    find_package(Boost 1.54.0 REQUIRED system
                                   filesystem
                                   program_options
                                   thread
                                   date_time
                                   regex
                                   chrono)
else()
    find_package(Boost 1.35.0 REQUIRED system
                                   filesystem
                                   program_options
                                   thread
                                   date_time
                                   regex)
endif()
link_directories(${BOOST_LIBRARYDIR})
add_definitions(-DBOOST_THREAD_USE_LIB -DBOOST_SPIRIT_THREADSAFE)    
set(Boost_USE_STATIC_LIBS ON)

set(DB_VERSION 4.8)
find_package(BerkeleyDB REQUIRED)

find_package(OpenSSL REQUIRED)

set(USE_QRCODE false)

#set(QT_USE_IMPORTED_TARGETS TRUE)
find_package(Qt4 REQUIRED)
set(QT_CODECS_PLUGINS qcncodecs qjpcodecs qtwcodecs qkrcodecs qtaccessiblewidgets)
set(QT_USE_QTNETWORK TRUE)
add_definitions(-DSHILLING_NEED_QT_PLUGINS -DQT_GUI -DSTATIC)
link_directories(${QT_PLUGINS_DIR})   

################################################################################
# 
################################################################################
set (CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
#qt4_deploy_plugin()
add_subdirectory(src)
