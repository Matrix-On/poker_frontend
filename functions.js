function fetchDataFromServer(repeaterLeftColumnData, repeaterRightColumnData) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://localhost:8000/game/game_info/1", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                var responseData = JSON.parse(xhr.responseText);
                updateData(repeaterLeftColumnData, repeaterRightColumnData, responseData.data);
            } else {
                console.error("Ошибка: " + xhr.status);
            }
        }
    };
    xhr.send();
}

function updateData(repeaterLeftColumnData, repeaterRightColumnData, data) {
    // Обновите серверные данные
    current_level = data.game.level;
    break_minutes = data.game.break_minutes;
    level_minutes = data.game.level_minutes;
    leftColumnData[0] = "Entries:\n" + formatNumber(data.game.entries);
    leftColumnData[1] = "Players In:\n" + formatNumber(data.game.players_in);
    leftColumnData[2] = "Chip Count:\n" + formatNumber(data.game.total_chips);
    leftColumnData[3] = "Avg. Stack:\n" + formatNumber(data.game.total_chips / data.game.players_in);
    leftColumnData[4] = "Total Pot:\n" + formatNumber(data.game.total_pot) + " BYN";
    rightColumnData[0] = "Level:\n" + current_level;
    rightColumnData[4] = "Rebuy price:\n" + data.game.price_rebuy + " BYN"
    repeaterLeftColumnData.model = leftColumnData;
    repeaterRightColumnData.model = rightColumnData;
}

function formatNumber(number) {
    return number.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
}
