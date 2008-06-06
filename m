From: akpm@linux-foundation.org
Subject: + maintainers-update-maintainership-of-pxa2xx-pxa3xx.patch added to -mm tree
Date: Fri, 06 Jun 2008 13:43:47 -0700
Message-ID: <200806062043.m56KhlW8018451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763868AbYFFUoN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jun 2008 16:44:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.y.miao@gmail.com, eric.miao@marvell.com, nico@marvell.com, rmk@arm.linux.org.uk


The patch titled
     MAINTAINERS: update maintainership of pxa2xx/pxa3xx
has been added to the -mm tree.  Its filename is
     maintainers-update-maintainership-of-pxa2xx-pxa3xx.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update maintainership of pxa2xx/pxa3xx
From: Eric Miao <eric.y.miao@gmail.com>

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Acked-by: Russell King <rmk@arm.linux.org.uk>
Acked-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-maintainership-of-pxa2xx-pxa3xx MAINTAINERS
--- a/MAINTAINERS~maintainers-update-maintainership-of-pxa2xx-pxa3xx
+++ a/MAINTAINERS
@@ -3340,9 +3340,11 @@ L:	video4linux-list@redhat.com
 W:	http://www.isely.net/pvrusb2/
 S:	Maintained
 
-PXA2xx SUPPORT
-P:	Nicolas Pitre
-M:	nico@cam.org
+PXA2xx/PXA3xx SUPPORT
+P:	Eric Miao
+M:	eric.miao@marvell.com
+P:	Russell King
+M:	linux@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
 
_

Patches currently in -mm which might be from eric.y.miao@gmail.com are

linux-next.patch
maintainers-update-maintainership-of-pxa2xx-pxa3xx.patch

