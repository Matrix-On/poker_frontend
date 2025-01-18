Qt.include("functions.js");

function updateTimer(is_last_level) {
    updateBlind(is_last_level);
    updateCurrentTimeData();
    updateElapsedTimeData();
    var break_seconds = updateBreakTimeData(is_last_level);
    updateDisplayTimer(is_last_level);

    //rightColumn.model = dataValue.rightColumn;

    if (break_seconds === 0 && !is_last_level) {
        breakTimer()
    }
}

function updateDisplayTimer(is_last_level) {
    var minutes = 0;
    var seconds = 0;
    if (!is_last_level) {
        minutes = Math.floor(dataValue.count_down_seconds / 60);
        seconds = dataValue.count_down_seconds % 60;
    }
    dataValue.timerText = minutes + " : " + (seconds < 10 ? "0" : "") + seconds;
}

function updateCurrentTimeData() {
    var now = new Date();
    var text = "Current Time:\n" +
            now.getHours().toString().padStart(2, '0') + ":" +
            now.getMinutes().toString().padStart(2, '0') + ":" +
            now.getSeconds().toString().padStart(2, '0');
    dataValue.rightColumn.setProperty(1, "text", text);
}

function updateElapsedTimeData() {
    var hours = Math.floor(dataValue.elapsed_seconds / 360);
    var minutes = Math.floor(dataValue.elapsed_seconds / 60);
    var seconds = dataValue.elapsed_seconds % 60;
    var text = "Elapsed Time:\n" + hours + ":" + (minutes < 10 ? "0" : "")
            +  minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    dataValue.rightColumn.setProperty(2, "text", text);
}

function updateBreakTimeData(is_last_level) {
    var break_seconds = 0;
    if (!is_last_level) {
        break_seconds = Math.floor((dataValue.next_break_after - dataValue.current_level)
            * dataValue.level_minutes * 60
            - (dataValue.level_minutes * 60 - dataValue.count_down_seconds));
    }

    var hours = Math.floor(break_seconds / 360);
    var minutes = Math.floor(break_seconds / 60);
    var seconds = break_seconds % 60;
    var text = "Next Break:\n"+ hours + ":" + (minutes < 10 ? "0" : "")
            + minutes + ":"  + (seconds < 10 ? "0" : "") + seconds;
    dataValue.rightColumn.setProperty(3, "text", text);

    return break_seconds;
}

function breakTimer() {
    dataValue.count_down_seconds = 20 * 60;
    dataValue.next_break_after = dataValue.next_break_after + dataValue.break_after_level;
    updateDisplayTimer(false);
}

function updateBlind(is_last_level) {
    var blinds = dataValue.blinds[dataValue.current_timer_index];
    var current_blinds = "Blinds:\n" + formatNumber(blinds.small_blind)
            + " / " + formatNumber(blinds.big_blind)
            + (blinds.ante > 0 ? (" / " + formatNumber(blinds.ante)) : "");
    var next_blinds = "";

    if (!is_last_level) {
        if (dataValue.game_is_start
                //&& dataValue.current_level != 1
                && dataValue.current_timer_index + 1 != 1
                && dataValue.count_down_seconds === dataValue.level_minutes * 60 - 1) {
            //sound.play()
        }
        blinds = dataValue.blinds[dataValue.current_timer_index + 1];
        next_blinds = "\n--------------------\nNext:\n"
                + formatNumber(blinds.small_blind)
                + " / " + formatNumber(blinds.big_blind)
                + (blinds.ante > 0 ? (" / " + formatNumber(blinds.ante)) : "");
    }

    var result_string = current_blinds + next_blinds;
    dataValue.blindText = result_string;
}
