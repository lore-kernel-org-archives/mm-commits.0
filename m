From: akpm@linux-foundation.org
Subject: [merged] video-mmp-fb-support-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:02 -0800
Message-ID: <20130222203803.3839031C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:48067 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3BVUiE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:04 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so103771ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, FlorianSchandinat@gmx.de, cldu@marvell.com, greg@kroah.com, haojian.zhuang@gmail.com, ligq@marvell.com, zzhu3@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fb: mmp: include linux/platform_device.h
has been removed from the -mm tree.  Its filename was
     video-mmp-fb-support-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fb: mmp: include linux/platform_device.h

Patch 16559ae "kgdb: remove #include <linux/serial_8250.h> from kgdb.h"
changes the kgdb.h file so that drivers including it do not implicitly
include linux/platform_device.h. The mmp framebuffer driver is new,
so Greg did not have a chance to fix it up when introducing his change.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Zhou Zhu <zzhu3@marvell.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mmp/fb/mmpfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/mmp/fb/mmpfb.c~video-mmp-fb-support-fix drivers/video/mmp/fb/mmpfb.c
--- a/drivers/video/mmp/fb/mmpfb.c~video-mmp-fb-support-fix
+++ a/drivers/video/mmp/fb/mmpfb.c
@@ -21,6 +21,7 @@
  */
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
 #include "mmpfb.h"
 
 static int var_to_pixfmt(struct fb_var_screeninfo *var)
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
swap-add-per-partition-lock-for-swapfile-fix-for-nommu.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch

