From: akpm@linux-foundation.org
Subject: [folded] kernel-cpuc-fix-many-errors-related-to-style-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:03:28 -0700
Message-ID: <201103222303.p2MN3SG1000422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab1CVXET (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:04:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dkingston02@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel-cpuc-fix-many-errors-related-to-style-fix
has been removed from the -mm tree.  Its filename was
     kernel-cpuc-fix-many-errors-related-to-style-fix.patch

This patch was dropped because it was folded into kernel-cpuc-fix-many-errors-related-to-style.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-cpuc-fix-many-errors-related-to-style-fix
From: Andrew Morton <akpm@linux-foundation.org>

revert the bits I disagree with ;)

Cc: Michael Rodriguez <dkingston02@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/cpu.c~kernel-cpuc-fix-many-errors-related-to-style-fix kernel/cpu.c
--- a/kernel/cpu.c~kernel-cpuc-fix-many-errors-related-to-style-fix
+++ a/kernel/cpu.c
@@ -200,7 +200,6 @@ static int __ref take_cpu_down(void *_pa
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
-
 	if (err < 0)
 		return err;
 
@@ -228,7 +227,6 @@ static int __ref _cpu_down(unsigned int 
 	cpu_hotplug_begin();
 
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
-
 	if (err) {
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
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
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

