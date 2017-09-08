From: akpm@linux-foundation.org
Subject: [folded-merged] vga-optimise-console-scrolling-fix.patch removed
 from -mm tree
Date: Fri, 08 Sep 2017 16:01:45 -0700
Message-ID: <59b32159.rje0l5/SxSSsqRdV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757244AbdIHXBq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mawilcox@microsoft.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: vga-optimise-console-scrolling-fix
has been removed from the -mm tree.  Its filename was
     vga-optimise-console-scrolling-fix.patch

This patch was dropped because it was folded into vga-optimise-console-scrolling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vga-optimise-console-scrolling-fix

fix build

Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vt_buffer.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/vt_buffer.h~vga-optimise-console-scrolling-fix include/linux/vt_buffer.h
--- a/include/linux/vt_buffer.h~vga-optimise-console-scrolling-fix
+++ a/include/linux/vt_buffer.h
@@ -13,6 +13,7 @@
 #ifndef _LINUX_VT_BUFFER_H_
 #define _LINUX_VT_BUFFER_H_
 
+#include <linux/string.h>
 
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_MDA_CONSOLE)
 #include <asm/vga.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

vga-optimise-console-scrolling.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch

