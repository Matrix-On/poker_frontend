Qt.include("functions.js");

function getGameInfo() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://localhost:8000/game/game_info/1", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var responseData = JSON.parse(xhr.responseText);
                updateData(responseData.data);
            } else {
                console.error("Ошибка: " + xhr.status);
            }
        }
    };
    xhr.send();
}

function updateData(data) {
    // Обновите серверные данные
    dataValue.current_level = data.game.level + 1;
    dataValue.break_minutes = data.game.break_minutes;
    dataValue.level_minutes = 0.1;//data.game.level_minutes;
    dataValue.break_after_level = data.game.break_after_level;
    dataValue.blinds = data.game.blinds;

    dataValue.leftColumn[0] = "Entries:\n" + formatNumber(data.game.entries);
    dataValue.leftColumn[1] = "Players In:\n" + formatNumber(data.game.players_in);
    dataValue.leftColumn[2] = "Chip Count:\n" + formatNumber(data.game.total_chips) + "\n(" +
            data.game.total_chips / data.game.blinds[dataValue.current_level - 1].big_blind + " BB)";
    var avg_stack = data.game.total_chips / data.game.players_in;
    dataValue.leftColumn[3] = "Avg. Stack:\n" + formatNumber(avg_stack) + "\n(" +
            avg_stack  / data.game.blinds[dataValue.current_level - 1].big_blind + " BB)";
    dataValue.leftColumn[4] = "Total Pot:\n" + formatNumber(data.game.total_pot) + " " + data.game.currency.toUpperCase();
    dataValue.rightColumn[0] = "Level:\n" + dataValue.current_level;
    dataValue.rightColumn[4] = "Rebuy price:\n" + data.game.price_rebuy + " " + data.game.currency.toUpperCase();
    leftColumn.model = dataValue.leftColumn;
    rightColumn.model = dataValue.rightColumn;
}
