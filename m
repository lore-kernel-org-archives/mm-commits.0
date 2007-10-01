From: akpm@linux-foundation.org
Subject: - pasemi_mac-build-fix-after-recent-netdev-stats.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:30 -0700
Message-ID: <200710010714.l917EUcY004536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58701 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbXJAHU6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:20:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     pasemi_mac: remove unused function
has been removed from the -mm tree.  Its filename was
     pasemi_mac-build-fix-after-recent-netdev-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pasemi_mac: remove unused function
From: Satyam Sharma <satyam@infradead.org>

drivers/net/pasemi_mac.c: At top level:
drivers/net/pasemi_mac.c:89: warning: 'read_iob_reg' defined but not used

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/pasemi_mac.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/net/pasemi_mac.c~pasemi_mac-build-fix-after-recent-netdev-stats drivers/net/pasemi_mac.c
--- a/drivers/net/pasemi_mac.c~pasemi_mac-build-fix-after-recent-netdev-stats
+++ a/drivers/net/pasemi_mac.c
@@ -85,11 +85,6 @@ MODULE_PARM_DESC(debug, "PA Semi MAC bit
 
 static struct pasdma_status *dma_status;
 
-static unsigned int read_iob_reg(struct pasemi_mac *mac, unsigned int reg)
-{
-	return in_le32(mac->iob_regs+reg);
-}
-
 static void write_iob_reg(struct pasemi_mac *mac, unsigned int reg,
 			  unsigned int val)
 {
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
ia64-perfmon-remove-exit_pfm_fs.patch
git-ieee1394.patch
git-infiniband.patch
git-libata-all.patch
git-net.patch
git-s390.patch
sched-use-show_regs-to-improve-__schedule_bug-output.patch
git-scsi-misc.patch
mpt-fusion-shut-up-uninitialized-variable.patch
git-block.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
