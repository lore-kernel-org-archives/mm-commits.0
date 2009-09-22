From: akpm@linux-foundation.org
Subject: [merged] lis3-fix-typo.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:46:10 -0700
Message-ID: <200909222046.n8MKkAxP017171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbZIVUqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel@caiaq.de, eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: fix typo
has been removed from the -mm tree.  Its filename was
     lis3-fix-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: fix typo
From: Daniel Mack <daniel@caiaq.de>

Bit 0x80 in CTRL_REG3 is an ACTIVE_LOW rather than an ACTIVE_HIGH
function, I got that wrong during my last change.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lis3lv02d.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/lis3lv02d.h~lis3-fix-typo include/linux/lis3lv02d.h
--- a/include/linux/lis3lv02d.h~lis3-fix-typo
+++ a/include/linux/lis3lv02d.h
@@ -32,7 +32,7 @@ struct lis3lv02d_platform_data {
 #define LIS3_IRQ2_DATA_READY	(4 << 3)
 #define LIS3_IRQ2_CLICK		(7 << 3)
 #define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
-#define LIS3_IRQ_ACTIVE_HIGH	(1 << 7)
+#define LIS3_IRQ_ACTIVE_LOW	(1 << 7)
 	unsigned char irq_cfg;
 };
 
_

Patches currently in -mm which might be from daniel@caiaq.de are

origin.patch
linux-next.patch
rtc-add-driver-for-mxcs-internal-rtc-module.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix.patch
rtc-add-driver-for-mxcs-internal-rtc-module-fix-fix.patch

