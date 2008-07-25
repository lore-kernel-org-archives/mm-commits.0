From: akpm@linux-foundation.org
Subject: - unexport-uts_sem.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:42 -0700
Message-ID: <200807252302.m6PN2gkS003846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564AbYGYXGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     unexport uts_sem
has been removed from the -mm tree.  Its filename was
     unexport-uts_sem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: unexport uts_sem
From: Adrian Bunk <bunk@kernel.org>

With the removal of the Solaris binary emulation the export of
uts_sem became unused.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/sys.c~unexport-uts_sem kernel/sys.c
--- a/kernel/sys.c~unexport-uts_sem
+++ a/kernel/sys.c
@@ -1343,8 +1343,6 @@ EXPORT_SYMBOL(in_egroup_p);
 
 DECLARE_RWSEM(uts_sem);
 
-EXPORT_SYMBOL(uts_sem);
-
 asmlinkage long sys_newuname(struct new_utsname __user * name)
 {
 	int errno = 0;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
uninline-arch_pick_mmap_layout.patch
include-video-atmel_lcdch-must-include-linux-workqueueh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
drm-make-drm_minors_cleanup-static.patch
make-cgroup_seqfile_release-static.patch
make-pnp_add_card_id-static.patch
make-parport_cs_release-static.patch
make-mm-sparsec-make-a-function-static.patch
mm-allocpercpuc-make-4-functions-static.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
drivers-char-rtcc-make-2-functions-static.patch
make-init-do_mountsc-root_device_name-static.patch
make-macfb_setup-static.patch
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

