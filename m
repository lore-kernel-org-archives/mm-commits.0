From: akpm@linux-foundation.org
Subject: - init-do_mountsc-should-include-linux-initrdh.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:54:15 -0700
Message-ID: <200807252254.m6PMsF3s002797@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbYGYWyY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:54:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     init/do_mounts.c should #include <linux/initrd.h>
has been removed from the -mm tree.  Its filename was
     init-do_mountsc-should-include-linux-initrdh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: init/do_mounts.c should #include <linux/initrd.h>
From: Adrian Bunk <bunk@kernel.org>

Every file should include the headers containing the externs for its
global code (in this case for rd_doload).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/do_mounts.c~init-do_mountsc-should-include-linux-initrdh init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-should-include-linux-initrdh
+++ a/init/do_mounts.c
@@ -12,6 +12,7 @@
 #include <linux/device.h>
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/initrd.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
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

