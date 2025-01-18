import QtQuick 2.15
import Qt.labs.platform

import "../js/main.js" as GameFunctions
import "../js/updateTimers.js" as TimerFunctions

Item {
    property bool in_game: false
    property bool in_pause: false
    property bool game_started: false

    MenuBar {
        id: mainMenu
        Menu {
            title: "&Основные"
            MenuItem {
                text: "Подключиться к игре"
                enabled: !in_game
                onTriggered: {
                    GameFunctions.fetchActiveGamesFromServer(true);
                    chooseGame.open();
                }
            }
            MenuItem {
                text: "Начать новую игру"
                enabled: false
                onTriggered: console.log("Вы выбрали Начать новую игру")
            }
        }

        Menu {
            title: "&Игра"
            enabled: in_game
            MenuItem {
                text: !game_started ? "Начать игру" : "Закончить игру"
                onTriggered: {
                    if (game_started) GameFunctions.gameEnd()
                    else GameFunctions.gameStart()
                }
            }
            MenuItem {
                text: !in_pause ? "Поставить паузу" : "Снять паузу"
                onTriggered: {
                    if (in_pause) GameFunctions.gameUnpause()
                    else GameFunctions.gamePause()
                }
            }
        }
    }
}
