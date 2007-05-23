From: akpm@linux-foundation.org
Subject: + kernel-doc-add-tools-doc-in-makefile.patch added to -mm tree
Date: Wed, 23 May 2007 10:53:35 -0700
Message-ID: <200705231753.l4NHrY1P028507@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433AbXEWRyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 13:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     kernel-doc: add tools doc in Makefile
has been added to the -mm tree.  Its filename is
     kernel-doc-add-tools-doc-in-makefile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
documentation-fix-the-explanation-of-kconfig-files.patch
update-dontdiff-file.patch
doc-clocksources.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
add-notime-boot-option.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
profile-likely-unlikely-macros.patch
