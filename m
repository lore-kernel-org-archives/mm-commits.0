From: akpm@linux-foundation.org
Subject: - git-md-accel-fix.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:47 -0800
Message-ID: <200702170716.l1H7GlIb021740@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946508AbXBQHQt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-md-accel-fix
has been removed from the -mm tree.  Its filename was
     git-md-accel-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-md-accel-fix
From: Andrew Morton <akpm@linux-foundation.org>

This looks like it'll oops nicely.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioatdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/ioatdma.c~git-md-accel-fix drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~git-md-accel-fix
+++ a/drivers/dma/ioatdma.c
@@ -492,7 +492,7 @@ static void ioat_dma_dependency_added(st
 	spin_lock_bh(&ioat_chan->desc_lock);
 	if (ioat_chan->pending == 0) {
 		spin_unlock_bh(&ioat_chan->desc_lock);
-		ioat_dma_memcpy_cleanup(chan);
+		ioat_dma_memcpy_cleanup(ioat_chan);
 	} else
 		spin_unlock_bh(&ioat_chan->desc_lock);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-arm.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
sis-warning-fixes.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-s390.patch
git-scsi-misc.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
