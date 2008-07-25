From: akpm@linux-foundation.org
Subject: - remove-unused-include-linux-direnths.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:57:39 -0700
Message-ID: <200807252257.m6PMvdDf003207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560AbYGYW6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     remove unused #include <linux/dirent.h>'s
has been removed from the -mm tree.  Its filename was
     remove-unused-include-linux-direnths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove unused #include <linux/dirent.h>'s
From: Adrian Bunk <bunk@kernel.org>

Remove some unused #include <linux/dirent.h>'s.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/linux32.c |    1 -
 fs/compat_ioctl.c          |    1 -
 fs/smbfs/cache.c           |    1 -
 fs/smbfs/proc.c            |    1 -
 include/linux/nfsd/nfsd.h  |    1 -
 5 files changed, 5 deletions(-)

diff -puN arch/mips/kernel/linux32.c~remove-unused-include-linux-direnths arch/mips/kernel/linux32.c
--- a/arch/mips/kernel/linux32.c~remove-unused-include-linux-direnths
+++ a/arch/mips/kernel/linux32.c
@@ -11,7 +11,6 @@
 #include <linux/file.h>
 #include <linux/smp_lock.h>
 #include <linux/highuid.h>
-#include <linux/dirent.h>
 #include <linux/resource.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
diff -puN fs/compat_ioctl.c~remove-unused-include-linux-direnths fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~remove-unused-include-linux-direnths
+++ a/fs/compat_ioctl.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/raid/md.h>
 #include <linux/kd.h>
-#include <linux/dirent.h>
 #include <linux/route.h>
 #include <linux/in6.h>
 #include <linux/ipv6_route.h>
diff -puN fs/smbfs/cache.c~remove-unused-include-linux-direnths fs/smbfs/cache.c
--- a/fs/smbfs/cache.c~remove-unused-include-linux-direnths
+++ a/fs/smbfs/cache.c
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/dirent.h>
 #include <linux/smb_fs.h>
 #include <linux/pagemap.h>
 #include <linux/net.h>
diff -puN fs/smbfs/proc.c~remove-unused-include-linux-direnths fs/smbfs/proc.c
--- a/fs/smbfs/proc.c~remove-unused-include-linux-direnths
+++ a/fs/smbfs/proc.c
@@ -16,7 +16,6 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/dcache.h>
-#include <linux/dirent.h>
 #include <linux/nls.h>
 #include <linux/smp_lock.h>
 #include <linux/net.h>
diff -puN include/linux/nfsd/nfsd.h~remove-unused-include-linux-direnths include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~remove-unused-include-linux-direnths
+++ a/include/linux/nfsd/nfsd.h
@@ -12,7 +12,6 @@
 
 #include <linux/types.h>
 #include <linux/unistd.h>
-#include <linux/dirent.h>
 #include <linux/fs.h>
 #include <linux/posix_acl.h>
 #include <linux/mount.h>
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

