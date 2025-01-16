import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: headerRectangle
    color: "green"
    radius: 5
    border.color: "black"
    border.width: 2
    Layout.fillWidth: true
    Layout.preferredHeight: appStart.height * constanstCoeffs.rowNameText//heightCoeff
    Layout.preferredWidth: appStart.width

    property string title: ""

    Text {
        id: headerText
        anchors.centerIn: parent
        text: headerRectangle.title
        color: "white"
        font.pixelSize: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
    }
}
