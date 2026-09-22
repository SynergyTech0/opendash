cmake_minimum_required(VERSION 3.21)

project(OpenDash VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

# Qt 6.4+ (bookworm on the Raspberry Pi ships 6.4). Icons and album art are
# drawn with Qt Quick Shapes (part of Qt Quick), so no QtSvg dependency.
# QtQuick.Controls.Basic + QtQuick.Shapes + QtQuick.Dialogs (the Settings
# background photo picker) are pulled in as QML imports at runtime; on
# Debian/RPi OS install qml6-module-qtquick-controls, qml6-module-qtquick-shapes
# and qml6-module-qtquick-dialogs alongside qt6-declarative-dev.
find_package(Qt6 6.4 REQUIRED COMPONENTS Core Gui Qml Quick)

qt_standard_project_setup(REQUIRES 6.4)

qt_add_executable(opendash
    src/main.cpp
    src/mediamodel.cpp
    src/mediamodel.h
    src/playbackcontroller.cpp
    src/playbackcontroller.h
    src/climatecontroller.cpp
    src/climatecontroller.h
    src/dash.cpp
    src/dash.h
)

# Theme and Icons are QML singletons (pragma Singleton).
set_source_files_properties(qml/Theme.qml qml/Icons.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(opendash
    URI OpenDash
    VERSION 1.0
    RESOURCE_PREFIX "/"
    QML_FILES
        qml/Main.qml
        qml/Theme.qml
        qml/Icons.qml
        qml/DashIcon.qml
        qml/AlbumArt.qml
        qml/ViewHeading.qml
        qml/TransportButton.qml
        qml/Toast.qml
        qml/NowPlaying.qml
        qml/Media.qml
        qml/ClimateView.qml
        qml/Phone.qml
        qml/Settings.qml
    # Uncomment once you drop the .ttf files in qt/assets/fonts:
    # RESOURCES
    #     assets/fonts/ChakraPetch-SemiBold.ttf
    #     assets/fonts/ChakraPetch-Bold.ttf
    #     assets/fonts/Barlow-Regular.ttf
    #     assets/fonts/Barlow-SemiBold.ttf
)

target_link_libraries(opendash PRIVATE
    Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick)

install(TARGETS opendash
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION bin)
