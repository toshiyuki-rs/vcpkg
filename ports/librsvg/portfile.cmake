include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "GNOME/librsvg"
    REF "2.50.2"
    SHA512 "5423db0386b493b7eab5db636b563ad44fda20df34ee6b1e9a9cd773d837d6ac327df30de20f4f3936c77056574aa59be2145c3862182b4c980d8bd82920bd40"
    )
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/rsvg.def DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/run-cargo.bat DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/run-rustup.bat DESTINATION ${SOURCE_PATH})

configure_file(${CMAKE_CURRENT_LIST_DIR}/config.h.linux ${SOURCE_PATH}/config.h.linux COPYONLY)
configure_file(${CMAKE_CURRENT_LIST_DIR}/config.h.win32 ${SOURCE_PATH}/config.h.win32 COPYONLY)
configure_file(${CMAKE_CURRENT_LIST_DIR}/librsvg/librsvg-features.h.win32 ${SOURCE_PATH}/librsvg/librsvg-features.h.win32 COPYONLY)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-librsvg TARGET_PATH share/unofficial-librsvg)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING.LIB DESTINATION ${CURRENT_PACKAGES_DIR}/share/librsvg RENAME copyright)

vcpkg_copy_pdbs()

# vi: se ts=4 sw=4 et:

