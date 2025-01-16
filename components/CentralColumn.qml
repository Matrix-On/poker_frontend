import QtQuick 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: centralColumn
    spacing: 0

    property string timerText: ""
    property string blindText: ""

    StandartRectangle {
        text: centralColumn.timerText
        textCoeff: constanstCoeffs.columnTimerText
        heightCoeff: constanstCoeffs.hColumnTimerRectangles
        widthCoeff: constanstCoeffs.wColumnMidRectangles
    }

    StandartRectangle {
        text: centralColumn.blindText
        textCoeff: constanstCoeffs.columnBlindText
        heightCoeff: constanstCoeffs.hColumnBlindRectangles
        widthCoeff: constanstCoeffs.wColumnMidRectangles
    }
}
