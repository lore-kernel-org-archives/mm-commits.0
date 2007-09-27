From: akpm@linux-foundation.org
Subject: - mv643xx_eth-remove-redundant-multiple-initialization.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:32 -0700
Message-ID: <200709270143.l8R1hWKn013971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630AbXI0BvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     mv643xx_eth: Remove redundant multiple initialization
has been removed from the -mm tree.  Its filename was
     mv643xx_eth-remove-redundant-multiple-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mv643xx_eth: Remove redundant multiple initialization
From: Satyam Sharma <satyam@infradead.org>

Of ethtool_ops->get_ethtool_stats.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/mv643xx_eth.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/net/mv643xx_eth.c~mv643xx_eth-remove-redundant-multiple-initialization drivers/net/mv643xx_eth.c
--- a/drivers/net/mv643xx_eth.c~mv643xx_eth-remove-redundant-multiple-initialization
+++ a/drivers/net/mv643xx_eth.c
@@ -2746,7 +2746,6 @@ static const struct ethtool_ops mv643xx_
 	.get_sset_count		= mv643xx_get_sset_count,
 	.get_ethtool_stats      = mv643xx_get_ethtool_stats,
 	.get_strings            = mv643xx_get_strings,
-	.get_ethtool_stats      = mv643xx_get_ethtool_stats,
 	.nway_reset		= mv643xx_eth_nway_restart,
 };
 
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
git-net-fix-spidernet-build.patch
iseries_veth-kill-unused-variable.patch
spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch
pasemi_mac-build-fix-after-recent-netdev-stats.patch
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
