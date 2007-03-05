From: akpm@linux-foundation.org
Subject: - git-kvm-fixup.patch removed from -mm tree
Date: Sun, 04 Mar 2007 16:31:20 -0800
Message-ID: <200703050031.l250VK3K005033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXCEAbW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Mar 2007 19:31:22 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l250VLq8001152
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 4 Mar 2007 16:31:21 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-kvm-fixup
has been removed from the -mm tree.  Its filename was
     git-kvm-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-kvm-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~git-kvm-fixup drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~git-kvm-fixup
+++ a/drivers/kvm/kvm_main.c
@@ -2362,7 +2362,7 @@ static int kvm_cpu_hotplug(struct notifi
 	int cpu = (long)v;
 
 	switch (val) {
-	case CPU_DEAD:
+	case CPU_DOWN_PREPARE:
 	case CPU_UP_CANCELED:
 		decache_vcpus_on_cpu(cpu);
 		break;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cyclades-return-closing_wait.patch
md-fix-for-raid6-reshape-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-kvm-fixup.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
ide-ide-fix-pmac-breakage-fix.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
