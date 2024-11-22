// GroundEffects.qml
import QtQuick 2.15

Item {
    id: groundEffects
    anchors.fill: parent

    Rectangle {
        id: ground1Sunny
        opacity: 1
    }

    Rectangle {
        id: ground1Frosty
        opacity: 0
    }

    Rectangle {
        id: ground1Night
        opacity: 0
    }

    Rectangle {
        id: ground2SunnyRight
        opacity: 1
    }

    Rectangle {
        id: ground2FrostyRight
        opacity: 0
    }

    Rectangle {
        id: ground2NightRight
        opacity: 0
    }

    function updateGround(state) {
        ground1Sunny.opacity = state === 0 ? 1 : 0
        ground1Frosty.opacity = state === 1 ? 1 : 0
        ground1Night.opacity = state === 2 ? 1 : 0

        ground2SunnyRight.opacity = state === 0 ? 1 : 0
        ground2FrostyRight.opacity = state === 1 ? 1 : 0
        ground2NightRight.opacity = state === 2 ? 1 : 0
    }
}
