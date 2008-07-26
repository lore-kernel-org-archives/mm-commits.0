From: akpm@linux-foundation.org
Subject: - include-video-atmel_lcdch-must-include-linux-workqueueh.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:08 -0700
Message-ID: <200807262113.m6QLD8Oe019573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757400AbYGZVNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     include/video/atmel_lcdc.h must #include <linux/workqueue.h>
has been removed from the -mm tree.  Its filename was
     include-video-atmel_lcdch-must-include-linux-workqueueh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/video/atmel_lcdc.h must #include <linux/workqueue.h>
From: Adrian Bunk <bunk@kernel.org>

This patch fixes the following compile error caused by
commit d22579b837358cbef12ccca5adaf7e93ae09ab7a
(atmel_lcdfb: FIFO underflow management):

In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/avr32/boards/atstk1000/atstk1004.c:21:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/video/atmel_lcdc.h:40: error: field 'task' has incomplete type

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/atmel_lcdc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/video/atmel_lcdc.h~include-video-atmel_lcdch-must-include-linux-workqueueh include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~include-video-atmel_lcdch-must-include-linux-workqueueh
+++ a/include/video/atmel_lcdc.h
@@ -22,6 +22,7 @@
 #ifndef __ATMEL_LCDC_H__
 #define __ATMEL_LCDC_H__
 
+#include <linux/workqueue.h>
 
 /* Way LCD wires are connected to the chip:
  * Some Atmel chips use BGR color mode (instead of standard RGB)
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

