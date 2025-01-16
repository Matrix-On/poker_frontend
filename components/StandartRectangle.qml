import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: standartRectangle
    color: "green"
    radius: 5
    border.color: "black"
    border.width: 2
    Layout.fillWidth: true
    Layout.preferredHeight: appStart.height * heightCoeff
    Layout.preferredWidth: appStart.width * widthCoeff

    property string text: ""
    property double heightCoeff: 1.0
    property double widthCoeff: 1.0
    property double textCoeff: 1.0

    Text {
        anchors.centerIn: parent
        text: standartRectangle.text
        color: "white"
        font.pixelSize: parent.height * textCoeff
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
