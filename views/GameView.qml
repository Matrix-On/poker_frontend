import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../js/main.js" as Functions
import "../components"

Rectangle {
    anchors.fill: parent
    color: "black"

    Timer {
        id: dataFetchTimer
        interval: 5000 // 5 секунд
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: Functions.fetchDataFromServer()
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
        anchors.top: parent.top
        Layout.fillWidth: true
        spacing: 0 //appStart.width * 0.01

        StandartRectangle {
            text: "#1 Scam-main 5000 re-entry 50"
            heightCoeff: constanstCoeffs.rowNameText
        }
    }


    GridLayout {
        anchors.top: topRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        columns: 3


        // Left Column (Information)
        InfoColumn {
            id: leftColumn
            Layout.column: 0
            model: dataValue.leftColumn
        }

        // Center Column (Timer and Blinds)
        CentralColumn {
            id: centralColumn
            Layout.column: 1
            blindText: "blind"
            timerText: "timer"
        }

        // Right Column (Additional Information)
        InfoColumn {
            id: rightColumn
            Layout.column: 2
            model: dataValue.leftColumn
        }
    }
}
