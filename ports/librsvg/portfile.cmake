include(vcpkg_common_functions)


vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "GNOME/librsvg"
    REF "2.48.4"
    SHA512 "41676e80527f31728c5bd62fac1f48842b50f548562ae83a5765188f2303ff7d236c4211d37e458f37b652b4dc60807d442bfc10dfbf826ebab09f80a73fff54"
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

vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-librsvg TARGET_PATH share/unofficial-librsvg)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/librsvg RENAME copyright)

vcpkg_copy_pdbs()

vcpkg_test_cmake(PACKAGE_NAME unofficial-librsvg)
# vi: se ts=4 sw=4 et:
