import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: appStart
    visible: true
    width: 1024
    height: 768
    title: "Poker tournament view"

    property double coeffHColumnSideRectangles: 0.193 // коэфф от которого зависит высота ячеек в гриде
    property double coeffWColumnSideRectangles: 0.0005 // коэфф от которого зависит ширина ячеек в гриде
    property double coeffHColumnSideText: 0.25 // коэфф от которого зависит размер текста
    property double coeffGridMargins: 0.005 // расстояние между сеткой и стенками экрана
    property double coeffGridSpacing: 0.0005 // растояние между данными в колонках
    property double coeffHColumnSpacing: 0.005 // отступы между колонками
    property double coeffHColumnTimerRectangles: 0.35 // отступы между колонками
    property double coeffHColumnBlindRectangles: 0.635 // отступы между колонками
    property double coeffWColumnMidRectangles: 0.0015 // коэфф от которого зависит ширина ячеек в гриде
    property double coeffHColumnTimerText: 0.72 // коэфф от которого зависит размер текста
    property double coeffHColumnBlindText: 0.2 // коэфф от которого зависит размер текста

    property var timerList: [1, 60, 12]
    property var blindList: ["Blinds:\n3,000 / 6,000\nAnte: 1,000\nNext: 6,000 / 12,000 / 2,000", "Blinds\n6,000 / 12,000\nAnte: 2,000", ""]
    property int currentTimerIndex: -1
    property int countdownSeconds: 0

    Rectangle {
        anchors.fill: parent
        color: "black"

        Timer {
                id: timer
                interval: 1000 // 1 секунда
                running: true
                repeat: true

                onTriggered: {
                    if (countdownSeconds > 0) {
                        countdownSeconds--;
                        updateDisplayTimer();
                    } else {
                        // Переход к следующему таймеру
                        currentTimerIndex++;
                        if (currentTimerIndex < timerList.length) {
                            countdownSeconds = timerList[currentTimerIndex] * 60; // Перевод минут в секунды
                            updateBlind();
                            updateDisplayTimer();
                        } else {
                            timer.stop(); // Остановить таймер, если достигнут конец списка
                        }
                    }
                }
            }

        GridLayout {
            anchors.fill: parent
            anchors.margins: appStart.width * coeffGridMargins
            columns: 3
            rowSpacing: appStart.height * coeffGridSpacing
            columnSpacing: appStart.width * coeffGridSpacing

            // Left Column (Information)
            ColumnLayout {
                Layout.column: 0
                spacing: appStart.height * coeffHColumnSpacing

                Repeater {
                    model: [
                        "Entries:\n 137",
                        "Players In:\n 11",
                        "Chip Count:\n 4,710,000",
                        "Avg. Stack:\n 428,000",
                        "Total Pot:\n 13,150,000"
                    ]
                    Rectangle {
                        color: "green"
                        Layout.fillWidth: true
                        Layout.preferredHeight: appStart.height * coeffHColumnSideRectangles  // Увеличенная высота
                        Layout.preferredWidth: appStart.width * coeffWColumnSideRectangles
                        radius: 5
                        border.color: "white"
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
                spacing: parent.height * coeffHColumnSpacing

                Rectangle {
                    color: "green"
                    Layout.fillWidth: true
                    Layout.preferredHeight: appStart.height * coeffHColumnTimerRectangles  // Увеличенная высота для таймера  0.435
                    Layout.preferredWidth: appStart.width * coeffWColumnMidRectangles  // Увеличенная высота для таймера 0.0015
                    radius: 5
                    border.color: "white"
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
                    border.color: "white"
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
                spacing: parent.height * coeffHColumnSpacing

                Repeater {
                    model: [
                        "Level:\n 18",
                        "Current Time:\n 7:43:29",
                        "Elapsed Time:\n 6:45:00",
                        "Next Break:\n 28:13",
                        "Rebuy price:\n 50 BYN"
                    ]
                    Rectangle {
                        color: "green"
                        Layout.fillWidth: true
                        Layout.preferredHeight: appStart.height * coeffHColumnSideRectangles
                        Layout.preferredWidth: appStart.width * coeffWColumnSideRectangles
                        radius: 5
                        border.color: "white"
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
        }

    function updateBlind() {
        blindText.text = blindList[currentTimerIndex];
    }
}
