From: akpm@linux-foundation.org
Subject: [merged] arm-compilation-fix-sys_oabi-compatc.patch removed from -mm tree
Date: Fri, 17 Apr 2009 11:14:22 -0700
Message-ID: <200904171814.n3HIEMrT019161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbZDQSbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:31:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: den@openvz.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: compilation fix for sys_oabi-compat.c
has been removed from the -mm tree.  Its filename was
     arm-compilation-fix-sys_oabi-compatc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: compilation fix for sys_oabi-compat.c
From: "Denis V. Lunev" <den@openvz.org>

kmalloc/GFP_KERNEL declaration were not available here.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Russel King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/sys_oabi-compat.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/kernel/sys_oabi-compat.c~arm-compilation-fix-sys_oabi-compatc arch/arm/kernel/sys_oabi-compat.c
--- a/arch/arm/kernel/sys_oabi-compat.c~arm-compilation-fix-sys_oabi-compatc
+++ a/arch/arm/kernel/sys_oabi-compat.c
@@ -83,6 +83,7 @@
 #include <linux/net.h>
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 struct oldabi_stat64 {
 	unsigned long long st_dev;
_

Patches currently in -mm which might be from den@openvz.org are

pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay.patch
pxafb-lcsr1-is-unused-without-config_fb_pxa_overlay-fix.patch
mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char.patch
mtd-mtd-in-mtd_release-is-unused-without-config_mtd_char-fix.patch

