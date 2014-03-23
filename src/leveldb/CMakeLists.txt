set(TARGET_NAME leveldb)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

file (GLOB SOURCE_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" db/*.cc)
list(REMOVE_ITEM SOURCE_FILES db/corruption_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/db_bench.cc)
list(REMOVE_ITEM SOURCE_FILES db/db_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/dbformat_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/filename_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/leveldb_main.cc)
list(REMOVE_ITEM SOURCE_FILES db/log_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/skiplist_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/version_edit_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/version_set_test.cc)
list(REMOVE_ITEM SOURCE_FILES db/write_batch_test.cc)

file (GLOB SOURCE_FILES_TABLE RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" table/*.cc)
file (GLOB SOURCE_FILES_UTIL RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" util/*.cc)
list(APPEND SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/helpers/memenv/memenv.cc)

list(APPEND SOURCE_FILES ${SOURCE_FILES_TABLE})
list(APPEND SOURCE_FILES ${SOURCE_FILES_UTIL})

if (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANGXX)
    set (EXTRA_OPTIONS "-fno-builtin-memcmp -Wno-sign-compare -Wno-maybe-uninitialized")     
    set_source_files_properties(${SOURCE_FILES}
        PROPERTIES 
        COMPILE_FLAGS  "${EXTRA_OPTIONS}")
endif() 

if (WIN32)
    list(REMOVE_ITEM SOURCE_FILES util/env_posix.cc)
    list(APPEND SOURCE_FILES port/port_win.cc)
    add_definitions(-D_REENTRANT -DOS_WINDOWS -DLEVELDB_PLATFORM_WINDOWS -DWINVER=0x0500 -D__USE_MINGW_ANSI_STDIO=1)
elseif (MSVC)

elseif (APPLE)

else()
    add_definitions(-DOS_LINUX -DLEVELDB_PLATFORM_POSIX)
    list(REMOVE_ITEM SOURCE_FILES util/env_win.cc)
    list(APPEND SOURCE_FILES port/port_posix.cc)
endif ()
    
add_library(${TARGET_NAME} STATIC ${SOURCE_FILES})

if (WIN32)
    target_link_libraries(${TARGET_NAME} shlwapi)
endif ()




    