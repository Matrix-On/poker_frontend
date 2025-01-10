import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

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
    property double coeffHColumnTimerText: 0.72 // коэфф от которого зависит размер текста
    property double coeffHColumnBlindText: 0.175 // коэфф от которого зависит размер текста

    property var leftColumnData: [
            "Entries:\n 0",
            "Players In:\n 0",
            "Chip Count:\n 0",
            "Avg. Stack:\n 0",
            "Total Pot:\n 0"
        ]

    property var timerList: [1, 60, 12]
    property var blindList: ["Blinds: 3,000 / 6,000 / 1,000\n----------------\nNext: 6,000 / 12,000 / 2,000", "Blinds\n6,000 / 12,000\nAnte: 2,000", ""]
    property int currentTimerIndex: -1
    property int countdownSeconds: 0

    Rectangle {
        anchors.fill: parent
        color: "black"

        Timer {
            id: dataFetchTimer
            interval: 5000 // 5 секунд
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: fetchDataFromServer()
        }

        Timer {
            id: timer
            interval: 1000 // 1 секунда
            running: true
            repeat: true
            triggeredOnStart: true
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
        }

    function updateBlind() {
        blindText.text = blindList[currentTimerIndex];
    }

    function fetchDataFromServer() {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "http://localhost:8000/game/game_info/1", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var responseData = JSON.parse(xhr.responseText);
                    updateData(responseData.data);
                } else {
                    console.error("Ошибка: " + xhr.status);
                }
            }
        };
        xhr.send();
    }

    function updateData(data) {
        // Обновите серверные данные
        leftColumnData[0] = "Entries:\n " + formatNumber(500000);//ormatNumber(data.game.entries);
        leftColumnData[1] = "Players In:\n " + formatNumber(data.game.players_in);
        leftColumnData[2] = "Chip Count:\n " + formatNumber(data.game.total_chips);
        leftColumnData[3] = "Avg. Stack:\n " + formatNumber(data.game.total_chips / data.game.players_in);
        leftColumnData[4] = "Total Pot:\n " + formatNumber(data.game.total_pot) + " BYN";
        repeaterLeftColumnData.model = leftColumnData;
        //repeaterLeftColumnData.update();
    }

    function formatNumber(number) {
        //return number.toLocaleString('en-US');
        return number.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
    }
}
