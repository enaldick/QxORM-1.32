#############################################################################
##
## http://www.qxorm.com/
## Copyright (C) 2013 Lionel Marty (contact@qxorm.com)
##
## This file is part of the QxOrm library
##
## This software is provided 'as-is', without any express or implied
## warranty. In no event will the authors be held liable for any
## damages arising from the use of this software
##
## Commercial Usage
## Licensees holding valid commercial QxOrm licenses may use this file in
## accordance with the commercial license agreement provided with the
## Software or, alternatively, in accordance with the terms contained in
## a written agreement between you and Lionel Marty
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3.0 as published by the Free Software
## Foundation and appearing in the file 'license.gpl3.txt' included in the
## packaging of this file. Please review the following information to
## ensure the GNU General Public License version 3.0 requirements will be
## met : http://www.gnu.org/copyleft/gpl.html
##
## If you are unsure which license is appropriate for your use, or
## if you have questions regarding the use of this file, please contact :
## contact@qxorm.com
##
#############################################################################

############################
# Qt GUI module dependency #
############################

# To remove QtGui dependency, uncomment the following line :
# CONFIG += QX_NO_QT_GUI

CONFIG(QX_NO_QT_GUI) { QT -= gui }
else {
DEFINES += _QX_QT_GUI_DEPENDENCY
greaterThan(QT_MAJOR_VERSION, 4) { QT += widgets }
} # CONFIG(QX_NO_QT_GUI)

###############################
# boost Library Configuration #
###############################

# In this section, it's necessary to specify boost directories (lib + include) and boost serialization module name (debug + release) :
#  - QX_BOOST_INCLUDE_PATH : your boost include path
#  - QX_BOOST_LIB_PATH : your boost lib path
#  - QX_BOOST_LIB_SERIALIZATION_DEBUG : your boost serialization module name in debug mode
#  - QX_BOOST_LIB_SERIALIZATION_RELEASE : your boost serialization module name in release mode
#  - QX_BOOST_LIB_WIDE_SERIALIZATION_DEBUG : your boost wide serialization module name in debug mode (default is empty)
#  - QX_BOOST_LIB_WIDE_SERIALIZATION_RELEASE : your boost wide serialization module name in release mode (default is empty)

isEmpty(QX_BOOST_INCLUDE_PATH) { QX_BOOST_INCLUDE_PATH = $$quote($$(BOOST_INCLUDE)) }
isEmpty(QX_BOOST_LIB_PATH) { QX_BOOST_LIB_PATH = $$quote($$(BOOST_LIB)) }
isEmpty(QX_BOOST_LIB_SERIALIZATION_DEBUG) { QX_BOOST_LIB_SERIALIZATION_DEBUG = "$$(BOOST_LIB_SERIALIZATION_DEBUG)" }
isEmpty(QX_BOOST_LIB_SERIALIZATION_RELEASE) { QX_BOOST_LIB_SERIALIZATION_RELEASE = "$$(BOOST_LIB_SERIALIZATION_RELEASE)" }
# isEmpty(QX_BOOST_LIB_WIDE_SERIALIZATION_DEBUG) { QX_BOOST_LIB_WIDE_SERIALIZATION_DEBUG = "$$(BOOST_LIB_WIDE_SERIALIZATION_DEBUG)" }
# isEmpty(QX_BOOST_LIB_WIDE_SERIALIZATION_RELEASE) { QX_BOOST_LIB_WIDE_SERIALIZATION_RELEASE = "$$(BOOST_LIB_WIDE_SERIALIZATION_RELEASE)" }

##############################
# QxOrm Library Static Build #
##############################

# To create only 1 EXE including Qt, boost serialization and QxOrm libraries without any dependency :
#   1- be sure to build Qt and boost::serialization using static mode
#   2- in "./QxOrm.pri" file, add the following line : "DEFINES += _QX_STATIC_BUILD"
#   3- BUT PLEASE : in your program, add a "readme.txt" file and a "about my program..." window to indicate that your application is based on Qt, boost and QxOrm libraries !
# Note : on Windows, static mode works with only 1 EXE, it will never work mixing DLL and EXE (because of singleton implementation of boost::serialization and QxOrm libraries)

# DEFINES += _QX_STATIC_BUILD

######################################
# QxOrm Library Serialization Engine #
######################################

# In this section, you can enable/disable different serialization engine, by default, there is :
#  - _QX_SERIALIZE_BINARY_ENABLED
#  - _QX_SERIALIZE_XML_ENABLED

DEFINES += _QX_SERIALIZE_BINARY_ENABLED
DEFINES += _QX_SERIALIZE_XML_ENABLED

# DEFINES += _QX_SERIALIZE_POLYMORPHIC_ENABLED
# DEFINES += _QX_SERIALIZE_TEXT_ENABLED
# DEFINES += _QX_SERIALIZE_PORTABLE_BINARY_ENABLED
# DEFINES += _QX_SERIALIZE_WIDE_BINARY_ENABLED
# DEFINES += _QX_SERIALIZE_WIDE_TEXT_ENABLED
# DEFINES += _QX_SERIALIZE_WIDE_XML_ENABLED

######################
# Globals Parameters #
######################

CONFIG += debug_and_release
CONFIG += precompile_header
DEPENDPATH += .
INCLUDEPATH += ./include
INCLUDEPATH += $${QX_BOOST_INCLUDE_PATH}
QT += network
QT += xml
QT += sql
MOC_DIR = ./qt/moc
RCC_DIR = ./qt/rcc/src
UI_DIR = ./qt/ui
UI_HEADERS_DIR = ./qt/ui/include
UI_SOURCES_DIR = ./qt/ui/src

CONFIG(debug, debug|release) {
DEFINES += _QX_MODE_DEBUG
} else {
DEFINES += _QX_MODE_RELEASE
} # CONFIG(debug, debug|release)

#############################
# Compiler / Linker Options #
#############################

win32 {
CONFIG(debug, debug|release) {
} else {
DEFINES += NDEBUG
win32-msvc2005: QMAKE_LFLAGS += /OPT:NOREF
win32-msvc2008: QMAKE_LFLAGS += /OPT:NOREF
win32-msvc2010: QMAKE_LFLAGS += /OPT:NOREF
} # CONFIG(debug, debug|release)
win32-g++: QMAKE_LFLAGS += -Wl,-export-all-symbols -Wl,-enable-auto-import
} # win32

#######################
# Externals Libraries #
#######################

LIBS += -L$${QX_BOOST_LIB_PATH}

CONFIG(debug, debug|release) {
LIBS += -l$${QX_BOOST_LIB_SERIALIZATION_DEBUG}
!isEmpty(QX_BOOST_LIB_WIDE_SERIALIZATION_DEBUG) { LIBS += -l$${QX_BOOST_LIB_WIDE_SERIALIZATION_DEBUG} }
} else {
LIBS += -l$${QX_BOOST_LIB_SERIALIZATION_RELEASE}
!isEmpty(QX_BOOST_LIB_WIDE_SERIALIZATION_RELEASE) { LIBS += -l$${QX_BOOST_LIB_WIDE_SERIALIZATION_RELEASE} }
} # CONFIG(debug, debug|release)

#####################################
# Output binaries size optimization #
#####################################

# To compile faster classes registered into QxOrm context and to produce smaller binaries size, you should :
# - define only the _QX_SERIALIZE_BINARY_ENABLED compilation option (and disable the default _QX_SERIALIZE_XML_ENABLED compilation option) ;
# - if you need the XML engine, you could consider enable only the _QX_SERIALIZE_POLYMORPHIC_ENABLED compilation option ;
# - under Windows, use MSVC++ instead of MinGW GCC ;
# - with GCC compiler, use the following optimizations options (uncomment it) :

#QMAKE_CXXFLAGS_RELEASE += -ffunction-sections -fdata-sections -Os -pipe
#QMAKE_CFLAGS_RELEASE += -ffunction-sections -fdata-sections -Os -pipe
#QMAKE_LFLAGS_RELEASE += -Wl,--gc-sections -s

#########################
# No precompiled header #
#########################

# Some versions of MinGW on Windows have a bug with large precompiled headers (for example, MinGW GCC 4.8)
# More detais about this problem here : https://gcc.gnu.org/bugzilla/show_bug.cgi?id=56926
# And here : http://stackoverflow.com/questions/10841306/cc1plus-exe-crash-when-using-large-precompiled-header-file
# To fix the crash during compilation, you have to disable precompiled headers : just enable the following compilation option _QX_NO_PRECOMPILED_HEADER
# Note : there is a side effect disabling precompiled headers => compilation times are considerably increased !

# DEFINES += _QX_NO_PRECOMPILED_HEADER

#######################################
# C++11 smart pointers and containers #
#######################################

# By default, QxOrm library supports smart pointers and containers of Qt library and boost library : QHash, QList, QSharedPointer, boost::shared_ptr, boost::unordered_map, etc...
# QxOrm library supports also by default containers of previous C++03 standard library : std::vector, std::list, std::map, std::set
# If you want to enable smart pointers and containers of the new C++11 standard library, you can define the compilation options _QX_CPP_11_SMART_PTR, _QX_CPP_11_CONTAINER and _QX_CPP_11_TUPLE :
# - With _QX_CPP_11_SMART_PTR : std::unique_ptr, std::shared_ptr, std::weak_ptr
# - With _QX_CPP_11_CONTAINER : std::unordered_map, std::unordered_set, std::unordered_multimap, std::unordered_multiset
# - With _QX_CPP_11_TUPLE : std::tuple

# CONFIG += c++11
# DEFINES += _QX_CPP_11_SMART_PTR
# DEFINES += _QX_CPP_11_CONTAINER
# DEFINES += _QX_CPP_11_TUPLE
