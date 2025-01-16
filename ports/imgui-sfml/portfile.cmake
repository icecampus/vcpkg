vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO eliasdaler/imgui-sfml
    REF "v${VERSION}"
    SHA512 76e3fc19caa3c5b0d8f294052720d939113457bcc8ed6d5b6c59b2e394088b78fb18848bc85dd44b4763e8ef76cae5c993a947b7dd3e20026563f6369d8dce94
    HEAD_REF master
    PATCHES
        0001-fix_find_package.patch
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_CXX_STANDARD=11
)
vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ImGui-SFML)
file(READ "${CURRENT_PACKAGES_DIR}/share/imgui-sfml/ImGui-SFMLConfig.cmake" cmake_config)
string(PREPEND cmake_config [[
include(CMakeFindDependencyMacro)
find_dependency(imgui CONFIG)
find_dependency(SFML COMPONENTS graphics system window)
]])
file(WRITE "${CURRENT_PACKAGES_DIR}/share/imgui-sfml/ImGui-SFMLConfig.cmake" "${cmake_config}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
