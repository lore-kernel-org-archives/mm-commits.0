From: akpm@linux-foundation.org
Subject: - introduce-rculisth.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:04:41 -0700
Message-ID: <200807070304.m6734fGw004684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819AbYGGDKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, fbuihuu@gmail.com, josh@kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Introduce rculist.h
has been removed from the -mm tree.  Its filename was
     introduce-rculisth.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Introduce rculist.h
From: Stephen Rothwell <sfr@canb.auug.org.au>

In linux-next there is a commit ("rcu: split list.h and move rcu-protected
lists into rculist.h") that moved the rcu related list iterators from
list.h to rculist.h.  Add a trivial version of the file now so that
various subsystem trees can start using it now for -next changes and so
reduce the build errors caused by adding uses of the moved functions.

Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@kernel.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rculist.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null include/linux/rculist.h
--- /dev/null
+++ a/include/linux/rculist.h
@@ -0,0 +1,6 @@
+#ifndef _LINUX_RCULIST_H
+#define _LINUX_RCULIST_H
+
+#include <linux/list.h>
+
+#endif	/* _LINUX_RCULIST_H */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

revert-introduce-rculisth.patch
linux-next.patch
fix-kobject-fix-kobject_rename-and-config_sysfs.patch
drivers-mtd-nand-nandsimc-needs-div64h.patch
mpc83xx_wdt-convert-to-the-of-platform-driver.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch

