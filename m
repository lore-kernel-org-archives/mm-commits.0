From: akpm@linux-foundation.org
Subject: - kernel-doc-add-tools-doc-in-makefile.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:02 -0700
Message-ID: <200707192002.l6JK22dF019620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337AbXGSUQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     kernel-doc: add tools doc in Makefile
has been removed from the -mm tree.  Its filename was
     kernel-doc-add-tools-doc-in-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel-doc: add tools doc in Makefile
From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc tools info in Makefile.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/DocBook/Makefile~kernel-doc-add-tools-doc-in-makefile Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~kernel-doc-add-tools-doc-in-makefile
+++ a/Documentation/DocBook/Makefile
@@ -15,11 +15,11 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
 
 ###
 # The build process is as follows (targets):
-#              (xmldocs)
-# file.tmpl --> file.xml +--> file.ps   (psdocs)
-#                        +--> file.pdf  (pdfdocs)
-#                        +--> DIR=file  (htmldocs)
-#                        +--> man/      (mandocs)
+#              (xmldocs) [by docproc]
+# file.tmpl --> file.xml +--> file.ps   (psdocs)   [by db2ps or xmlto]
+#                        +--> file.pdf  (pdfdocs)  [by db2pdf or xmlto]
+#                        +--> DIR=file  (htmldocs) [by xmlto]
+#                        +--> man/      (mandocs)  [by xmlto]
 
 
 # for PDF and PS output you can choose between xmlto and docbook-utils tools
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
profile-likely-unlikely-macros.patch
