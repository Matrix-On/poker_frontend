Qt.include("functions.js");
Qt.include("updateTimers.js")


function getActiveGames(is_start) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://localhost:8000/game/active_games", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var responseData = JSON.parse(xhr.responseText);
                updateActiveGames(responseData.data, is_start);
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

function getGameInfo() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://localhost:8000/game/game_info/" + dataValue.game_id, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var responseData = JSON.parse(xhr.responseText);
                updateGameInfo(responseData.data);
            } else {
                console.error("Ошибка: " + xhr.status);
            }
        }
    };
    xhr.send();
}

function updateGameInfo(data, is_start) {
    // Обновите серверные данные
    dataValue.current_level = data.game.level;
    dataValue.break_minutes = data.game.break_minutes;
    dataValue.level_minutes = 0.1;//data.game.level_minutes;
    dataValue.break_after_level = data.game.break_after_level;
    dataValue.blinds = data.game.blinds;

    var avg_stack = data.game.total_chips / data.game.players_in;
    if (isNaN(avg_stack))
        avg_stack = 0;

    var text = "Entries:\n" + formatNumber(data.game.entries);
    dataValue.leftColumn.setProperty(0, "text", text);
    text = "Players In:\n" + formatNumber(data.game.players_in);
    dataValue.leftColumn.setProperty(1, "text", text);
    text = "Chip Count:\n" + formatNumber(data.game.total_chips) + "\n(" +
            data.game.total_chips / data.game.blinds[dataValue.current_level - 1].big_blind + " BB)";
    dataValue.leftColumn.setProperty(2, "text", text);
    text = "Avg. Stack:\n" + formatNumber(avg_stack) + "\n(" +
            avg_stack  / data.game.blinds[dataValue.current_level - 1].big_blind + " BB)";
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
    if (is_start) proccessGameOperations();
    updateTimer(dataValue.current_level === (dataValue.blinds.length - 1));
}

function proccessGameOperations() {

    var is_end = false;
    var count_level = 0;
    var id_last_level = -1;
    var id_start_break = -1;
    var id_start_pause = -1;

    for (var i = 0; i < dataValue.operations.length; i++) {
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
            id_last_level = i;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.pause) {
            id_start_pause = i;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.unpause) {
            id_start_pause = -1;
        }
        else if (dataValue.operations[i].operation === enumGameOperations.end) {
            is_end = true;
            break;
        }
    }

    //console.log(id_last_level);
    if (id_last_level > -1) {
        var now = new Date();
        var start_date = new Date(dataValue.operations[0].success_at);
        var last_date = new Date(dataValue.operations[id_last_level].success_at);
        dataValue.elapsed_seconds = Math.floor((now - start_date) / 1000);
        //dataValue.count_down_seconds = Math.floor((now - last_date) / 1000);

    }


    if (is_end) {
        dataValue.game_is_end = true;
        return;
    }
}
