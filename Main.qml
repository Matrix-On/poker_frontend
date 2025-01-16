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

    property  var dataValue: {
        "leftColumn": [
            "Entries:\n 0",
            "Players In:\n 0",
            "Chip Count:\n 0",
            "Avg. Stack:\n 0",
            "Total Pot:\n 0"
        ],
        "rightColumn": [
                "Level:\n 18",
                "Current Time:\n 7:43:29",
                "Elapsed Time:\n 6:45:00",
                "Next Break:\n 28:13",
                "Rebuy price:\n 50 BYN"
        ],
        "current_level": 1,
        "break_after_level": 4,
        "next_break_after": 4,
        "break_minutes": 15,
        "level_minutes": 0.1,
        "elapsed_seconds": 0,
        "count_down_seconds": 0.1*60,
        "current_timer_index": 0,
        "blinds": [
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
        ],
        "started_at" : ""
    }

    StackView {
            id: stackView
            anchors.fill: parent
            initialItem: Item {
                StartView {
                     anchors.fill: parent
                }
            }
        }


}
