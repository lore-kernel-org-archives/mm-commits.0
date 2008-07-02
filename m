From: akpm@linux-foundation.org
Subject: - uio-howtotmpl-use-standard-copyright-legal-markings.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:48:10 -0700
Message-ID: <200807020748.m627mA5L005710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761930AbYGBHs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, greg@kroah.com, hjk@linutronix.de, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     uio-howto.tmpl: use standard copyright/legal markings
has been removed from the -mm tree.  Its filename was
     uio-howtotmpl-use-standard-copyright-legal-markings.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: uio-howto.tmpl: use standard copyright/legal markings
=46rom: Mike Frysinger <vapier@gentoo.org>

The Userspace I/O HOWTO document uses straight <sect1> tags and plain t=
ext
to describe copyright/legal information.  It should instead use the
<copyright> and <legalnotice> tags like all other documents in the kern=
el.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/uio-howto.tmpl |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN Documentation/DocBook/uio-howto.tmpl~uio-howtotmpl-use-standa=
rd-copyright-legal-markings Documentation/DocBook/uio-howto.tmpl
--- a/Documentation/DocBook/uio-howto.tmpl~uio-howtotmpl-use-standard-c=
opyright-legal-markings
+++ a/Documentation/DocBook/uio-howto.tmpl
@@ -21,6 +21,18 @@
     </affiliation>
 </author>
=20
+<copyright>
+	<year>2006-2008</year>
+	<holder>Hans-J=C3=BCrgen Koch.</holder>
+</copyright>
+
+<legalnotice>
+<para>
+This documentation is Free Software licensed under the terms of the
+GPL version 2.
+</para>
+</legalnotice>
+
 <pubdate>2006-12-11</pubdate>
=20
 <abstract>
@@ -66,17 +78,6 @@
 <?dbhtml filename=3D"about.html"?>
 <title>About this document</title>
=20
-<sect1 id=3D"copyright">
-<?dbhtml filename=3D"copyright.html"?>
-<title>Copyright and License</title>
-<para>
-      Copyright (c) 2006-2008 by Hans-J=C3=BCrgen Koch.</para>
-<para>
-This documentation is Free Software licensed under the terms of the
-GPL version 2.
-</para>
-</sect1>
