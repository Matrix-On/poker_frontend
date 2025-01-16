import QtQuick 2.15
import QtQuick.Controls 2.15


MenuBar {
    id: menuBar
    Menu {
        title: "Файл"
        MenuItem {
            text: "Открыть"
            onTriggered: console.log("Вы выбрали Открыть")
        }
        MenuItem {
            text: "Сохранить"
            onTriggered: console.log("Вы выбрали Сохранить")
        }
        MenuSeparator {}
        MenuItem {
            text: "Выход"
            onTriggered: Qt.quit()
        }
    }

    Menu {
        title: "Правка"
        MenuItem {
            text: "Отменить"
            onTriggered: console.log("Вы выбрали Отменить")
        }
        MenuItem {
            text: "Повторить"
            onTriggered: console.log("Вы выбрали Повторить")
        }
    }

    Menu {
        title: "Справка"
        MenuItem {
            text: "О программе"
            onTriggered: console.log("Вы выбрали О программе")
        }
    }
}
