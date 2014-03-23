include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${Boost_INCLUDE_DIRS})
include_directories(${DB_INCLUDE_DIR})
include_directories(${DBXX_INCLUDE_DIR})
include_directories(${OPENSSL_INCLUDE_DIR})

add_subdirectory(leveldb)
add_subdirectory(qt)

set(shilling_TARGET_NAME shilling)

file (GLOB SOURCE_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.cpp)
file (GLOB HEADER_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.h)

set( SUBPATH leveldb/include; leveldb/helpers;)

foreach( path ${SUBPATH})
    include_directories(${path})
endforeach()

add_library(${shilling_TARGET_NAME} STATIC ${SOURCE_FILES})
add_dependencies(${shilling_TARGET_NAME} leveldb)

if (WIN32)
    add_definitions(-D_WIN32_WINNT=0x0501)
	add_definitions(-DWINVER=0x0501)
	target_link_libraries(${shilling_TARGET_NAME} wsock32)
	target_link_libraries(${shilling_TARGET_NAME} Ws2_32)
    target_link_libraries(${shilling_TARGET_NAME} ${Boost_CHRONO_LIBRARIES})
else()
	target_link_libraries(${shilling_TARGET_NAME} -lpthread)
endif()
# message("${Boost_SYSTEM_LIBRARIES}")
# message("${Boost_THREAD_LIBRARIES}")
# message("${Boost_PROGRAM_OPTIONS_LIBRARIES}")

target_link_libraries(${shilling_TARGET_NAME} leveldb)

target_link_libraries(${shilling_TARGET_NAME} ${DB_LIBRARIES})
target_link_libraries(${shilling_TARGET_NAME} ${OPENSSL_LIBRARIES})
target_link_libraries(${shilling_TARGET_NAME} ${Boost_SYSTEM_LIBRARIES})
target_link_libraries(${shilling_TARGET_NAME} ${Boost_THREAD_LIBRARIES})
target_link_libraries(${shilling_TARGET_NAME} ${Boost_FILESYSTEM_LIBRARIES})
target_link_libraries(${shilling_TARGET_NAME} ${Boost_PROGRAM_OPTIONS_LIBRARIES})


# 
# install(TARGETS ${shilling_TARGET_NAME} DESTINATION bin)