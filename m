From: akpm@linux-foundation.org
Subject: - drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch removed from -mm tree
Date: Tue, 11 Sep 2007 20:46:48 -0700
Message-ID: <200709120346.l8C3kmXL014719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41378 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757336AbXILDrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:47:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, adaplas@pol.net, eugeneteo@kernel.sg, mm-commits@vger.kernel.org


The patch titled
     drivers/video/geode/lxfb_core.c: Fix build warning
has been removed from the -mm tree.  Its filename was
     drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: drivers/video/geode/lxfb_core.c: Fix build warning
From: Satyam Sharma <satyam@infradead.org>

drivers/video/geode/lxfb_core.c: In function 'lxfb_setup':
drivers/video/geode/lxfb_core.c:564: warning: unused variable 'opt'

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/video/geode/lxfb_core.c~drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix
+++ a/drivers/video/geode/lxfb_core.c
@@ -561,8 +561,6 @@ static struct pci_driver lxfb_driver = {
 #ifndef MODULE
 static int __init lxfb_setup(char *options)
 {
-	char *opt;
-
 	if (!options || !*options)
 		return 0;
 
_

Patches currently in -mm which might be from satyam@infradead.org are

h8-300-fix-misnamed-config_blkdev_reserve_address-kconfig-variable.patch
cpufreq-mark-hotplug-notifier-callback-as-__cpuinit.patch
cpufreq-implement-config_cpu_freq-stub-for.patch
cpufreq_stats-misc-cpuinit-section-annotations.patch
git-hwmon.patch
ia64-tree-wide-misc-__cpuinitdata-init-exit.patch
git-ieee1394.patch
ehca_irq-misc-cpuinit-section-annotations-and-ifdef-cleanups.patch
git-netdev-all.patch
git-net.patch
git-s390.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
ll_rw_blk-blk_cpu_notifier-should-be-__cpuinitdata.patch
git-watchdog.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
intel_cacheinfo-call-cache_add_dev-from-cache_sysfs_init.patch
therm_throtc-fix-section-mismatch.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
drivers-video-geode-lxfb_corec-fix-lxfb_setup-warning-fix.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
i386-cpuid-misc-cpuinit-annotations.patch
