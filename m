From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 05 Jun 2017 12:02:27 -0700
Message-ID: <20170605190227.zw_cltK5L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdFETC3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 15:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/mv_xor_v2.c |    6 ------
 drivers/hid/wacom_wac.c |   15 ---------------
 2 files changed, 21 deletions(-)

diff -puN drivers/dma/mv_xor_v2.c~linux-next-git-rejects drivers/dma/mv_xor_v2.c
--- a/drivers/dma/mv_xor_v2.c~linux-next-git-rejects
+++ a/drivers/dma/mv_xor_v2.c
@@ -257,8 +257,6 @@ static int mv_xor_v2_set_desc_size(struc
 	return MV_XOR_V2_EXT_DESC_SIZE;
 }
 
-<<<<<<< HEAD
-=======
 /*
  * Set the IMSG threshold
  */
@@ -282,7 +280,6 @@ void mv_xor_v2_enable_imsg_thrd(struct m
 	writel(reg, xor_dev->dma_base + MV_XOR_V2_DMA_IMSG_TMOT);
 }
 
->>>>>>> linux-next/akpm-base
 static irqreturn_t mv_xor_v2_interrupt_handler(int irq, void *data)
 {
 	struct mv_xor_v2_device *xor_dev = data;
@@ -696,8 +693,6 @@ static int mv_xor_v2_descq_init(struct m
 	/* enable the DMA engine */
 	writel(0, xor_dev->dma_base + MV_XOR_V2_DMA_DESQ_STOP_OFF);
 
-<<<<<<< HEAD
-=======
 	return 0;
 }
 
@@ -719,7 +714,6 @@ static int mv_xor_v2_resume(struct platf
 	mv_xor_v2_enable_imsg_thrd(xor_dev);
 	mv_xor_v2_descq_init(xor_dev);
 
->>>>>>> linux-next/akpm-base
 	return 0;
 }
 
diff -puN drivers/hid/wacom_wac.c~linux-next-git-rejects drivers/hid/wacom_wac.c
--- a/drivers/hid/wacom_wac.c~linux-next-git-rejects
+++ a/drivers/hid/wacom_wac.c
@@ -1593,7 +1593,6 @@ static int wacom_tpc_irq(struct wacom_wa
 		switch (len) {
 		case WACOM_PKGLEN_TPC1FG:
 			return wacom_tpc_single_touch(wacom, len);
-<<<<<<< HEAD
 
 		case WACOM_PKGLEN_TPC2FG:
 			return wacom_tpc_mt_touch(wacom);
@@ -1606,20 +1605,6 @@ static int wacom_tpc_irq(struct wacom_wa
 			case WACOM_REPORT_TPC1FGE:
 				return wacom_tpc_single_touch(wacom, len);
 
-=======
-
-		case WACOM_PKGLEN_TPC2FG:
-			return wacom_tpc_mt_touch(wacom);
-
-		default:
-			switch (data[0]) {
-			case WACOM_REPORT_TPC1FG:
-			case WACOM_REPORT_TPCHID:
-			case WACOM_REPORT_TPCST:
-			case WACOM_REPORT_TPC1FGE:
-				return wacom_tpc_single_touch(wacom, len);
-
->>>>>>> linux-next/akpm-base
 			case WACOM_REPORT_TPCMT:
 			case WACOM_REPORT_TPCMT2:
 				return wacom_mt_touch(wacom);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

