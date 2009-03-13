From: akpm@linux-foundation.org
Subject: [merged] maintainers-downgrade-support-for-man-pages.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:19:34 -0700
Message-ID: <200903131819.n2DIJY0L008602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092AbZCMSVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: downgrade support for man-pages
has been removed from the -mm tree.  Its filename was
     maintainers-downgrade-support-for-man-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: downgrade support for man-pages
From: Michael Kerrisk <mtk.manpages@googlemail.com>

Unfortunately, Linux Foundation funding for my work on
man-pages/testing/doc under the auspices of the LF documentation
fellowship unfortunately ran out a short while ago (after earlier attempts
to seek funding, only Google stepped forward with a bit of further funding
for the position), so the patch below acknowledges something closer to
reality.

Unfortunately, there will (probably very) soon be a further downgrade from
"Maintained" to "Odd Fixes" or "Orphan", unless some funding miracle
occurs.  So, if anyone is looking to become man-pages maintainer, there
may soon be an opening (okay, don't trample me in the rush ;-).)

Signed-off-by: Michael Kerrisk <mtk.manpages@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-downgrade-support-for-man-pages MAINTAINERS
--- a/MAINTAINERS~maintainers-downgrade-support-for-man-pages
+++ a/MAINTAINERS
@@ -1469,8 +1469,6 @@ L:	linux-acpi@vger.kernel.org
 S:	Supported
 
 DOCUMENTATION (/Documentation directory)
-P:	Michael Kerrisk
-M:	mtk.manpages@gmail.com
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
 L:	linux-doc@vger.kernel.org
@@ -2879,7 +2877,7 @@ P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
 W:	http://www.kernel.org/doc/man-pages
 L:	linux-man@vger.kernel.org
-S:	Supported
+S:	Maintained
 
 MARVELL LIBERTAS WIRELESS DRIVER
 P:	Dan Williams
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

origin.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

