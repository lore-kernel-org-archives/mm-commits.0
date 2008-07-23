From: akpm@linux-foundation.org
Subject: - aty-use-memory_read_from_buffer-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:38:00 -0700
Message-ID: <200807232350.m6NNobA0018661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419AbYGWXuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, adaplas@pol.net, benh@kernel.crashing.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fix aty-use-memory_read_from_buffer.patch
has been removed from the -mm tree.  Its filename was
     aty-use-memory_read_from_buffer-fix.patch

This patch was dropped because it was folded into aty-use-memory_read_from_buffer.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix aty-use-memory_read_from_buffer.patch
From: Akinobu Mita <akinobu.mita@gmail.com>

Now memory_read_from_buffer() belongs in string.h

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_base.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/aty/radeon_base.c~aty-use-memory_read_from_buffer-fix drivers/video/aty/radeon_base.c
--- a/drivers/video/aty/radeon_base.c~aty-use-memory_read_from_buffer-fix
+++ a/drivers/video/aty/radeon_base.c
@@ -70,7 +70,6 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/device.h>
-#include <linux/fs.h>
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
move-memory_read_from_buffer-from-fsh-to-stringh.patch
pm-hibernation-simplify-memory-bitmap.patch
cris-use-simple_read_from_buffer.patch
binfmt_misc-use-simple_read_from_buffer.patch
aty-use-memory_read_from_buffer.patch
aty-use-memory_read_from_buffer-fix.patch
auxdisplay-small-cleanups.patch

