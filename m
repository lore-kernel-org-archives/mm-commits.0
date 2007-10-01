From: akpm@linux-foundation.org
Subject: - iseries_veth-kill-unused-variable.patch removed from -mm tree
Date: Mon, 01 Oct 2007 00:14:26 -0700
Message-ID: <200710010714.l917EQ6l004530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446AbXJAHOj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2007 03:14:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     iseries_veth: Kill unused variable
has been removed from the -mm tree.  Its filename was
     iseries_veth-kill-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: iseries_veth: Kill unused variable
From: Satyam Sharma <satyam@infradead.org>

drivers/net/iseries_veth.c: In function 'veth_transmit_to_many':
drivers/net/iseries_veth.c:1174: warning: unused variable 'port'

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/iseries_veth.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/iseries_veth.c~iseries_veth-kill-unused-variable drivers/net/iseries_veth.c
--- a/drivers/net/iseries_veth.c~iseries_veth-kill-unused-variable
+++ a/drivers/net/iseries_veth.c
@@ -1171,7 +1171,6 @@ static void veth_transmit_to_many(struct
 					  HvLpIndexMap lpmask,
 					  struct net_device *dev)
 {
-	struct veth_port *port = (struct veth_port *) dev->priv;
 	int i, success, error;
 
 	success = error = 0;
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
