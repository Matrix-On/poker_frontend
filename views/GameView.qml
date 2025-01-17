import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtMultimedia

import "../js/main.js" as Functions
import "../js/getServerData.js" as GetServerDataJS
import "../components"

Rectangle {
    id: gameView
    anchors.fill: parent
    color: "black"


    MediaPlayer {
        id: sound
        source: "file:/Users/artemsamujlik/Development/poker_tournament_view/sound/blind.mp3"//"qrc:/sound/blind.mp3"
        audioOutput: AudioOutput {
            volume: 1.0 // Убедитесь, что громкость не равна
            onDeviceChanged: console.log("Audio device: " + device.name)
        }
        onErrorChanged: console.log("Error: " + errorString)
        //onStatusChanged: console.log("Status: " + status)
    }



    Timer {
        id: dataFetchTimer
        interval: 5000 // 5 секунд
        repeat: dataValue.game_is_start
        running: dataValue.game_is_start
        triggeredOnStart: dataValue.game_is_start
        onTriggered: {Functions.fetchDataFromServer(false);
            GetServerDataJS.proccessGameOperations();
        }
    }

    Timer {
        id: mainTimer
        interval: 1000 // 1 секунда
        running: (dataValue.game_is_start && !dataValue.game_in_pause)
        repeat: (dataValue.game_is_start && !dataValue.game_in_pause)
        triggeredOnStart: (dataValue.game_is_start && !dataValue.game_in_pause)
        onTriggered: Functions.triggeredBlindsTimer()
    }

    RowLayout {
        id: topRow
        anchors.top: parent.top
        Layout.fillWidth: true
        property string title: ""

        StandartRectangle {
            text: dataValue.headerText
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
            id: leftInfoColumn
            Layout.column: 0
            model: dataValue.leftColumn
        }

        // Center Column (Timer and Blinds)
        CentralColumn {
            id: centralColumn
            Layout.column: 1
            blindText: dataValue.blindText
            timerText: dataValue.timerText
        }

        // Right Column (Additional Information)
        InfoColumn {
            id: rightInfoColumn
            Layout.column: 2
            model: dataValue.rightColumn
        }
    }


}
