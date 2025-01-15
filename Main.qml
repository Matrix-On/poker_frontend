import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "js/main.js" as Functions

ApplicationWindow {
    id: appStart
    visible: true
    width: 1024
    height: 768
    title: "Poker tournament view"

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

    Rectangle {
        anchors.fill: parent
        color: "black"

        Timer {
            id: dataFetchTimer
            interval: 5000 // 5 секунд
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: Functions.fetchDataFromServer(repeaterLeftColumnData, repeaterRightColumnData)
        }

        Timer {
            id: mainTimer
            interval: 1000 // 1 секунда
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: Functions.triggeredBlindsTimer()
        }

        RowLayout {
            id: topRow
            //anchors.centerIn: parent.anchors.TopAnchorx
            anchors.top: parent.top
            Layout.fillWidth: true
            spacing: 0 //appStart.width * 0.01

            Rectangle {
                color: "green"
                Layout.fillWidth: true
                Layout.preferredHeight: appStart.height * constanstCoeffs.rowNameText // Увеличенная высота для информации о призах
                Layout.preferredWidth: appStart.width
                radius: 5
                border.color: "black"
                border.width: 2

                Text {
                    anchors.fill: parent
                    text: "#1 Scam-main 5000 re-entry 50"
                    font.pixelSize: parent.height
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                }
            }
        }


        GridLayout {
            anchors.top: topRow.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 0//appStart.width * coeffGridMargins
            columns: 3
            rowSpacing: 0//appStart.height * coeffGridSpacing
            columnSpacing: 0//appStart.width * coeffGridSpacing
            // Left Column (Information)
            ColumnLayout {
                Layout.column: 0
                spacing: 0//appStart.height * coeffHColumnSpacing

                Repeater {
                    id: repeaterLeftColumnData
                    model: dataValue.leftColumn
                    Rectangle {
                        color: "green"
                        Layout.fillWidth: true
                        Layout.preferredHeight: appStart.height * constanstCoeffs.hColumnSideRectangles  // Увеличенная высота
                        Layout.preferredWidth: appStart.width * constanstCoeffs.wColumnSideRectangles
                        radius: 5
                        border.color: "black"
                        border.width: 2

                        Text {
                            anchors.fill: parent
                            text: modelData
                            font.pixelSize: parent.height * constanstCoeffs.columnSideText
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }

            // Center Column (Timer and Blinds)
            ColumnLayout {
                Layout.column: 1
                spacing: 0//parent.height * coeffHColumnSpacing

                Rectangle {
                    color: "green"
                    Layout.fillWidth: true
                    Layout.preferredHeight: appStart.height * constanstCoeffs.hColumnTimerRectangles  // Увеличенная высота для таймера  0.435
                    Layout.preferredWidth: appStart.width * constanstCoeffs.wColumnMidRectangles  // Увеличенная высота для таймера 0.0015
                    radius: 5
                    border.color: "black"
                    border.width: 2

                    Text {
                        id: displayTime
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: ""
                        font.pixelSize: parent.height * constanstCoeffs.columnTimerText  // Увеличим шрифт для таймера
                        color: "white"
                        font.bold: true
                    }
                }

                Rectangle {
                    color: "green"
                    Layout.fillWidth: true
                    Layout.preferredHeight: appStart.height * constanstCoeffs.hColumnBlindRectangles  // Увеличенная высота для блайндов
                    Layout.preferredWidth: appStart.width *constanstCoeffs.wColumnMidRectangles  // Увеличенная высота для таймера
                    radius: 5
                    border.color: "black"
                    border.width: 2

                    Text {
                        id: blindText
                        anchors.fill: parent
                        text: ""
                        font.pixelSize: parent.height * constanstCoeffs.columnBlindText
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                    }
                }
            }

            // Right Column (Additional Information)
            ColumnLayout {
                Layout.column: 2
                spacing: 0//parent.height * coeffHColumnSpacing

                Repeater {
                    id: repeaterRightColumnData
                    model: dataValue.rightColumn
                    Rectangle {
                        color: "green"
                        Layout.fillWidth: true
                        Layout.preferredHeight: appStart.height * constanstCoeffs.hColumnSideRectangles
                        Layout.preferredWidth: appStart.width * constanstCoeffs.wColumnSideRectangles
                        radius: 5
                        border.color: "black"
                        border.width: 2

                        Text {
                            anchors.fill: parent
                            text: modelData
                            font.pixelSize: parent.height * constanstCoeffs.columnSideText
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            wrapMode: Text.Wrap
                        }
                    }
                }
            }
        }
    }


}
