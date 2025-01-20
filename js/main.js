Qt.include("functions.js");
Qt.include("updateTimers.js");
Qt.include("getServerData.js")

function fetchActiveGamesFromServer() {
    getActiveGames()
}

function fetchDataFromServer(is_start) {
    getGameInfo(is_start)
}

function triggeredBlindsTimer() {
    dataValue.elapsed_seconds++;

    var is_last_level = !(dataValue.current_level < dataValue.blinds.length);
    if (dataValue.count_down_seconds === 0
            && !is_last_level) {
        dataValue.current_level++;
        if (dataValue.game_is_start
                && dataValue.current_level + 1 != 1) {
            sound.play()
        }
        dataValue.count_down_seconds = (dataValue.players_in_game > 2 ? dataValue.level_minutes : dataValue.level_minutes / 2) * 60; // Перевод минут в секунды
        if (dataValue.game_in_break) {
            dataValue.game_in_break = false;
            sendGameOperation(7);
        }
        sendGameOperation(5);
    }
    dataValue.count_down_seconds--;
    updateTimer(is_last_level);
}

function gamePause() {
    dataValue.game_in_pause = true;
    dataValue.timerText = "PAUSE"
    sendGameOperation(3);
}

function gameUnpause() {
    dataValue.game_in_pause = false;
    sendGameOperation(4);
}

function gameStart() {
    dataValue.game_is_start = true;
    dataValue.current_level = 1;
    sendGameOperation(1);
}

function gameEnd() {
    dataValue.game_is_start = false;
    dataValue.game_in_pause = false;
    dataValue.game_in_break = false;
    dataValue.game_is_end = true;
    dataValue.timerText = "END"
    sendGameOperation(2);
}
