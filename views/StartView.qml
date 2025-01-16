import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: mainWindow
    anchors.fill: parent
    color: "green"

    Component {
        id: componentGameView
        Item {
            GameView {
                anchors.fill: parent
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        Button {
            text: "Выбрать игру"
            onClicked: stackView.push(componentGameView)
        }

        Button {
            text: "Создать игру"
            onClicked: console.log("Создать игру")
        }
    }
}
