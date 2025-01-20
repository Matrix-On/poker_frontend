import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../components"
import "../js/main.js" as GameFunctions
import "../js/updateTimers.js" as TimerFunctions

Dialog {
    id: chooseGame
    title: "Выбор игры"
    modal: true
    anchors.centerIn: parent
    width: appStart.width / 2
    height: appStart.height / 2
    closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape

    background: Rectangle {
        anchors.fill: parent
        color: "mediumseagreen"
        border.color: "#404040"
        border.width: 5
        radius: 15
    }

    header: Label {
        text: "Выбор игры"
        font.pixelSize: 18
        leftPadding: 20
        topPadding: 10
        color: "white"
        background: Rectangle {
            anchors.fill: parent
            color: "#404040"
            border.color: "#404040"
            border.width: 4
            radius: 15
        }
    }

    property ListModel model:  ListModel {
    }

    Column {
        anchors.centerIn: parent // Центрирование содержимого
        spacing: 10
        padding: 20

        Rectangle {
               width: chooseGame.width * 0.9
               height: 150
               color: "white" // Цвет фона
               radius: 10 // Радиус скруглений
               border.color: "black" // Цвет границы
               border.width: 2 // Толщина границы
        ListView {
            id: gameListView
            width: chooseGame.width * 0.9
            height: 150
            clip: true // Обрезаем лишнее содержимое
            model: chooseGame.model
            delegate: Item {
                width: gameListView.width
                height: 40
                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: ListView.isCurrentItem ? "lightblue" : "white"
                    border.color: "black"
                    radius: 5

                    Text {
                        text: model.name
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            dataValue.game_id = model.game_id // Присваиваем game_id
                            GameFunctions.fetchDataFromServer(true);
                            chooseGame.close() // Закрыть модальное окно
                        }

                        onEntered: {
                            parent.color = "lightgray" // Изменение цвета при наведении
                        }
                        onExited: {
                            parent.color = ListView.isCurrentItem ? "lightblue" : "white"
                        }
                    }
                }
            }
        }
        }


        Button {
            id: button
            text: "Закрыть"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 18 // Увеличенный размер текста кнопки
            width: 150
            height: 50
            onClicked: chooseGame.close() // Закрыть диалог без выбора
        }
    }
}
