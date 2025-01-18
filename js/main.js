Qt.include("functions.js");
Qt.include("updateTimers.js");
Qt.include("getServerData.js")

function fetchActiveGamesFromServer(is_start) {
    getActiveGames(is_start)
}

function fetchDataFromServer() {
    getGameInfo()
}

function triggeredBlindsTimer() {
    dataValue.elapsed_seconds++;

    var is_last_level = !(dataValue.current_timer_index < (dataValue.blinds.length - 1));
    if (dataValue.count_down_seconds === 0
            && !is_last_level) {
        dataValue.current_timer_index++;
        if (dataValue.game_is_start
                && dataValue.current_timer_index + 1 != 1) {
            sound.play()
        }
        dataValue.count_down_seconds = dataValue.level_minutes * 60; // Перевод минут в секунды

    }
    dataValue.count_down_seconds--;
    updateTimer(is_last_level);
}

function gamePause() {
    dataValue.game_in_pause = true;
    dataValue.timerText = "PAUSE"
}

function gameUnpause() {
    dataValue.game_in_pause = false;
}

function gameStart() {
    dataValue.game_is_start = true;
}

function gameEnd() {
    dataValue.game_is_start = false;
    dataValue.game_in_pause = false;
    dataValue.game_is_end = true;
    dataValue.timerText = "END"
}
