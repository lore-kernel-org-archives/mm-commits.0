From: akpm@linux-foundation.org
Subject: - e1000-fix-shared-interrupt-warning-message-fix.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:14:48 -0800
Message-ID: <200702180214.l1I2Ems7008310@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993083AbXBRCOu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:14:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, auke-jan.h.kok@intel.com, jesse.brandeburg@intel.com, mm-commits@vger.kernel.org


The patch titled
     e1000-fix-shared-interrupt-warning-message-fix
has been removed from the -mm tree.  Its filename was
     e1000-fix-shared-interrupt-warning-message-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: e1000-fix-shared-interrupt-warning-message-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-fix-shared-interrupt-warning-message-fix drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-fix-shared-interrupt-warning-message-fix
+++ a/drivers/net/e1000/e1000_main.c
@@ -1441,7 +1441,6 @@ e1000_open(struct net_device *netdev)
 
 err_req_irq:
 	e1000_down(adapter);
-	e1000_free_irq(adapter);
 err_up:
 	e1000_power_down_phy(adapter);
 	e1000_free_all_rx_resources(adapter);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
xfs-warning-fix.patch
machzwd-warning-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
sony-laptop-fix-uninitialised-variable.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
git-mtd.patch
onenand_base-warning-fix.patch
sc520cdp-warning-fix.patch
netsc520-warning-fix.patch
ck804xrom-warning-fix.patch
esb2rom-warning-fixes.patch
amd76xrom-warning-fix.patch
ichxrom-warning-fix.patch
jffs2-warning-fixes.patch
cafe-warning-fix.patch
git-netdev-all.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fixup.patch
git-wireless-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
mincore-warning-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fb-sm501-framebuffer-driver-5-fix.patch
