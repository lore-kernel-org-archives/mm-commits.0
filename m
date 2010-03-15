From: akpm@linux-foundation.org
Subject: [merged] fbdev-bfin-lq035q1-fb-remove-duplicated-include.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:27 -0400
Message-ID: <201003150658.o2F6w1Hb016404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934984Ab0COG6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: bfin-lq035q1-fb: remove duplicated #include
has been removed from the -mm tree.  Its filename was
     fbdev-bfin-lq035q1-fb-remove-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: bfin-lq035q1-fb: remove duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  drivers/video/bfin-lq035q1-fb.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bfin-lq035q1-fb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/bfin-lq035q1-fb.c~fbdev-bfin-lq035q1-fb-remove-duplicated-include drivers/video/bfin-lq035q1-fb.c
--- a/drivers/video/bfin-lq035q1-fb.c~fbdev-bfin-lq035q1-fb-remove-duplicated-include
+++ a/drivers/video/bfin-lq035q1-fb.c
@@ -22,7 +22,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
-#include <linux/dma-mapping.h>
 
 #include <asm/blackfin.h>
 #include <asm/irq.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
linux-next.patch

