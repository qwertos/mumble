/* Copyright (C) 2009-2011, Mikkel Krautz <mikkel@krautz.dk>

   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

   - Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.
   - Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation
     and/or other materials provided with the distribution.
   - Neither the name of the Mumble Developers nor the names of its
     contributors may be used to endorse or promote products derived from this
     software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef MUMBLE_MUMBLE_CRASHREPORTER_H_
#define MUMBLE_MUMBLE_CRASHREPORTER_H_

#include <QtCore/QObject>
#include <QtCore/QEventLoop>
#include <QtNetwork/QNetworkReply>

#if QT_VERSION >= QT_VERSION_CHECK(5, 0, 0)
# include <QtWidgets/QDialog>
# include <QtWidgets/QProgressDialog>
# include <QtWidgets/QLineEdit>
# include <QtWidgets/QTextEdit>
#else
# include <QtGui/QDialog>
# include <QtGui/QProgressDialog>
# include <QtGui/QLineEdit>
# include <QtGui/QTextEdit>
#endif

class CrashReporter : QDialog {
		Q_OBJECT
		Q_DISABLE_COPY(CrashReporter)

	public:
		CrashReporter(QWidget *p = 0);
		~CrashReporter();
		void run();
	protected:
		QEventLoop *qelLoop;
		QProgressDialog *qpdProgress;
		QNetworkReply *qnrReply;
		QLineEdit *qleEmail;
		QTextEdit *qteDescription;
	public slots:
		void uploadFinished();
		void uploadProgress(qint64, qint64);
};

#else
class CrashReporter;
#endif
