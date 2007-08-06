From: akpm@linux-foundation.org
Subject: - drivers-acpi-sbsc-remove-dead-code.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:52:55 -0700
Message-ID: <200708060752.l767qtQD016289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45254 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757723AbXHFHxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, len.brown@intel.com, vladimir.p.lebedev@intel.com, mm-commits@vger.kernel.org


The patch titled
     drivers/acpi/sbs.c: remove dead code
has been removed from the -mm tree.  Its filename was
     drivers-acpi-sbsc-remove-dead-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/acpi/sbs.c: remove dead code
From: Adrian Bunk <bunk@stusta.de>

Remove dead code spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Vladimir Lebedev <vladimir.p.lebedev@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sbs.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/acpi/sbs.c~drivers-acpi-sbsc-remove-dead-code drivers/acpi/sbs.c
--- a/drivers/acpi/sbs.c~drivers-acpi-sbsc-remove-dead-code
+++ a/drivers/acpi/sbs.c
@@ -1415,7 +1415,7 @@ static int acpi_sbs_update_run(struct ac
 	char dir_name[32];
 	int do_battery_init = 0, do_ac_init = 0;
 	int old_remaining_capacity = 0;
-	int update_ac = 1, update_battery = 1;
+	int update_battery = 1;
 	int up_tm = update_time;
 
 	if (sbs_zombie(sbs)) {
@@ -1435,10 +1435,6 @@ static int acpi_sbs_update_run(struct ac
 
 	sbs->run_cnt++;
 
-	if (!update_ac && !update_battery) {
-		goto end;
-	}
-
 	old_ac_present = sbs->ac.ac_present;
 
 	result = acpi_ac_get_present(sbs);
_

Patches currently in -mm which might be from bunk@stusta.de are

slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
git-v9fs.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
git-cryptodev.patch
kernel-auditscc-fix-an-off-by-one.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
