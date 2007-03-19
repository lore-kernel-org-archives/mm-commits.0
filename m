From: akpm@linux-foundation.org
Subject: + git-alsa-fixup.patch added to -mm tree
Date: Mon, 19 Mar 2007 15:28:59 -0700
Message-ID: <200703192230.l2JMUv9o019455@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbXCSWbA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:31:00 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l2JMUxcD011154
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 19 Mar 2007 15:30:59 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-alsa-fixup
has been added to the -mm tree.  Its filename is
     git-alsa-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-alsa-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/patch_sigmatel.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN sound/pci/hda/patch_sigmatel.c~git-alsa-fixup sound/pci/hda/patch_sigmatel.c
--- a/sound/pci/hda/patch_sigmatel.c~git-alsa-fixup
+++ a/sound/pci/hda/patch_sigmatel.c
@@ -530,17 +530,7 @@ static unsigned int macbook_pro_v1_pin_c
 	0x02a19320, 0x400000fb
 };
 
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-static unsigned int macbook_pro_v1_pin_configs[10] = {
-	0x0321e230, 0x03a1e020, 0x9017e110, 0x01014010,
-	0x01a19021, 0x0381e021, 0x1345e240, 0x13c5e22e,
-	0x02a19320, 0x400000fb
-};
-
 static unsigned int macbook_pro_v2_pin_configs[10] = {
-=======
-static unsigned int macbook_pro_v2_pin_configs[10] = {
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 	0x0221401f, 0x90a70120, 0x01813024, 0x01014010,
 	0x400000fd, 0x01016011, 0x1345e240, 0x13c5e22e,
 	0x400000fc, 0x400000fb,
@@ -550,17 +540,10 @@ static unsigned int *stac922x_brd_tbl[ST
 	[STAC_D945_REF] = ref922x_pin_configs,
 	[STAC_D945GTP3] = d945gtp3_pin_configs,
 	[STAC_D945GTP5] = d945gtp5_pin_configs,
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-	[STAC_MACMINI] = d945gtp5_pin_configs,
-	[STAC_MACBOOK] = macbook_pin_configs,
-	[STAC_MACBOOK_PRO_V1] = macbook_pro_v1_pin_configs,
-	[STAC_MACBOOK_PRO_V2] = macbook_pro_v2_pin_configs,
-=======
 	[STAC_MACMINI] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK_PRO_V1] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK_PRO_V2] = macbook_pro_v2_pin_configs,
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 };
 
 static const char *stac922x_models[STAC_922X_MODELS] = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
prevent-acpi-quirk-warning-mass-spamming-in-logs-tidy.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lists-add-list-splice-tail.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
git-alsa-fixup.patch
