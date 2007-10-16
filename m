From: akpm@linux-foundation.org
Subject: - ps3fb-clean-up-includes.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:45:28 -0700
Message-ID: <200710162045.l9GKjS4I016267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934926AbXJPU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     ps3fb: clean up includes
has been removed from the -mm tree.  Its filename was
     ps3fb-clean-up-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: clean up includes
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Clean up includes

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-clean-up-includes drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-clean-up-includes
+++ a/drivers/video/ps3fb.c
@@ -22,22 +22,14 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-#include <linux/tty.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/console.h>
 #include <linux/ioctl.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-
 #include <linux/uaccess.h>
 #include <linux/fb.h>
 #include <linux/init.h>
-#include <asm/time.h>
 
 #include <asm/abs_addr.h>
 #include <asm/lv1call.h>
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
