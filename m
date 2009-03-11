From: akpm@linux-foundation.org
Subject: + maintainers-downgrade-support-for-man-pages.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:43:05 -0700
Message-ID: <200903112043.n2BKh6ak001873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbZCKUoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:44:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com


The patch titled
     MAINTAINERS: downgrade support for man-pages
has been added to the -mm tree.  Its filename is
     maintainers-downgrade-support-for-man-pages.patch

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
@@ -1477,8 +1477,6 @@ L:	linux-acpi@vger.kernel.org
 S:	Supported
 
 DOCUMENTATION (/Documentation directory)
-P:	Michael Kerrisk
-M:	mtk.manpages@gmail.com
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
 L:	linux-doc@vger.kernel.org
@@ -2912,7 +2910,7 @@ P:	Michael Kerrisk
 M:	mtk.manpages@gmail.com
 W:	http://www.kernel.org/doc/man-pages
 L:	linux-man@vger.kernel.org
-S:	Supported
+S:	Maintained
 
 MARVELL LIBERTAS WIRELESS DRIVER
 P:	Dan Williams
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

maintainers-downgrade-support-for-man-pages.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch

