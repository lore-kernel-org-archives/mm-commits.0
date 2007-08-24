From: akpm@linux-foundation.org
Subject: + maintainers-update-dco-info.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:26:02 -0700
Message-ID: <200708242226.l7OMQ2PB017854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759574AbXHXW0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     MAINTAINERS: update DCO info
has been added to the -mm tree.  Its filename is
     maintainers-update-dco-info.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MAINTAINERS: update DCO info
From: Randy Dunlap <randy.dunlap@oracle.com>

Drop the URL for DCO (URL is invalid).  Also, point to SubmittingPatches
for the current DCO.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-dco-info MAINTAINERS
--- a/MAINTAINERS~maintainers-update-dco-info
+++ a/MAINTAINERS
@@ -44,9 +44,10 @@ trivial patch so apply some common sense
 	or does something very odd once a month document it.
 
 	PLEASE remember that submissions must be made under the terms
-	of the OSDL certificate of contribution
-	(http://www.osdl.org/newsroom/press_releases/2004/2004_05_24_dco.html)
-	and should include a Signed-off-by: line.
+	of the OSDL certificate of contribution and should include a
+	Signed-off-by: line.  The current version of this "Developer's
+	Certificate of Origin" (DCO) is listed in the file
+	Documentation/SubmittingPatches.
 
 6.	Make sure you have the right to send any changes you make. If you
 	do changes at work you may find your employer owns the patch
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-update-dco-info.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
pci-aer-fix-warnings-when-pcieaer=n.patch
git-unionfs.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
