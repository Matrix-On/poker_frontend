import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "functions.js" as Functions

ApplicationWindow {
    id: appStart
    visible: true
    width: 1024
    height: 768
    title: "Poker tournament view"

    property double coeffHColumnSideRectangles: 0.19 // коэфф от которого зависит высота ячеек в гриде 0.193
    property double coeffWColumnSideRectangles: 0.0005 // коэфф от которого зависит ширина ячеек в гриде
    property double coeffHColumnSideText: 0.25 // коэфф от которого зависит размер текста
    property double coeffGridMargins: 0.005 // расстояние между сеткой и стенками экрана
    property double coeffGridSpacing: 0.0005 // растояние между данными в колонках
    property double coeffHColumnSpacing: 0.005 // отступы между колонками
    property double coeffHColumnTimerRectangles: 0.315 // отступы между колонками 0.35
    property double coeffHColumnBlindRectangles: 0.635 // отступы между колонками 0.635
    property double coeffWColumnMidRectangles: 0.0015 // коэфф от которого зависит ширина ячеек в гриде
    property double coeffHColumnTimerText: 0.8 // коэфф от которого зависит размер текста
    property double coeffHColumnBlindText: 0.175 // коэфф от которого зависит размер текста

    property int current_level: 0
    property int break_after_level: 4
    property int break_minutes: 15
    property int level_minutes: 20
    property var leftColumnData: [
        "Entries:\n 0",
        "Players In:\n 0",
        "Chip Count:\n 0",
        "Avg. Stack:\n 0",
        "Total Pot:\n 0"
    ]
    property var rightColumnData: [
        "Level:\n 18",
        "Current Time:\n 7:43:29",
        "Elapsed Time:\n 6:45:00",
        "Next Break:\n 28:13",
        "Rebuy price:\n 50 BYN"
    ]

    property var timerList: [30, 60, 12]
    property var blindList: ["Blinds: 3,000 / 6,000 / 1,000\n--------------------\nNext: 6,000 / 12,000 / 2,000", "Blinds\n6,000 / 12,000\nAnte: 2,000", ""]
    property int currentTimerIndex: -1
    property int countdownSeconds: 0
    property int elapsedSeconds: 0

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
            onTriggered: {
                if (countdownSeconds > 0) {
                    elapsedSeconds++;
                    countdownSeconds--;
                    updateDisplayTimer();
                } else {
                    // Переход к следующему таймеру
                    currentTimerIndex++;
                    if (currentTimerIndex < blindList.length) {
                        countdownSeconds = level_minutes * 60; // Перевод минут в секунды
                        updateBlind();
                        updateDisplayTimer();
                    } else {
                        mainTimer.stop(); // Остановить таймер, если достигнут конец списка
                    }
                }
            }
        }

        RowLayout {
            id: topRow
            //anchors.centerIn: parent.anchors.TopAnchorx
            anchors.top: parent.top
            Layout.fillWidth: true
            spacing: 0//appStart.width * 0.01

            Rectangle {
                color: "green"
                Layout.fillWidth: true
                Layout.preferredHeight: appStart.height * 0.05  // Увеличенная высота для информации о призах
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
                    model: leftColumnData
                    Rectangle {
                        color: "green"
                        Layout.fillWidth: true
                        Layout.preferredHeight: appStart.height * coeffHColumnSideRectangles  // Увеличенная высота
                        Layout.preferredWidth: appStart.width * coeffWColumnSideRectangles
                        radius: 5
                        border.color: "black"
                        border.width: 2

                        Text {
                            anchors.fill: parent
                            text: modelData
                            font.pixelSize: parent.height * coeffHColumnSideText
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
                    Layout.preferredHeight: appStart.height * coeffHColumnTimerRectangles  // Увеличенная высота для таймера  0.435
                    Layout.preferredWidth: appStart.width * coeffWColumnMidRectangles  // Увеличенная высота для таймера 0.0015
                    radius: 5
                    border.color: "black"
                    border.width: 2

                    Text {
                        id: displayTime
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: timerList[0] + " : 00";
                        font.pixelSize: parent.height * coeffHColumnTimerText  // Увеличим шрифт для таймера
                        color: "white"
                        font.bold: true
                    }
                }

                Rectangle {
                    color: "green"
                    Layout.fillWidth: true
                    Layout.preferredHeight: appStart.height * coeffHColumnBlindRectangles  // Увеличенная высота для блайндов
                    Layout.preferredWidth: appStart.width * coeffWColumnMidRectangles  // Увеличенная высота для таймера
                    radius: 5
                    border.color: "black"
                    border.width: 2

                    Text {
                        id: blindText
                        anchors.fill: parent
                        text: "Blinds:\n3,000 / 6,000\nAnte: 1,000\nNext: 6,000 / 12,000 / 2,000"
                        font.pixelSize: parent.height * coeffHColumnBlindText
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
                    model: rightColumnData
                    Rectangle {
                        color: "green"
                        Layout.fillWidth: true
                        Layout.preferredHeight: appStart.height * coeffHColumnSideRectangles
                        Layout.preferredWidth: appStart.width * coeffWColumnSideRectangles
                        radius: 5
                        border.color: "black"
                        border.width: 2

                        Text {
                            anchors.fill: parent
                            text: modelData
                            font.pixelSize: parent.height * coeffHColumnSideText
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

    function updateDisplayTimer() {
        var minutes = Math.floor(countdownSeconds / 60);
        var seconds = countdownSeconds % 60;
        displayTime.text = minutes + " : " + (seconds < 10 ? "0" : "") + seconds;
        var break_seconds = (break_after_level - current_level) * level_minutes * 60 - (level_minutes * 60 - countdownSeconds);
        minutes = Math.floor(break_seconds / 60);
        seconds = break_seconds % 60;
        rightColumnData[3] = "Next Break:\n" +  minutes + " : " + (seconds < 10 ? "0" : "") + seconds;
        var hours = Math.floor(elapsedSeconds / 360);
        minutes = Math.floor(elapsedSeconds / 60);
        seconds = elapsedSeconds % 60;

        rightColumnData[2] = "Elapsed Time:\n" + hours + " : " + (minutes < 10 ? "0" : "")
                +  minutes + " : " + (seconds < 10 ? "0" : "") + seconds;

        var now = new Date();
        rightColumnData[1] = "Current Time:\n" + now.getHours().toString().padStart(2, '0') + ":" +
                       now.getMinutes().toString().padStart(2, '0') + ":" +
                       now.getSeconds().toString().padStart(2, '0');

        repeaterRightColumnData.model = rightColumnData;
    }

    function updateBlind() {
        blindText.text = blindList[currentTimerIndex];
    }
}
