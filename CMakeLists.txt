cmake_minimum_required(VERSION 3.16)

project("Poker View" VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Multimedia Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(PokerView
    main.cpp
)

qt_add_qml_module(PokerView
    URI poker_tournament_view
    VERSION 1.0
    QML_FILES
        Main.qml
        js/functions.js
        js/updateTimers.js
        js/main.js
        js/getServerData.js
        components/CentralColumn.qml
        components/StandartRectangle.qml
        components/InfoColumn.qml
        views/GameView.qml
        views/StartView.qml
        additional/MainMenu.qml
        additional/ChooseGame.qml
    RESOURCES resources.qrc
        #sound/blind.mp3
)

#qt_add_resources(PokerView "resources.qrc")

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(PokerView PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.apppoker_tournament_view
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

set_target_properties(PokerView PROPERTIES OUTPUT_NAME "Poker View")

target_link_libraries(PokerView
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Multimedia
)

include(GNUInstallDirs)
install(TARGETS PokerView
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

