From: akpm@linux-foundation.org
Subject: [folded] calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:03:56 -0700
Message-ID: <201103222303.p2MN3uaB000508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab1CVXFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ext-phil.2.carmody@nokia.com, greg@kroah.com, hpa@zytor.com, mingo@elte.hu, sboyd@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix
has been removed from the -mm tree.  Its filename was
     calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch

This patch was dropped because it was folded into calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix
From: Andrew Morton <akpm@linux-foundation.org>

mention x86_64 SMIs in comment

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/calibrate.c~calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix init/calibrate.c
--- a/init/calibrate.c~calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix
+++ a/init/calibrate.c
@@ -172,7 +172,7 @@ recalibrate:
 	/*
 	 * If we incremented every single time possible, presume we've
 	 * massively underestimated initially, and retry with a higher
-	 * start, and larger range. (Only seen on x86_64.)
+	 * start, and larger range. (Only seen on x86_64, due to SMIs)
 	 */
 	if (lpj + loopadd * 2 == lpj_base + loopadd_base * 2) {
 		lpj_base = lpj;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
pagewalk-only-split-huge-pages-when-necessary.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
kernel-cpuc-fix-many-errors-related-to-style.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

