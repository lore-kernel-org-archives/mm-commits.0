From: akpm@linux-foundation.org
Subject: - xen-paravirt-core-xen-implementation-fix.patch removed from -mm tree
Date: Wed, 21 Feb 2007 18:36:38 -0800
Message-ID: <200702220236.l1M2ac4H002026@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34218 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbXBVCgs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 21:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeremy@goop.org, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt-core-xen-implementation-fix
has been removed from the -mm tree.  Its filename was
     xen-paravirt-core-xen-implementation-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: xen-paravirt-core-xen-implementation-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/xen/time.c~xen-paravirt-core-xen-implementation-fix arch/i386/xen/time.c
--- a/arch/i386/xen/time.c~xen-paravirt-core-xen-implementation-fix
+++ a/arch/i386/xen/time.c
@@ -304,7 +304,7 @@ static struct clocksource xen_clocksourc
 	.mask = ~0,
 	.mult = 1<<XEN_SHIFT,		/* time directly in nanoseconds */
 	.shift = XEN_SHIFT,
-	.is_continuous = 1
+	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void init_missing_ticks_accounting(int cpu)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
git-md-accel-vs-md.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
