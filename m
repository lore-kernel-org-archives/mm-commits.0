From: akpm@linux-foundation.org
Subject: + fs-nfs-pnfsc-fix-build.patch added to -mm tree
Date: Thu, 26 May 2016 15:34:53 -0700
Message-ID: <57477a0d.rx+TuRfMrz5iuTi1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbcEZWey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2016 18:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nfs/pnfs.c: fix build
has been added to the -mm tree.  Its filename is
     fs-nfs-pnfsc-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-nfs-pnfsc-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-nfs-pnfsc-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
fs-nfs-pnfsc-fix-build.patch

