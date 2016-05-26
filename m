From: akpm@linux-foundation.org
Subject: [obsolete] fs-nfs-pnfsc-fix-build.patch removed from -mm tree
Date: Thu, 26 May 2016 15:39:11 -0700
Message-ID: <57477b0f.J2g/em5iMfykhmkM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbcEZWjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:39:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nfs/pnfs.c: fix build
has been removed from the -mm tree.  Its filename was
     fs-nfs-pnfsc-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/nfs/pnfs.c: fix build

randomly


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfs/pnfs.c~fs-nfs-pnfsc-fix-build fs/nfs/pnfs.c
--- a/fs/nfs/pnfs.c~fs-nfs-pnfsc-fix-build
+++ a/fs/nfs/pnfs.c
@@ -1547,7 +1547,7 @@ lookup_again:
 		goto out_unlock;
 	}
 
-	lseg = pnfs_find_lseg(lo, &arg);
+	lseg = pnfs_find_lseg(lo, &arg, true);
 	if (lseg) {
 		trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				PNFS_UPDATE_LAYOUT_FOUND_CACHED);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-pinctrl-intel-pinctrl-baytrailc-fix-build-with-gcc-44.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
oom_reaper-close-race-with-exiting-task-checkpatch-fixes.patch
mm-cma-silence-warnings-due-to-max-usage-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-fix.patch
mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites-checkpatch-fixes.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
fs-nfs-nfs4statec-work-around-gcc-44-union-initialization-bug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
a.patch

