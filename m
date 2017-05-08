From: akpm@linux-foundation.org
Subject: [patch 082/114] drivers/video/fbdev/vermilion/vermilion.c:
 use set_memory.h header
Date: Mon, 08 May 2017 15:58:41 -0700
Message-ID: <20170508225841.8C5NfwViA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdEHW6m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, b.zolnierkie@samsung.com, labbott@redhat.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Laura Abbott <labbott@redhat.com>
Subject: drivers/video/fbdev/vermilion/vermilion.c: use set_memory.h header

set_memory_* functions have moved to set_memory.h. Switch to this
explicitly.

Link: http://lkml.kernel.org/r/1488920133-27229-16-git-send-email-labbott@redhat.com
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/vermilion/vermilion.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbdev/vermilion/vermilion.c~video-vermilion-use-set_memoryh-header drivers/video/fbdev/vermilion/vermilion.c
--- a/drivers/video/fbdev/vermilion/vermilion.c~video-vermilion-use-set_memoryh-header
+++ a/drivers/video/fbdev/vermilion/vermilion.c
@@ -37,7 +37,7 @@
 #include <linux/mm.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
-#include <asm/cacheflush.h>
+#include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 #include <linux/mmzone.h>
 
_
