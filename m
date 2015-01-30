From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 30 Jan 2015 11:29:40 -0800
Message-ID: <54cbdba4.0e4z/uRspkCN+eY+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336AbbA3T3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 14:29:41 -0500
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

 sound/soc/codecs/rt5677.c |    3 ---
 sound/soc/fsl/fsl_ssi.c   |    5 -----
 2 files changed, 8 deletions(-)

diff -puN sound/soc/codecs/rt5677.c~linux-next-git-rejects sound/soc/codecs/rt5677.c
--- a/sound/soc/codecs/rt5677.c~linux-next-git-rejects
+++ a/sound/soc/codecs/rt5677.c
@@ -2321,8 +2321,6 @@ static const struct snd_soc_dapm_widget
 	SND_SOC_DAPM_SUPPLY("PLL2", RT5677_PWR_ANLG2, RT5677_PWR_PLL2_BIT,
 		0, rt5677_set_pll2_event, SND_SOC_DAPM_PRE_PMU |
 		SND_SOC_DAPM_POST_PMU),
-<<<<<<< HEAD
-=======
 
 	/* ASRC */
 	SND_SOC_DAPM_SUPPLY_S("I2S1 ASRC", 1, RT5677_ASRC_1, 0, 0, NULL, 0),
@@ -2362,7 +2360,6 @@ static const struct snd_soc_dapm_widget
 		0),
 	SND_SOC_DAPM_SUPPLY_S("ADC MONO R ASRC", 1, RT5677_ASRC_2, 0, 0, NULL,
 		0),
->>>>>>> linux-next/akpm-base
 
 	/* Input Side */
 	/* micbias */
diff -puN sound/soc/fsl/fsl_ssi.c~linux-next-git-rejects sound/soc/fsl/fsl_ssi.c
--- a/sound/soc/fsl/fsl_ssi.c~linux-next-git-rejects
+++ a/sound/soc/fsl/fsl_ssi.c
@@ -1362,13 +1362,8 @@ static int fsl_ssi_probe(struct platform
 	}
 
 	ssi_private->irq = platform_get_irq(pdev, 0);
-<<<<<<< HEAD
-	if (ssi_private->irq < 0) {
-		dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
-=======
 	if (!ssi_private->irq) {
 		dev_err(&pdev->dev, "no irq for node %s\n", pdev->name);
->>>>>>> linux-next/akpm-base
 		return ssi_private->irq;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-fold-move_anon-and-move_file-fix.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-compaction-enhance-tracepoint-output-for-compaction-begin-end-v4-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated-fix.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
mm-page_ext-remove-unnecessary-stack_trace-field-fix.patch
mm-fix-arithmetic-overflow-in-__vm_enough_memory-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
lib-bitmap-change-parameters-of-bitmap_fold-to-unsigned-fix.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-fix-xip-fault-vs-truncate-race-fix-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix-3.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-2.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix-3.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality-fix.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir-fix.patch
ocfs2-implement-ocfs2_direct_io_write-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

