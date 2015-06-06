/****************************************************************************
**
** http://www.qxorm.com/
** Copyright (C) 2013 Lionel Marty (contact@qxorm.com)
**
** This file is part of the QxOrm library
**
** This software is provided 'as-is', without any express or implied
** warranty. In no event will the authors be held liable for any
** damages arising from the use of this software
**
** Commercial Usage
** Licensees holding valid commercial QxOrm licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Lionel Marty
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file 'license.gpl3.txt' included in the
** packaging of this file. Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met : http://www.gnu.org/copyleft/gpl.html
**
** If you are unsure which license is appropriate for your use, or
** if you have questions regarding the use of this file, please contact :
** contact@qxorm.com
**
****************************************************************************/

#ifndef _QX_SERIALIZE_QWEAKPOINTER_H_
#define _QX_SERIALIZE_QWEAKPOINTER_H_

#ifdef _MSC_VER
#pragma once
#endif

#include <boost/serialization/serialization.hpp>
#include <boost/serialization/split_free.hpp>
#include <boost/serialization/version.hpp>
#include <boost/serialization/nvp.hpp>

#include <QtCore/QWeakPointer>

#include <QxSerialize/Qt/QxSerialize_QSharedPointer.h>

namespace boost {
namespace serialization {

template <class Archive, typename T>
inline void save(Archive & ar, const QWeakPointer<T> & t, const unsigned int file_version)
{
   Q_UNUSED(file_version);
   QSharedPointer<T> ptr = t.toStrongRef();
   ar << boost::serialization::make_nvp("qt_weak_ptr", ptr);
}

template <class Archive, typename T>
inline void load(Archive & ar, QWeakPointer<T> & t, const unsigned int file_version)
{
   Q_UNUSED(file_version);
   QSharedPointer<T> ptr;
   ar >> boost::serialization::make_nvp("qt_weak_ptr", ptr);
   t = QWeakPointer<T>(ptr);
}

template <class Archive, typename T>
inline void serialize(Archive & ar, QWeakPointer<T> & t, const unsigned int file_version)
{
   boost::serialization::split_free(ar, t, file_version);
}

} // namespace boost
} // namespace serialization

#endif // _QX_SERIALIZE_QWEAKPOINTER_H_