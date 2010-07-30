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

#include <QtDeclarative>
#include <QScopedPointer>

#include "mcomponentdata.h"
#include "mdeclarativescalableimage.h"
#include "mdeclarativebackground.h"
#include "mdeclarativepixmap.h"
#include "mdeclarativeicon.h"
#include "mstylewrapper.h"

class MeegoTouchPlugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT
public:
    void initializeEngine(QDeclarativeEngine *engine, const char *uri) {
        QDeclarativeExtensionPlugin::initializeEngine(engine, uri);

        if (!MComponentData::instance()) {
            // This is a workaround because we can't use a default
            // constructor for MComponentData
            int argc = 1;
            char *argv0 = "meegotouch";
            componentData.reset(new MComponentData(argc, &argv0));
        }
    }

    void registerTypes(const char *uri) {
//        Q_ASSERT(uri == QLatin1String("MeegoTouch"));
        // Custom primitives
        qmlRegisterType<MDeclarativeScalableImage>(uri, 1, 0, "ScalableImage");
        qmlRegisterType<MDeclarativePixmap>(uri, 1, 0, "Pixmap");
        qmlRegisterType<MDeclarativeBackground>(uri, 1, 0, "Background");
        qmlRegisterType<MDeclarativeIcon>(uri, 1, 0, "Icon");

        // Theme info
        qmlRegisterType<MStyleWrapper>(uri, 1, 0, "Style");
    }

private:
    QScopedPointer<MComponentData> componentData;
};

#include "plugin.moc"

Q_EXPORT_PLUGIN2(meegotouchplugin, MeegoTouchPlugin);
