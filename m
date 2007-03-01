From: akpm@linux-foundation.org
Subject: + log-reason-why-tsc-was-marked-unstable-fix.patch added to -mm tree
Date: Wed, 28 Feb 2007 20:34:46 -0800
Message-ID: <200703010436.l214aKYN004723@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55278 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbXCAEgo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 23:36:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     log-reason-why-tsc-was-marked-unstable-fix
has been added to the -mm tree.  Its filename is
     log-reason-why-tsc-was-marked-unstable-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: log-reason-why-tsc-was-marked-unstable-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cyrix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/cyrix.c~log-reason-why-tsc-was-marked-unstable-fix arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~log-reason-why-tsc-was-marked-unstable-fix
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -279,7 +279,7 @@ static void __cpuinit init_cyrix(struct 
 		 */  
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
 	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
-			mark_tsc_unstable();
+			mark_tsc_unstable("Cyrix 5510/5520 detected");
 	}
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
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
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
log-reason-why-tsc-was-marked-unstable-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
