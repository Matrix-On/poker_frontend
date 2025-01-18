import QtCore
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "views"
import "additional"

ApplicationWindow {
    id: appStart
    visible: true
    width: 1024
    height: 768
    title: "Poker tournament view"

    menuBar: MainMenu {
        id: pokerMenu
        in_game: dataValue.game_is_end ? false : (dataValue.game_id > 0 ? true : false)
        in_pause: dataValue.game_in_pause
        game_started: dataValue.game_is_start
    }

    ChooseGame {
        id: chooseGame
        model: dataValue.gamesModel
    }

    property var constanstCoeffs: {
        "hColumnSideRectangles": 0.19, // коэфф от которого зависит высота ячеек в гриде
        "wColumnSideRectangles": 0.0005, // коэфф от которого зависит ширина ячеек в гриде
        "hColumnTimerRectangles": 0.315,  // отступы между колонками
        "hColumnBlindRectangles": 0.635, // отступы между колонками
        "wColumnMidRectangles": 0.0015, // коэфф от которого зависит ширина ячеек в гриде
        "columnTimerText": 0.8, // коэфф от которого зависит размер текста таймера
        "columnBlindText": 0.175, // коэфф от которого зависит размер текста блайндов
        "columnSideText": 0.25, // коэфф от которого зависит размер текста боковых колонок
        "rowNameText": 0.05,  // коэфф от которого зависит размер текста шапки
        "gridMargins": 0.005,  // расстояние между сеткой и стенками экрана
        "gridSpacing": 0.0005,  // растояние между данными в колонках
        "hColumnSpacing": 0.005 // отступы между колонками
    }

    property var enumGameOperations: {
        "start": 1,
        "end": 2,
        "pause": 3,
        "unpause": 4,
        "next_level": 5,
        "time_break": 6,
        "end_time_break": 7,
        "expired": 8
    }

    Item {
        id: dataValue
        property string blindText: "Blids:\n"
        property string timerText: "0 : 00"
        property string headerText: "Poker Tournier"

        property ListModel gamesModel: ListModel {
        }

        property ListModel leftColumn: ListModel {
            ListElement { text: "Entries:\n"}
            ListElement { text: "Players In:\n" }
            ListElement { text: "Chip Count:\n" }
            ListElement { text: "Avg. Stack:\n" }
            ListElement { text: "Total Pot:\n" }
        }
        property ListModel rightColumn: ListModel {
            ListElement { text: "Level:\n "}
            ListElement { text: "Current Time:\n" }
            ListElement { text: "Elapsed Time:\n" }
            ListElement { text: "Next Break:\n" }
            ListElement { text: "Rebuy price:\n" }
        }

        property bool game_is_end: false
        property bool game_is_start: false
        property bool game_in_pause: false
        property int game_id: 0

        property int current_level: 1
        property int break_after_level: 4
        property int next_break_after: 4
        property int break_minutes: 15
        property real level_minutes: 0.1
        property int elapsed_seconds: 0
        property real count_down_seconds: 0.1*60
        property int current_timer_index: 0
        property var operations: [
            {
                "id": 1,
                "operation": 0,
                "success_at": "2025-01-14T01:14:55.884000"
            }
        ]

        property var blinds: [
            {
                "small_blind": 25,
                "big_blind": 25,
                "ante": 1
            },
            {
                "small_blind": 25,
                "big_blind": 25,
                "ante": 1
            },
        ]
    }

    StackView {
            id: stackView
            anchors.fill: parent
            initialItem: Item {
                GameView {
                     anchors.fill: parent
                }
            }
        }
}
