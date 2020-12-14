cmake_minimum_required(VERSION 3.11)
project(librsvg C)

set(RSVG_VERSION 2.50)

if(WIN32)
set(CARGO call ${CMAKE_CURRENT_SOURCE_DIR}/run-cargo)
set(RUSTUP call ${CMAKE_CURRENT_SOURCE_DIR}/run-rustup)
set(SOCKET_LIB ws2_32.lib)
set(USERENV_LIB userenv.lib)
else()
set(RUSTUP rustup)
set(CARGO cargo)
endif()

string(TOLOWER ${CMAKE_BUILD_TYPE} LOWER_BUILD_TYPE)
if (WIN32)
    if (VCPKG_TARGET_ARCHITECTURE STREQUAL x86)
        set(CARGO_TARGET_DIR
            ${CMAKE_CURRENT_SOURCE_DIR}/target/i686-pc-windows-msvc/${LOWER_BUILD_TYPE})
    else()
        set(CARGO_TARGET_DIR
            ${CMAKE_CURRENT_SOURCE_DIR}/target/x86_64-pc-windows-msvc/${LOWER_BUILD_TYPE})
    endif()
else()
    set(CARGO_TARGET_DIR ${CMAKE_CURRENT_SOURCE_DIR}/target)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
# https://github.com/rust-lang/rust/issues/43749
set(RUST_LIB
    ${CARGO_TARGET_DIR}/rsvg_c_api.lib)
else()
set(RUST_LIB
    ${CARGO_TARGET_DIR}/librsvg_c_api.a)
endif()




find_package(unofficial-cairo CONFIG REQUIRED)
find_package(unofficial-libcroco CONFIG REQUIRED)
find_package(unofficial-glib CONFIG REQUIRED)
find_package(LibXml2 REQUIRED)
if(CMAKE_SYSTEM_NAME MATCHES "Windows")
  find_library(PANGO_LIB pango-1.0)
  find_library(PANGO_CAIRO_LIB pangocairo-1.0)
  find_library(GDK_PIXBUF_LIB gdk_pixbuf-2.0)
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
  find_library(PANGO_LIB pango-1.0)
  find_library(PANGO_CAIRO_LIB pangocairo-1.0)
  find_library(GDK_PIXBUF_LIB gdk_pixbuf-2)
else()
  find_library(PANGO_LIB pango-1)
  find_library(PANGO_CAIRO_LIB pangocairo-1)
  find_library(PANGO_FT2_LIB pangoft2-1)
  find_library(FONTCONFIG_LIB fontconfig)
  find_library(GDK_PIXBUF_LIB gdk_pixbuf-2)
endif()

find_path(CAIRO_INCLUDE_DIR cairo/cairo.h)

# Add include directories
include_directories(${CAIRO_INCLUDE_DIR}
    ${GDK_PIXBUF_INCLUDE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

set(LIBRSVG_SOURCES
    librsvg/librsvg-features.c
    librsvg/rsvg-base.c
    librsvg/rsvg-handle.c
    librsvg/rsvg-pixbuf.c
    librsvg/librsvg-features.h
    librsvg/rsvg-css.h
    librsvg/rsvg.h
)

set(LIBRSVG_INTERNALS_SRC 
    Cargo.toml
    rsvg_internals/Cargo.toml
    rsvg_internals/build.rs 
    rsvg_internals/src/allowed_url.rs
    rsvg_internals/src/angle.rs 
    rsvg_internals/src/aspect_ratio.rs
    rsvg_internals/src/bbox.rs
    rsvg_internals/src/color.rs
    rsvg_internals/src/cond.rs
    rsvg_internals/src/coord_units.rs
    rsvg_internals/src/create_node.rs
    rsvg_internals/src/css.rs
    rsvg_internals/src/error.rs
    rsvg_internals/src/dasharray.rs
    rsvg_internals/src/document.rs
    rsvg_internals/src/dpi.rs
    rsvg_internals/src/drawing_ctx.rs
    rsvg_internals/src/filter.rs
    rsvg_internals/src/filters/bounds.rs
    rsvg_internals/src/filters/blend.rs
    rsvg_internals/src/filters/color_matrix.rs
    rsvg_internals/src/filters/component_transfer.rs
    rsvg_internals/src/filters/composite.rs 
    rsvg_internals/src/filters/convolve_matrix.rs
    rsvg_internals/src/filters/context.rs
    rsvg_internals/src/filters/displacement_map.rs
    rsvg_internals/src/filters/error.rs 
    rsvg_internals/src/filters/flood.rs
    rsvg_internals/src/filters/gaussian_blur.rs
    rsvg_internals/src/filters/image.rs 
    rsvg_internals/src/filters/light/light_source.rs
    rsvg_internals/src/filters/light/lighting.rs
    rsvg_internals/src/filters/light/mod.rs 
    rsvg_internals/src/filters/merge.rs 
    rsvg_internals/src/filters/morphology.rs
    rsvg_internals/src/filters/mod.rs
    rsvg_internals/src/filters/input.rs
    rsvg_internals/src/filters/offset.rs
    rsvg_internals/src/filters/tile.rs
    rsvg_internals/src/filters/turbulence.rs
    rsvg_internals/src/float_eq_cairo.rs
    rsvg_internals/src/font_props.rs
    rsvg_internals/src/gradient.rs
    rsvg_internals/src/handle.rs
    rsvg_internals/src/image.rs
    rsvg_internals/src/io.rs
    rsvg_internals/src/iri.rs
    rsvg_internals/src/length.rs
    rsvg_internals/src/lib.rs
    rsvg_internals/src/limits.rs
    rsvg_internals/src/log.rs
    rsvg_internals/src/marker.rs
    rsvg_internals/src/node.rs
    rsvg_internals/src/number_list.rs
    rsvg_internals/src/paint_server.rs
    rsvg_internals/src/parsers.rs
    rsvg_internals/src/path_builder.rs
    rsvg_internals/src/path_parser.rs
    rsvg_internals/src/pattern.rs
    rsvg_internals/src/properties.rs
    rsvg_internals/src/property_bag.rs
    rsvg_internals/src/property_defs.rs
    rsvg_internals/src/property_macros.rs
    rsvg_internals/src/rect.rs
    rsvg_internals/src/shapes.rs
    rsvg_internals/src/surface_utils/iterators.rs
    rsvg_internals/src/surface_utils/mod.rs
    rsvg_internals/src/surface_utils/shared_surface.rs
    rsvg_internals/src/surface_utils/srgb.rs
    rsvg_internals/src/space.rs 
    rsvg_internals/src/structure.rs
    rsvg_internals/src/style.rs 
    rsvg_internals/src/text.rs
    rsvg_internals/src/transform.rs 
    rsvg_internals/src/unit_interval.rs 
    rsvg_internals/src/util.rs
    rsvg_internals/src/viewbox.rs
    rsvg_internals/src/xml.rs
    rsvg_internals/src/xml2.rs
    rsvg_internals/src/xml2_load.rs
)

set(LIBRSVG_C_API_SRC
    librsvg/Cargo.toml
    librsvg/c_api.rs
    librsvg/color_utils.rs
    librsvg/lib.rs
    librsvg/pixbuf_utils.rs 
)


set(PIXBUFLOADERSVG_SOURCES 
    gdk-pixbuf-loader/io-svg.c
)

if(WIN32)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.win32 ${CMAKE_CURRENT_SOURCE_DIR}/config.h COPYONLY)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/librsvg/librsvg-features.h.win32 ${CMAKE_CURRENT_SOURCE_DIR}/librsvg/librsvg-features.h COPYONLY)

    list(APPEND LIBRSVG_SOURCES rsvg.def)

    if (VCPKG_TARGET_ARCHITECTURE STREQUAL x86)
        set(CARGO_TARGET_ARGS --target i686-pc-windows-msvc)
        set(RUST_TOOL_CHAIN stable-i686-pc-windows-msvc)
    else()
        set(CARGO_TARGET_ARGS --target x86_64-pc-windows-msvc)
        set(RUST_TOOL_CHAIN stable-x86_64-pc-windows-msvc)
    endif()

else()
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.linux ${CMAKE_CURRENT_SOURCE_DIR}/config.h COPYONLY)
    list(APPEND LIBRSVG_SOURCES rsvg.symbols)
endif()

set(CARGO_RELEASE_FLAG $<$<CONFIG:Release>:--release>)   


set(CMAKE_DEBUG_POSTFIX "d")

add_library(rsvg-${RSVG_VERSION} ${LIBRSVG_SOURCES})
add_library(pixbufloader-svg ${PIXBUFLOADERSVG_SOURCES})

target_compile_definitions(rsvg-${RSVG_VERSION} PRIVATE -DRSVG_COMPILATION -D_CRT_SECURE_NO_WARNINGS -DSRCDIR="${CMAKE_CURRENT_SOURCE_DIR}")

target_include_directories(pixbufloader-svg PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_definitions(pixbufloader-svg PRIVATE 
    -DRSVG_COMPILATION 
    -D_CRT_SECURE_NO_WARNINGS
    -DSRCDIR="${CMAKE_CURRENT_SOURCE_DIR}" 
    -DGDK_PIXBUF_ENABLE_BACKEND 
    -DG_LOG_DOMAIN="libpixbufloader-svg")

add_custom_command(OUTPUT ${RUST_LIB}
    COMMAND ${RUSTUP} default ${RUST_TOOL_CHAIN} 
    COMMAND ${CARGO} --locked build ${CARGO_TARGET_ARGS} ${CARGO_RELEASE_FLAG}
    DEPENDS ${LIBRSVG_C_API_SRC} ${LIBRSVG_INTERNALS_SOURCES}
    COMMENT Buid rust-rsvg library
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )

#add_custom_command(
#    TARGET rsvg-${RSVG_VERSION}
#    PRE_LINK
#    COMMAND ${RUSTUP} default ${RUST_TOOL_CHAIN} 
#    COMMAND ${CARGO} --locked build ${CARGO_TARGET_ARGS} ${CARGO_RELEASE_FLAG}
#    DEPENDS ${LIBRSVG_C_API_SRC} ${LIBRSVG_INTERNALS_SOURCES}
#    COMMENT Buid rust-rsvg library
#    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
#    )

add_custom_target(rsvg_c_api_libs
    DEPENDS ${RUST_LIB})

add_dependencies(rsvg-${RSVG_VERSION} rsvg_c_api_libs)

target_link_libraries(rsvg-${RSVG_VERSION} PRIVATE
    ${SOCKET_LIB}
    ${USERENV_LIB} 
    unofficial::cairo::cairo
    unofficial::cairo::cairo-gobject
    unofficial::libcroco::croco-0.6
    unofficial::glib::gio
    unofficial::glib::glib
    unofficial::glib::gmodule
    unofficial::glib::gobject
    ${RUST_LIB}
    ${LIBXML2_LIBRARIES}
    ${PANGO_LIB}
    ${PANGO_CAIRO_LIB}
    ${GDK_PIXBUF_LIB}
    ${PANGO_FT2_LIB}
    ${FONTCONFIG_LIB}
)

target_link_libraries(pixbufloader-svg PRIVATE
    rsvg-${RSVG_VERSION}
    unofficial::glib::glib
    unofficial::glib::gobject
    ${GDK_PIXBUF_LIB}
)


install(TARGETS rsvg-${RSVG_VERSION} pixbufloader-svg
    EXPORT librsvg-targets
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(
    EXPORT librsvg-targets
    NAMESPACE unofficial::librsvg::
    FILE unofficial-librsvg-targets.cmake
    DESTINATION share/unofficial-librsvg
)

install(FILES
    librsvg/rsvg.h
    librsvg/rsvg-cairo.h
    librsvg/librsvg-features.h
    DESTINATION include/librsvg
)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/unofficial-librsvg-config.cmake "
include(CMakeFindDependencyMacro)
find_dependency(unofficial-cairo CONFIG)
find_dependency(unofficial-libcroco CONFIG)
find_dependency(gdk-pixbuf CONFIG)
find_dependency(pango CONFIG)

include(\${CMAKE_CURRENT_LIST_DIR}/unofficial-librsvg-targets.cmake)
")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/unofficial-librsvg-config.cmake DESTINATION share/unofficial-librsvg)

# vi: se ts=4 sw=4 et:
