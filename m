From: akpm@linux-foundation.org
Subject: - cx88-fix-compilation-on-alpha.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:33 -0700
Message-ID: <200705031930.l43JUXtN018195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767822AbXECTdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     cx88: fix compilation on alpha
has been removed from the -mm tree.  Its filename was
     cx88-fix-compilation-on-alpha.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cx88: fix compilation on alpha
From: Alexey Dobriyan <adobriyan@gmail.com>

error: 'DMA_32BIT_MASK' undeclared

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-alsa.c  |    1 +
 drivers/media/video/cx88/cx88-mpeg.c  |    1 +
 drivers/media/video/cx88/cx88-video.c |    1 +
 3 files changed, 3 insertions(+)

diff -puN drivers/media/video/cx88/cx88-alsa.c~cx88-fix-compilation-on-alpha drivers/media/video/cx88/cx88-alsa.c
--- a/drivers/media/video/cx88/cx88-alsa.c~cx88-fix-compilation-on-alpha
+++ a/drivers/media/video/cx88/cx88-alsa.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 #include <asm/delay.h>
 #include <sound/driver.h>
 #include <sound/core.h>
diff -puN drivers/media/video/cx88/cx88-mpeg.c~cx88-fix-compilation-on-alpha drivers/media/video/cx88/cx88-mpeg.c
--- a/drivers/media/video/cx88/cx88-mpeg.c~cx88-fix-compilation-on-alpha
+++ a/drivers/media/video/cx88/cx88-mpeg.c
@@ -27,6 +27,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
+#include <linux/dma-mapping.h>
 #include <asm/delay.h>
 
 #include "cx88.h"
diff -puN drivers/media/video/cx88/cx88-video.c~cx88-fix-compilation-on-alpha drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~cx88-fix-compilation-on-alpha
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -36,6 +36,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/dma-mapping.h>
 #include <asm/div64.h>
 
 #include "cx88.h"
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-dvb.patch
git-parisc.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
git-watchdog.patch
reiserfs-shrink-superblock-if-no-xattrs.patch
i386-schedh-inclusion-from-moduleh-is-baack.patch
