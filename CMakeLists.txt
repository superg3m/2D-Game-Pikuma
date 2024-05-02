cmake_minimum_required(VERSION 3.20)

project(Project_Game)
set(PROJECT_VERSION 0.1.0)

if(WIN32)
  set(VCPKG_TARGET_TRIPLET "x64-windows-static") # on windows
elseif(APPLE)
  set(VCPKG_TARGET_TRIPLET "arm64-osx") # on APPLE
else()
  # linux
endif()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(WIN32)
    message(STATUS "========= Building on Windows =========")
elseif(APPLE)
	message(STATUS "========= Building on APPLE =========")
endif()

file(GLOB SOURCES_C "${CMAKE_CURRENT_SOURCE_DIR}/source/*.c")
file(GLOB SOURCES_CPP "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")

add_executable(
	Target_Desktop
	${SOURCES_C}
	${SOURCES_CPP}
)

if (MSVC)
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /D_ITERATOR_DEBUG_LEVEL=2")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /D_ITERATOR_DEBUG_LEVEL=0")
	set_property(TARGET Target_Desktop PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Release>:Release>")
	set_property(TARGET Target_Desktop PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
	set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY VS_STARTUP_PROJECT Target_Desktop)
endif()


target_include_directories(
	Target_Desktop
	PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/include"
	"${CMAKE_CURRENT_SOURCE_DIR}/../core/include"
	"${CMAKE_CURRENT_SOURCE_DIR}/../vcpkg/installed/${VCPKG_TARGET_TRIPLET}/include"
	"${CMAKE_CURRENT_SOURCE_DIR}/../vcpkg/installed/arm64-ios/include"
)

message(STATUS "========= ${CMAKE_BUILD_TYPE} =========")

set(LIB_LINK_DIRS "")
list(APPEND 
     LIB_LINK_DIRS 
     "$<$<CONFIG:Release>:${CMAKE_CURRENT_SOURCE_DIR}/../core/projects/desktop/Release>"
     "$<$<CONFIG:Debug>:${CMAKE_CURRENT_SOURCE_DIR}/../core/projects/desktop/Debug>"

     "$<$<CONFIG:Release>:${CMAKE_CURRENT_SOURCE_DIR}/../vcpkg/installed/${VCPKG_TARGET_TRIPLET}/lib>"
     "$<$<CONFIG:Debug>:${CMAKE_CURRENT_SOURCE_DIR}/../vcpkg/installed/${VCPKG_TARGET_TRIPLET}/debug/lib>"

     "$<$<CONFIG:Release>:${CMAKE_CURRENT_SOURCE_DIR}/../vcpkg/installed/arm64-ios/lib>"
     "$<$<CONFIG:Debug>:${CMAKE_CURRENT_SOURCE_DIR}/../vcpkg/installed/arm64-ios/debug/lib>"
    )

set(LIBS_COMMON "")
list(APPEND LIBS_COMMON "brotlicommon")
list(APPEND LIBS_COMMON "brotlidec")
list(APPEND LIBS_COMMON "brotlienc")
list(APPEND LIBS_COMMON "draco")
list(APPEND LIBS_COMMON "kubazip")
list(APPEND LIBS_COMMON "minizip")
list(APPEND LIBS_COMMON "poly2tri")
list(APPEND LIBS_COMMON "polyclipping")
list(APPEND LIBS_COMMON "glfw3")
list(APPEND LIBS_COMMON "UnitTest++")
list(APPEND LIBS_COMMON "pugixml")
list(APPEND LIBS_COMMON "glad")

if (WIN32)

	set(OpenGL32, "OpenGL32")

	set(LIBS_CONFIG "")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:zlib>" "$<$<CONFIG:Debug>:zlibd>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:libpng16>" "$<$<CONFIG:Debug>:libpng16d>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:bz2>" "$<$<CONFIG:Debug>:bz2d>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:imgui>" "$<$<CONFIG:Debug>:imguid>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:assimp-vc143-mt.lib>" "$<$<CONFIG:Debug>:assimp-vc143-mtd.lib>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:freetype>" "$<$<CONFIG:Debug>:freetyped>")

	target_link_directories(
	    Target_Desktop
	    PUBLIC
	    ${LIB_LINK_DIRS}
	)
elseif(APPLE)
	find_library(COREFOUNDATION_LIBRARY CoreFoundation)
  	find_library(COREGRAPHICS_FRAMEWORK CoreGraphics)
  	find_library(IOKIT_FRAMEWORK IOKit)
	find_library(APPKIT_FRAMEWORK AppKit)
	find_library(OpenGL32 OpenGL)

	set(LIBS_CONFIG "")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:z>" "$<$<CONFIG:Debug>:z>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:png>" "$<$<CONFIG:Debug>:png>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:png16>" "$<$<CONFIG:Debug>:png16d>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:bz2>" "$<$<CONFIG:Debug>:bz2d>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:imgui>" "$<$<CONFIG:Debug>:imguid>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:assimp>" "$<$<CONFIG:Debug>:assimpd>")
	list(APPEND LIBS_CONFIG "$<$<CONFIG:Release>:freetype>" "$<$<CONFIG:Debug>:freetyped>")

	target_link_directories(
	    Target_Desktop
	    PUBLIC
	    ${LIB_LINK_DIRS}
	    /System/Library/Frameworks/OpenGL.framework
	)
endif()

target_link_libraries(
	Target_Desktop
	Target_Uproot
	${LIBS_COMMON}
	${LIBS_CONFIG}
	${OpenGL32}
	${COREFOUNDATION_LIBRARY}
	${COREGRAPHICS_FRAMEWORK}
	${IOKIT_FRAMEWORK}
	${APPKIT_FRAMEWORK}
)
