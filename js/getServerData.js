Qt.include("functions.js");
Qt.include("updateTimers.js")


function getActiveGames() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://localhost:8000/game/active_games", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var responseData = JSON.parse(xhr.responseText);
                updateActiveGames(responseData.data);
            } else {
                console.error("Ошибка: " + xhr.status);
            }
        }
    };
    xhr.send();
}

function updateActiveGames(data) {
    for (var i = 0; i < data.length; i++) {
        var title = "#" + data[i].id + " " + data[i].name + " " + data[i].chip_count
                + " re-entry " + data[i].price_rebuy + " " + data[i].currency.toUpperCase();
        dataValue.gamesModel.append({ name: title, game_id: data[i].id  })
    }
}

function getGameInfo(is_start) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://localhost:8000/game/game_info/" + dataValue.game_id, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var responseData = JSON.parse(xhr.responseText);
                updateGameInfo(responseData.data, is_start);
            } else {
                console.error("Ошибка: " + xhr.status);
            }
        }
    };
    xhr.send();
}

function sendGameOperation(operation) {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "http://localhost:8000/game/game_operation/", true);
    xhr.setRequestHeader("Content-Type", "application/json");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status != 200) {
                console.error("Ошибка: " + xhr.status);
            }
        }
    };
    var now = new Date();
    var time = now.getFullYear().toString() + "-" +
            (now.getMonth() + 1).toString().padStart(2, '0') + "-" +
            now.getDate().toString().padStart(2, '0') + "T" +
            now.getHours().toString().padStart(2, '0') + ":" +
            now.getMinutes().toString().padStart(2, '0') + ":" +
            now.getSeconds().toString().padStart(2, '0') + "." +
            now.getMilliseconds().toString().padStart(3, '0') + "Z";
    var data = {
      "game_id": dataValue.game_id,
      "operation": operation,
      "success_at": time
    }

    // Преобразуем объект данных в строку JSON
    xhr.send(JSON.stringify(data));
}

function updateGameInfo(data, is_start) {
    // Обновите серверные данные
    dataValue.current_level = data.game.level;
    dataValue.break_minutes = data.game.break_minutes;
    dataValue.level_minutes = data.game.level_minutes;
    dataValue.break_after_level = data.game.break_after_level;
    dataValue.blinds = data.game.blinds;
    dataValue.players_in_game = data.game.players_in;

    var avg_stack = data.game.total_chips / data.game.players_in;
    if (isNaN(avg_stack))
        avg_stack = 0;

    var big_blind = 0
    if (dataValue.current_level > 0) big_blind = data.game.blinds[dataValue.current_level - 1].big_blind;

    var text = "Entries:\n" + formatNumber(data.game.entries);
    dataValue.leftColumn.setProperty(0, "text", text);
    text = "Players In:\n" + formatNumber(dataValue.players_in_game);
    dataValue.leftColumn.setProperty(1, "text", text);
    text = "Chip Count:\n" + formatNumber(data.game.total_chips) + "\n(" +
            (data.game.total_chips / big_blind).toFixed(2) + " BB)";
    dataValue.leftColumn.setProperty(2, "text", text);
    text = "Avg. Stack:\n" + formatNumber(avg_stack) + "\n(" +
            (avg_stack  / big_blind).toFixed(2) + " BB)";
    dataValue.leftColumn.setProperty(3, "text", text);
    text = "Total Pot:\n" + formatNumber(data.game.total_pot) + " " + data.game.currency.toUpperCase();
    dataValue.leftColumn.setProperty(4, "text", text);

    text = "Level:\n" + dataValue.current_level;
    dataValue.rightColumn.setProperty(0, "text", text);
    text = "Rebuy price:\n" + data.game.price_rebuy + " " + data.game.currency.toUpperCase();
    dataValue.rightColumn.setProperty(4, "text", text);

    dataValue.operations = data.operations;

    dataValue.headerText = "#" + data.game.id + " " + data.game.name + " " + data.game.chip_count
            + " re-entry " + data.game.price_rebuy + " " + data.game.currency.toUpperCase();
    if (is_start === true) proccessGameOperations();
    updateTimer(!(dataValue.current_level < dataValue.blinds.length));
}

function proccessGameOperations() {

    var is_end = false;
    var count_level = 0;
    var id_last_level = -1;
    var id_start_break = -1;
    var id_start_pause = -1;
    var seconds_in_pause = 0;

    for (var i = 0; i < dataValue.operations.length; i++) {
        console.log(dataValue.operations[i].operation)
        if (dataValue.operations[i].operation === enumGameOperations.start
            || dataValue.operations[i].operation === enumGameOperations.next_level) {
            ++count_level;
            id_last_level = i;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.time_break) {
            id_start_break = i;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.end_time_break) {
            id_start_break = -1;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.pause) {
            id_start_pause = i;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.unpause) {
            if (i > id_last_level) {
                var date_start_pause = new Date(dataValue.operations[id_start_pause].success_at);
                var date_end_pause = new Date(dataValue.operations[i].success_at);
                seconds_in_pause +=  Math.floor((date_end_pause - date_start_pause) / 1000);
            }
            id_start_pause = -1;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.end) {
            is_end = true;
            break;
        }
    }

    dataValue.next_break_after = dataValue.break_after_level * (Math.floor(dataValue.current_level / dataValue.break_after_level) + 1);
    console.log("Next break after:", dataValue.next_break_after);

    dataValue.game_is_start = id_last_level > -1;
    if (!dataValue.game_is_start) dataValue.count_down_seconds = dataValue.level_minutes * 60;
    dataValue.game_in_pause = id_start_pause > -1;
    dataValue.game_in_break = id_start_break > -1;

    var now = new Date();
    if (id_start_pause > -1) {
        var date_in_pause = new Date(dataValue.operations[id_start_pause].success_at);
        seconds_in_pause =  Math.floor((now - date_in_pause) / 1000);
    }

    if (dataValue.game_in_break) {
        var date_start_timebreak = new Date(dataValue.operations[id_start_break].success_at);
        dataValue.count_down_seconds = (dataValue.break_minutes * 60) - Math.floor((now - date_start_timebreak) / 1000) + seconds_in_pause;
    }

    console.log("Seconds in pause: ", seconds_in_pause);
    if (id_last_level > -1) {
        var start_date = new Date(dataValue.operations[0].success_at);
        var last_date = new Date(dataValue.operations[id_last_level].success_at);
        dataValue.elapsed_seconds = Math.floor((now - start_date) / 1000);
        if (dataValue.count_down_seconds <= 0) dataValue.count_down_seconds = (dataValue.level_minutes * 60) - Math.floor((now - last_date) / 1000) + seconds_in_pause;
    }


    if (is_end) {
        dataValue.game_is_end = true;
        dataValue.game_is_start = false;
        dataValue.game_in_pause = false;
        dataValue.game_in_break = false;
        return;
    }
}
