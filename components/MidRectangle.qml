import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: midRectangle
    color: "green"
    radius: 5
    border.color: "black"
    border.width: 2
    Layout.fillWidth: true
    Layout.preferredHeight: appStart.height * heightCoeff
    Layout.preferredWidth: appStart.width * widthCoeff

    property string text: ""
    property double heightCoeff: 0.3
    property double widthCoeff: 0.3
    property double textCoeff: 0.3

    Text {
        anchors.centerIn: parent
        text: midRectangle.text
        color: "white"
        font.pixelSize: parent.height * textCoeff
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
