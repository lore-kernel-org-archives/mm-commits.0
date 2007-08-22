From: akpm@linux-foundation.org
Subject: + maintainers-update-dco-info.patch added to -mm tree
Date: Wed, 22 Aug 2007 15:55:21 -0700
Message-ID: <200708222255.l7MMtLaf009085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760126AbXHVWza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 18:55:30 -0400
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

Update URL for DCO (old URL is invalid).  Also, point to SubmittingPatches
for the current DCO.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-dco-info MAINTAINERS
--- a/MAINTAINERS~maintainers-update-dco-info
+++ a/MAINTAINERS
@@ -45,8 +45,11 @@ trivial patch so apply some common sense
 
 	PLEASE remember that submissions must be made under the terms
 	of the OSDL certificate of contribution
-	(http://www.osdl.org/newsroom/press_releases/2004/2004_05_24_dco.html)
+	(http://old.linux-foundation.org/newsroom/press_releases/2004/2004_05_24_dco.html)
 	and should include a Signed-off-by: line.
+	The current certificate is also documented in
+	Documentation/SubmittingPatches as the Developer's Certificate
+	of Origin (DCO).
 
 6.	Make sure you have the right to send any changes you make. If you
 	do changes at work you may find your employer owns the patch
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

maintainers-update-dco-info.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
git-unionfs.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
