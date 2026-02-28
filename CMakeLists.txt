cmake_minimum_required(VERSION 3.21)
project(MistPlayer VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 Multimedia)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(mistplayer
    src/main.cpp
    src/playercontroller.cpp
    src/playlistmodel.cpp
)

target_include_directories(mistplayer PRIVATE src)

target_link_libraries(mistplayer PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Multimedia
)

qt_add_qml_module(mistplayer
    URI MistPlayer
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/GlassPanel.qml
        qml/components/ControlButton.qml
        qml/components/TimelineSlider.qml
        qml/components/QueueItem.qml
        qml/theme/Theme.qml
    RESOURCES
        assets/icons/play.svg
        assets/icons/pause.svg
        assets/icons/next.svg
        assets/icons/previous.svg
        assets/icons/queue.svg
        assets/icons/open.svg
)

install(TARGETS mistplayer
    BUNDLE DESTINATION .
    RUNTIME DESTINATION bin
)
