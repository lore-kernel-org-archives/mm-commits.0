From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-e752x-reversed-csrows-fix.patch removed from -mm tree
Date: Thu, 19 Jul 2007 01:39:38 -0700
Message-ID: <200707190839.l6J8dcVL022456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757053AbXGSIkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 04:40:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dougthompson@xmission.com, greg@kroah.com, mgrondona@llnl.gov, mm-commits@vger.kernel.org


The patch titled
     drivers-edac-fix-e752x-reversed-csrows-fix
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-e752x-reversed-csrows-fix.patch

This patch was dropped because it was folded into drivers-edac-fix-e752x-reversed-csrows.patch

------------------------------------------------------
Subject: drivers-edac-fix-e752x-reversed-csrows-fix
From: Andrew Morton <akpm@linux-foundation.org>

unneeded (and undesirable) cast of void*

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: Mark Grondona <mgrondona@llnl.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/e752x_edac.c~drivers-edac-fix-e752x-reversed-csrows-fix drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-fix-e752x-reversed-csrows-fix
+++ a/drivers/edac/e752x_edac.c
@@ -775,7 +775,7 @@ static inline int dual_channel_active(u1
  */
 static inline int remap_csrow_index(struct mem_ctl_info *mci, int index)
 {
-	struct e752x_pvt *pvt = (struct e752x_pvt *) mci->pvt_info;
+	struct e752x_pvt *pvt = mci->pvt_info;
 
 	if (!pvt->map_type)
 		return (7 - index);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-2.patch
freezer-run-show_state-when-freezing-times-out.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
pm-disable-usermode-helper-before-hibernation-and-suspend.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
dequeue_huge_page-warning-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
drivers-edac-new-i82975x-driver-fix.patch
kernel-sysctlc-finish-off-the-warning-comments.patch
afs-build-fix.patch
