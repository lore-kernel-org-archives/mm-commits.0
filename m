From: akpm@linux-foundation.org
Subject: [merged]
 drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch removed from -mm tree
Date: Fri, 02 Oct 2015 12:36:30 -0700
Message-ID: <560edcbe.cbNdATDPPlugO2Ef%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbJBTgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:36:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dmitry.torokhov@gmail.com, fengguang.wu@gmail.com, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/input/joystick/Kconfig: zhenhua.c needs BITREVERSE
has been removed from the -mm tree.  Its filename was
     drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/input/joystick/Kconfig: zhenhua.c needs BITREVERSE

It uses bitrev8(), so it must ensure that lib/bitrev.o gets included in
vmlinux.

Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: yalin wang <yalin.wang2010@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/input/joystick/Kconfig~drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse drivers/input/joystick/Kconfig
--- a/drivers/input/joystick/Kconfig~drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse
+++ a/drivers/input/joystick/Kconfig
@@ -196,6 +196,7 @@ config JOYSTICK_TWIDJOY
 config JOYSTICK_ZHENHUA
 	tristate "5-byte Zhenhua RC transmitter"
 	select SERIO
+	select BITREVERSE
 	help
 	  Say Y here if you have a Zhen Hua PPM-4CH transmitter which is
 	  supplied with a ready to fly micro electric indoor helicopters
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

