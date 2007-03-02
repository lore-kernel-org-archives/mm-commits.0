From: akpm@linux-foundation.org
Subject: + safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch added to -mm tree
Date: Thu, 01 Mar 2007 17:27:43 -0800
Message-ID: <200703020127.l221Rha1028717@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422699AbXCBB1q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 20:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clameter@engr.sgi.com


The patch titled
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak
has been added to the -mm tree.  Its filename is
     safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak
From: Andrew Morton <akpm@linux-foundation.org>

yes?

Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 page_alloc.c   |    0 
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN init/main.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak init/main.c
diff -puN kernel/sched.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak kernel/sched.c
--- a/kernel/sched.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak
+++ a/kernel/sched.c
@@ -6912,7 +6912,7 @@ int in_sched_functions(unsigned long add
 }
 
 /* Number of possible processor ids */
-int nr_cpu_ids = NR_CPUS;
+int nr_cpu_ids __read_mostly = NR_CPUS;
 EXPORT_SYMBOL(nr_cpu_ids);
 
 void __init sched_init(void)
diff -puN lib/cpumask.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak lib/cpumask.c
diff -puN mm/page_alloc.c~safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak mm/page_alloc.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
cyclades-return-closing_wait.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-hid-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
git-md-accel-vs-md.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
