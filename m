From: akpm@linux-foundation.org
Subject: + maintainers-add-ltp-info-to-the-list.patch added to -mm tree
Date: Mon, 27 Oct 2008 20:32:14 -0700
Message-ID: <200810280332.m9S3WE34029827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbYJ1DcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Oct 2008 23:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, subrata@linux.vnet.ibm.com


The patch titled
     MAINTAINERS: add LTP info to the list
has been added to the -mm tree.  Its filename is
     maintainers-add-ltp-info-to-the-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add LTP info to the list
From: Mike Frysinger <vapier@gentoo.org>

Cc: Subrata Modak <subrata@linux.vnet.ibm.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN MAINTAINERS~maintainers-add-ltp-info-to-the-list MAINTAINERS
--- a/MAINTAINERS~maintainers-add-ltp-info-to-the-list
+++ a/MAINTAINERS
@@ -2701,6 +2701,16 @@ M:	matthew@wil.cx
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+LTP (Linux Test Project)
+P:	Subrata Modak
+M:	subrata@linux.vnet.ibm.com
+P:	Mike Frysinger
+M:	vapier@gentoo.org
+L:	ltp-list@lists.sourceforge.net (subscribers-only)
+W:	http://ltp.sourceforge.net/
+T:	git kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
+S:	Maintained
+
 M32R ARCHITECTURE
 P:	Hirokazu Takata
 M:	takata@linux-m32r.org
_

Patches currently in -mm which might be from vapier@gentoo.org are

maintainers-add-ltp-info-to-the-list.patch
linux-timexh-cleanup-for-userspace.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
setlocalversion-dont-include-svn-change-count.patch

