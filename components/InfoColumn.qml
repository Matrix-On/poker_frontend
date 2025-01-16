import QtQuick 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: infoColumn
    spacing: 0

    property var model: []
    property real heightCoeff: 0.19

    Repeater {
        model: infoColumn.model
        StandartRectangle {
            text: modelData
            textCoeff: constanstCoeffs.columnSideText
            heightCoeff: constanstCoeffs.hColumnSideRectangles
            widthCoeff: constanstCoeffs.wColumnSideRectangles
        }
    }
}
