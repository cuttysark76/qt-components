/****************************************************************************
**
** Copyright (C) 2008-2010 Nokia Corporation and/or its subsidiary(-ies).
** Contact: Qt Software Information (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Trolltech Labs.
**
** This file may be used under the terms of the GNU General Public
** License version 2.0 or 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of
** this file.  Please review the following information to ensure GNU
** General Public Licensing requirements will be met:
** http://www.fsf.org/licensing/licenses/info/GPLv2.html and
** http://www.gnu.org/copyleft/gpl.html.
**
** If you are unsure which license is appropriate for your use, please
** contact the sales department at qt-sales@nokia.com.
**
** This file is provided AS IS with NO WARRANTY OF ANY KIND, INCLUDING THE
** WARRANTY OF DESIGN, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
**
****************************************************************************/

#include <QtTest/QtTest>
#include "qbuttonmodel.h"

class tst_QButtonModel : public QObject
{
    Q_OBJECT

public:
    tst_QButtonModel();
    virtual ~tst_QButtonModel();
    
public slots:
    void initTestCase();
    void cleanupTestCase();
    void init();
    void cleanup();

private slots:
    void getSetCheck();

protected:
    QButtonModel *model;
};

tst_QButtonModel::tst_QButtonModel()
{
}

tst_QButtonModel::~tst_QButtonModel()
{
}

void tst_QButtonModel::initTestCase()
{
}

void tst_QButtonModel::cleanupTestCase()
{
}

void tst_QButtonModel::init()
{
    model = new QButtonModel();
}

void tst_QButtonModel::cleanup()
{
    delete model;
}

void tst_QButtonModel::getSetCheck()
{
    // check initial state
    QCOMPARE(model->isCheckable(), false);
    QCOMPARE(model->isChecked(), false);
    QCOMPARE(model->autoRepeat(), false);
    QCOMPARE(model->autoExclusive(), false);
    QCOMPARE(model->autoRepeatDelay(), 300);
    QCOMPARE(model->autoRepeatInterval(), 100);
    QCOMPARE(model->isDown(), false);
    QCOMPARE(model->isHighlighted(), false);
    QCOMPARE(model->isPressed(), false);

    // checkable
    model->setCheckable(true);
    QCOMPARE(model->isCheckable(), true);
    model->setCheckable(false);
    QCOMPARE(model->isCheckable(), false);

    // checked
    model->setChecked(true);
    QCOMPARE(model->isChecked(), false);

    model->setCheckable(true);
    QCOMPARE(model->isChecked(), false);

    model->setChecked(true);
    QCOMPARE(model->isChecked(), true);
    model->setChecked(false);
    QCOMPARE(model->isChecked(), false);

    model->setCheckable(false);

    // autoRepeat
    model->setAutoRepeat(true);
    QCOMPARE(model->autoRepeat(), true);
    model->setAutoRepeat(false);
    QCOMPARE(model->autoRepeat(), false);

    // autoExclusive
    model->setAutoExclusive(true);
    QCOMPARE(model->autoExclusive(), true);
    model->setAutoExclusive(false);
    QCOMPARE(model->autoExclusive(), false);

    // autoRepeatDelay
    model->setAutoRepeatDelay(200);
    QCOMPARE(model->autoRepeatDelay(), 200);
    model->setAutoRepeatDelay(300);
    QCOMPARE(model->autoRepeatDelay(), 300);

    // autoRepeatInterval
    model->setAutoRepeatInterval(200);
    QCOMPARE(model->autoRepeatInterval(), 200);
    model->setAutoRepeatInterval(100);
    QCOMPARE(model->autoRepeatInterval(), 100);

    // down
    model->setDown(true);
    QCOMPARE(model->isDown(), true);
    model->setDown(false);
    QCOMPARE(model->isDown(), false);

    // highlight
    model->setHighlighted(true);
    QCOMPARE(model->isHighlighted(), true);
    model->setHighlighted(false);
    QCOMPARE(model->isHighlighted(), false);

    // pressed
    model->setPressed(true);
    QCOMPARE(model->isPressed(), true);
    model->setPressed(false);
    QCOMPARE(model->isPressed(), false);
}

QTEST_MAIN(tst_QButtonModel)
#include "tst_qbuttonmodel.moc"
