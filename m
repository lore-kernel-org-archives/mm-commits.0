From: akpm@linux-foundation.org
Subject: [merged] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 13 Feb 2014 13:00:05 -0800
Message-ID: <52fd3255.F75hJSWNxpsO3FOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaBMVAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 16:00:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [merged] linux-next-git-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 13:00:05 -0800


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_dp.c |    6 ------
 drivers/spi/spi.c               |    5 -----
 2 files changed, 11 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~linux-next-git-rejects arch/x86/include/asm/pgtable.h
diff -puN mm/slub.c~linux-next-git-rejects mm/slub.c
diff -puN drivers/gpu/drm/i915/intel_dp.c~linux-next-git-rejects drivers/gpu/drm/i915/intel_dp.c
--- a/drivers/gpu/drm/i915/intel_dp.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/intel_dp.c
@@ -458,14 +458,8 @@ intel_dp_aux_ch(struct intel_dp *intel_d
 	uint32_t aux_clock_divider;
 	int i, ret, recv_bytes;
 	uint32_t status;
-<<<<<<< HEAD
-	int try, precharge, clock = 0;
-	bool has_aux_irq = HAS_AUX_IRQ(dev);
-	uint32_t timeout;
-=======
 	int try, clock = 0;
 	bool has_aux_irq = HAS_AUX_IRQ(dev);
->>>>>>> linux-next/akpm-base
 
 	/* dp aux is extremely sensitive to irq latency, hence request the
 	 * lowest possible wakeup latency and so prevent the cpu from going into
diff -puN drivers/spi/spi.c~linux-next-git-rejects drivers/spi/spi.c
--- a/drivers/spi/spi.c~linux-next-git-rejects
+++ a/drivers/spi/spi.c
@@ -933,13 +933,8 @@ static void spi_pump_messages(struct kth
 
 	ret = spi_map_msg(master, master->cur_msg);
 	if (ret) {
-<<<<<<< HEAD
-		dev_err(&master->dev,
-			"failed to transfer one message from queue\n");
-=======
 		master->cur_msg->status = ret;
 		spi_finalize_current_message(master);
->>>>>>> linux-next/akpm-base
 		return;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
jffs2-avoid-soft-lockup-in-jffs2_reserve_space_gc.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-spi-spic-fix-max-warning.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

