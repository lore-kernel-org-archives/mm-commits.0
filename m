From: akpm@linux-foundation.org
Subject: - maintainers-update-dco-info.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:56:26 -0700
Message-ID: <200708311656.l7VGuQBO017484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47251 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932625AbXHaRJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 13:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update DCO info
has been removed from the -mm tree.  Its filename was
     maintainers-update-dco-info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MAINTAINERS: update DCO info
From: Randy Dunlap <randy.dunlap@oracle.com>

Drop the URL for DCO (URL is invalid).  Also, point to SubmittingPatches
for the current DCO.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
git-nfsd.patch
git-unionfs.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
