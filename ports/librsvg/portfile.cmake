include(vcpkg_common_functions)


vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO "GNOME/librsvg"
    REF "2.48.4"
    SHA512 "41676e80527f31728c5bd62fac1f48842b50f548562ae83a5765188f2303ff7d236c4211d37e458f37b652b4dc60807d442bfc10dfbf826ebab09f80a73fff54"
    )

vcpkg_acquire_msys(MSYS_ROOT
    PACKAGES make
    automake
    autoconf
    gettext
    gettext-devel
    pkg-config
    perl
    gtk-doc
    mingw-w64-i686-rust
    mingw-w64-x86_64-rust)

set(BASH ${MSYS_ROOT}/usr/bin/bash.exe)

set(MSYS_CMD 'cd ${SOURCE_PATH} && ./autogen.sh')

vcpkg_execute_required_process(
    COMMAND ${BASH} --login --norc -c -- ${MSYS_CMD}
    WORKING_DIRECTORY ${SOURCE_PATH}
    LOGNAME autogen)


string(FIND ${TARGET_TRIPLET} "x86" X86_TARGET)

if (X86_TARGET EQUAL -1)
    set(ENV{MSYSTEM} MINGW64)
else()
    set(ENV{MSYSTEM} MINGW32)
endif()


set(MSYS_CMD 'cd ${SOURCE_PATH} && ${SOURCE_PATH}/configure')

vcpkg_execute_required_process(
    COMMAND ${BASH} --login --norc -c -- ${MSYS_CMD} 
    WORKING_DIRECTORY ${CURRENT_PACKGES_DIR}/${BUILD_TRIPLET}
    LOGNAME ${BUILD_TRIPLET}-configure)


set(MSYS_CMD 'cd ${CURRENT_PACKGES_DIR}/${BUILD_TRIPLET} && make')


vcpkg_execute_build_process(
    COMMAND ${BASH} --login --norc -c -- ${MSYS_CMD} 
    WORKING_DIRECTORY ${CURRENT_PACKGES_DIR}/${BUILD_TRIPLET}
    LOGNAME ${BUILD_TRIPLET}-make)


set(MSYS_CMD 'cd ${CURRENT_PACKGES_DIR}/${BUILD_TRIPLET} && make install')

vcpkg_execute_build_process(
    COMMAND ${BASH} --login --norc -c -- ${MSYS_CMD} 
    WORKING_DIRECTORY ${CURRENT_PACKGES_DIR}/${BUILD_TRIPLET}
    LOGNAME ${BUILD_TRIPLET}-make-install)


vcpkg_copy_pdbs()

vcpkg_test_cmake(PACKAGE_NAME unofficial-librsvg)
# vi: se ts=4 sw=4 et:
