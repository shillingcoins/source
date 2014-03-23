set(TARGET_NAME shilling-qt)

include(${QT_USE_FILE})
add_definitions(${QT_DEFINITIONS})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_BINARY_DIR})

file (GLOB SOURCE_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.cpp)
file (GLOB HEADER_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.h)
file (GLOB FORM_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" forms/*.ui)
file (GLOB RES_FILES RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" *.qrc)

if (${USE_QRCODE})
else ()
    list(REMOVE_ITEM SOURCE_FILES qrcodedialog.cpp)
    list(REMOVE_ITEM HEADER_FILES qrcodedialog.h)
    list(REMOVE_ITEM FORM_FILES forms/qrcodedialog.ui)
endif()

if (NOT APPLE)
    list(REMOVE_ITEM HEADER_FILES macdockiconhandler.h)
endif()

if (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANGXX)
    set (EXTRA_OPTIONS "")     
    set_source_files_properties(${SOURCE_FILES}
        PROPERTIES 
        COMPILE_FLAGS  "${EXTRA_OPTIONS}")
endif() 

qt4_wrap_cpp(HEADER_MOC_FILES ${HEADER_FILES})
qt4_wrap_ui(HEADER_FORMS ${FORM_FILES})
qt4_add_resources(RESOURCE_FILES ${RES_FILES})
    
add_executable(${TARGET_NAME} ${SOURCE_FILES} 
                ${HEADER_MOC_FILES}
                ${HEADER_FORMS}
                ${RESOURCE_FILES}
                ${HEADER_MOC_CXX_FILES})
    
if (WIN32)
    add_definitions(-D_WIN32_WINNT=0x0501)
	add_definitions(-DWINVER=0x0501)
	target_link_libraries(${TARGET_NAME} wsock32)
	target_link_libraries(${TARGET_NAME} Ws2_32)
    
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mwindows") # Not tested
elseif (MSVC)
    #set_target_properties(${TARGET_NAME} PROPERTIES LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS")
elseif (APPLE)

else()
    
endif ()
    
add_dependencies(${TARGET_NAME} shilling)

target_link_libraries(${TARGET_NAME} shilling)
target_link_libraries(${TARGET_NAME} ${QT_LIBRARIES} ${QT_QTMAIN_LIBRARY} ${QT})
target_link_libraries(${TARGET_NAME} ${QT_QJPCODECS_PLUGIN_RELEASE} ${QT_QCNCODECS_PLUGIN_RELEASE} ${QT_QKRCODECS_PLUGIN_RELEASE})
target_link_libraries(${TARGET_NAME} ${QT_QKRCODECS_PLUGIN_RELEASE})
target_link_libraries(${TARGET_NAME} ${DB_LIBRARIES})
target_link_libraries(${TARGET_NAME} ${OPENSSL_LIBRARIES})
target_link_libraries(${TARGET_NAME} ${Boost_SYSTEM_LIBRARIES})
target_link_libraries(${TARGET_NAME} ${Boost_THREAD_LIBRARIES})
target_link_libraries(${TARGET_NAME} ${Boost_FILESYSTEM_LIBRARIES})
target_link_libraries(${TARGET_NAME} ${Boost_PROGRAM_OPTIONS_LIBRARIES})

# if (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANGXX)
#     message("###########################")
#     target_link_libraries(${TARGET_NAME} -Wl,-Bstatic -Wl,-z,relro -Wl,-z,now)
# endif()


install(TARGETS ${TARGET_NAME} DESTINATION bin)

