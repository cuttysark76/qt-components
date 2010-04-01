/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the FOO module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL-ONLY$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
** $QT_END_LICENSE$
**
****************************************************************************/
import Qt 4.7

Item {
    id: root;

    property alias contentX: container.x;
    property alias contentY: container.y;
    property alias contentWidth: container.width;
    property alias contentHeight: container.height;
    default property alias data: container.data;

    width: 50;
    height: 50;

    Item {
        id: clipper;
        clip: true;

        anchors.top: parent.top;
        anchors.bottom: bottomSlider.top;
        anchors.left: parent.left;
        anchors.right: rightSlider.left;

        Item {
            id: container;

            function fitsCompletely()
            {
                // Are scrollbars needed at all?
                //
                // This method avoids the chicken-and-egg problem that happens
                // due to the fact that adding scrollbars effectively reduce
                // the viewable area.
                // Thus we check whether we could live without bars at all and
                // then, in a second step, we check whether we need horizontal
                // and/or vertical bars.
                return (width <= root.width) && (height <= root.height);
            }
        }
    }

    ScrollBar {
        id: rightSlider;

        anchors.left: parent.right;
        anchors.top: parent.top;
        anchors.bottom: bottomSlider.top;
        visible: false;
        vertical: true;
        documentSize: contentHeight;
        viewSize: root.height;

        states: [
            State {
                name: "shown";
                when: !container.fitsCompletely() && (container.height > clipper.height);
                PropertyChanges {
                    target: container;
                    y: -rightSlider.value * (container.height - clipper.height);
                }
                PropertyChanges {
                    target: rightSlider;
                    anchors.leftMargin: -rightSlider.width;
                    visible: true;
                }
            }
        ]
    }

    ScrollBar {
        id: bottomSlider;

        anchors.top: parent.bottom;
        anchors.left: parent.left;
        anchors.right: rightSlider.left;
        visible: false;
        documentSize: contentWidth;
        viewSize: root.width;

        states: [
            State {
                name: "shown";
                when: !container.fitsCompletely() && (container.width > clipper.width);
                PropertyChanges {
                    target: container;
                    x: -bottomSlider.value * (container.width - clipper.width);
                }
                PropertyChanges {
                    target: bottomSlider;
                    anchors.topMargin: -bottomSlider.height;
                    visible: true;
                }
            }
        ]
    }
}
