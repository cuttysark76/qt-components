/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import Qt 4.7
import com.nokia.symbian 1.0
import com.nokia.symbian.themebridge 1.0

Item {
    id: root
    anchors.fill: parent

    Column {
        anchors.fill: parent

        ListView {
            id: listView
            height: parent.height - statusBar.height
            width: parent.width
            focus: true
            clip: true
            model: ListModel { id: model }
            delegate: defaultDelegate
            Component.onCompleted: {
                 initializeDefault() // Initial fill of the model
                 listView.forceActiveFocus()
             }
            ScrollBar {
                flickableItem: listView
                anchors { top: listView.top; right: listView.right }
            }
        }
        Rectangle {
            id: statusBar
            height: 40
            width: parent.width
            color: "darkgray"
            border.color: "gray"

            Text {
                font { bold: true; pixelSize: 16 }
                color: "white"
                anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                text: "Current item: " + listView.currentIndex
            }

            Button {
                text: "Menu"
                width: 100
                anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
                onClicked: viewMenu.open()
            }
        }
    }

    ObjectMenu {
           id: objectmenu
           actions: ["Set disabled", "Add item", "Delete item"]
           onTriggered: {
               switch (index) {
                   case 0: {
                       // Switch state
                       listView.model.set(listView.currentIndex, {"disabled": true})
                       break
                   }
                   case 1: {
                       createItemDialog.open()
                       break
                   }
                   case 2: {
                       if (listView.currentIndex >= 0)
                           listView.model.remove(listView.currentIndex)
                       break
                   }
                   default:
                       break
               }
           }
       }

    ViewMenu {
        id: viewMenu
        actions: ["Show/Hide List header",
            "Show/Hide Sections",
            "Back"]
        onTriggered: {
            switch (index) {
                case 0: {
                    listView.header = (listView.header) ? null : listHeader
                    break
                }
                case 1: {
                    // Models field to group by
                    listView.section.property = "image"
                    // Delegate for section heading
                    listView.section.delegate = listView.section.delegate ? null : sectionDelegate
                    break
                }
                case 2: {
                    pageStack.pop()
                    break
                }
               default:
                   break
            }
        }
    }

    Dialog {
        id: notificationDialog
        property string notificationText: ""
        title: Text {
            text: "Item clicked"
            font { bold: true; pixelSize: 16 }
            color: "white"
            anchors.fill: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        buttons: Button {
            text: "Ok"
            width: parent.width
            height: 50
            onClicked: notificationDialog.accept()
        }
        content: Text {
            text: notificationDialog.notificationText
            font { bold: true; pixelSize: 16 }
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Dialog {
        id: createItemDialog
        title: Text {
            text: "Create new list item"
            font { bold: true; pixelSize: 16 }
            color: "white"
            anchors.fill: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
        buttons: Row {
            height: 60
            width: parent.width

            Button {
                text: "Ok"
                width: parent.width / 2
                height: parent.height
                onClicked: createItemDialog.accept()
            }

            Button {
                text: "Cancel"
                width: parent.width / 2
                height: parent.height
                onClicked: createItemDialog.reject()
            }
        }
        content: Column {
            anchors.fill: parent

            Text {
                text: "Enter title"
            }

            TextField {
                id: titleField
                text: "New item - Title"
                width: parent.width
            }

            Text {
                text: "Enter subtitle"
            }

            TextField {
                id: subTitleField
                text: "New item - SubTitle"
                width: parent.width
            }

            Text {
                text: "Select image size"
            }

            ChoiceList {
                id: imageSizeChoiceList
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - parent.spacing
                currentIndex: 0
                model: ["Undefined", "Small", "Medium", "Large", "ImagePortrait"]
            }
        }
        onAccepted: {
            listView.model.insert(listView.currentIndex + 1, {
                "title": titleField.text,
                "subTitle": subTitleField.text,
                "imageSize": imageSizeChoiceList.currentIndex,
                "image": imageSizeChoiceList.currentIndex > 0 ? "image://theme/:/list1.png" : "",
                "disabled": false,
                "selected": false,
                "sectionIdentifier": 0} )
        }
    }

    function initializeDefault() {
        listView.header = listHeader
        listView.section.property = "image" // Models field to group by
        listView.section.delegate = sectionDelegate // Delegate for section headings
        for (var i = 0; i < 4; i++) {
            for (var j = 0; j < 5; j++) {
                listView.model.append( {
                    "title": "Title text - " + (5*i + j),
                    "subTitle": "SubTitle " + (5*i + j),
                    "imageSize": j,
                    "image": "image://theme/:/list" + (i + 1) + ".png",
                    "disabled": false,
                    "selected": false,
                    "sectionIdentifier": 0
                } )
            }
        }
    }

    Component {
        id: defaultDelegate

        ListItem {
            id: listItem1
            objectName: title
            width: listView.width
            enabled: !disabled // State from model

            Row {
                anchors.fill: listItem1.padding
                spacing: listItem1.horizontalSpacing

                Image {
                    sourceSize.height: listItem1.preferredImageHeight(imageSize)
                    sourceSize.width: listItem1.preferredImageWidth(imageSize)
                    source: imageSize == Symbian.Undefined ? "" : image
                }

                Column {
                    spacing: listItem1.verticalSpacing

                    ListItemText {
                        style: listItem1.style
                        role: "Title"
                        text: title // Title from model
                    }

                    ListItemText {
                        style: listItem1.style
                        role: "SubTitle"
                        text: subTitle // SubTitle from model
                    }
                }
            }
            onClicked: {
                notificationDialog.notificationText = "Activated item: " + title
                notificationDialog.open()
            }
            onPressAndHold: objectmenu.open()
        }
    }

    Component {
        id: listHeader

        ListHeading {
            id: listHeader
            width: listView.width

            ListItemText {
                id: txtHeading
                anchors.fill: listHeader.padding
                style: listHeader.style
                role: "Heading"
                text: "Test list"
            }
        }
    }

    Component {
        id: sectionDelegate

        ListHeading {
            width: listView.width
            id: sectionHeader

            ListItemText {
                id: txtHeading
                anchors.fill: sectionHeader.padding
                style: sectionHeader.style
                role: "Heading"
                text: "Section separator"
            }
        }
    }
}
