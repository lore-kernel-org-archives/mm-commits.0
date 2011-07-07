From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-section-usb-se401-driver.patch removed from -mm tree
Date: Thu, 07 Jul 2011 12:20:53 -0700
Message-ID: <201107071920.p67JKRmj008561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab1GGTUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2011 15:20:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hverkuil@xs4all.nl, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: uemove section USB SE401 DRIVER
has been removed from the -mm tree.  Its filename was
     maintainers-remove-section-usb-se401-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: uemove section USB SE401 DRIVER
From: Joe Perches <joe@perches.com>

Commit b287db119edb ("[media] se401: remove last V4L1 driver")
removed the driver, so remove the section from MAINTAINERS.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 -------
 1 file changed, 7 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-section-usb-se401-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-section-usb-se401-driver
+++ a/MAINTAINERS
@@ -6564,13 +6564,6 @@ W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
-USB SE401 DRIVER
-L:	linux-usb@vger.kernel.org
-W:	http://www.chello.nl/~j.vreeken/se401/
-S:	Orphan
-F:	Documentation/video4linux/se401.txt
-F:	drivers/staging/se401/
