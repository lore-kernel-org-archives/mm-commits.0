From: akpm@linux-foundation.org
Subject: - pm-drop-unnecessary-includes-from-pmh.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:24 -0700
Message-ID: <200807242325.m6ONPO4u010876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755563AbYGXXZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     pm: drop unnecessary includes from pm.h
has been removed from the -mm tree.  Its filename was
     pm-drop-unnecessary-includes-from-pmh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm: drop unnecessary includes from pm.h
From: Rafael J. Wysocki <rjw@sisk.pl>

Drop unnecessary includes from include/linux/pm.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/pm.h~pm-drop-unnecessary-includes-from-pmh include/linux/pm.h
--- a/include/linux/pm.h~pm-drop-unnecessary-includes-from-pmh
+++ a/include/linux/pm.h
@@ -22,8 +22,6 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
-#include <asm/atomic.h>
-#include <asm/errno.h>
 
 /*
  * Callbacks for platform drivers to implement.
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
sky2-adapt-to-use-reworked-pci-pm-code.patch
tg3-adapt-tg3-to-use-reworked-pci-pm-code.patch
drivers-power-fix-platform-driver-hotplug-coldplug.patch
mfd-fix-platform-driver-hotplug-coldplug.patch
parport-fix-platform-driver-hotplug-coldplug.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
shrink_slab-handle-bad-shrinkers.patch

