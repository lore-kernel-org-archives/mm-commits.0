From: akpm@linux-foundation.org
Subject: [folded] kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:04:16 -0700
Message-ID: <201103222304.p2MN4GXN000523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab1CVXFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:05:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, dzickus@redhat.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch

This patch was dropped because it was folded into kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix strncmp length

Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix
+++ a/kernel/watchdog.c
@@ -55,7 +55,7 @@ static int __init hardlockup_panic_setup
 {
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
-	else if (!strncmp(str, "nopanic", 5))
+	else if (!strncmp(str, "nopanic", 7))
 		hardlockup_panic = 0;
 	else if (!strncmp(str, "0", 1))
 		watchdog_enabled = 0;
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
kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

