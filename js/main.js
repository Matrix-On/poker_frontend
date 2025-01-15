Qt.include("functions.js");
Qt.include("updateTimers.js");
Qt.include("getServerData.js")

function fetchDataFromServer(repeaterLeftColumnData, repeaterRightColumnData) {
    getGameInfo(repeaterLeftColumnData, repeaterRightColumnData)
}

function triggeredBlindsTimer() {
    dataValue.elapsed_seconds++;

    var is_last_level = !(dataValue.current_timer_index < (dataValue.blinds.length - 1));
    if (dataValue.count_down_seconds === 0
            && !is_last_level) {
        dataValue.current_timer_index++;
        dataValue.count_down_seconds = dataValue.level_minutes * 60; // Перевод минут в секунды

    }
    dataValue.count_down_seconds--;
    updateTimer(is_last_level);
}
