From: akpm@linux-foundation.org
Subject: + remove-unused-include-linux-direnths.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:37:05 -0700
Message-ID: <200806302137.m5ULb5kJ026662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933146AbYF3Vh6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:37:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, ralf@linux-mips.org


The patch titled
     remove unused #include <linux/dirent.h>'s
has been added to the -mm tree.  Its filename is
     remove-unused-include-linux-direnths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
firmware-fix-the-request_firmware-dummy.patch
remove-drivers-acorn-char-defkeymap-l7200c.patch
drm-make-drm_minors_cleanup-static.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
scsi-make-struct-scsi_hosttarget_type-static.patch
git-xtensa.patch
mm-migratec-should-include-linux-syscallsh.patch
mm-vmstatc-proper-externs.patch
mm-hugetlbc-fix-duplicate-variable.patch
mm-page_allocc-cleanups.patch
mm-make-register_page_bootmem_info_section-static.patch
remove-include-asm-h8300-keyboardh.patch
alpha-remove-the-unused-alpha_core_agp-option.patch
remove-include-linux-pm_legacyh.patch
remove-the-v850-port.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
remove-the-oss-trident-driver.patch
config_sound_wm97xx-remove-stale-makefile-line.patch
serial-8250_gscc-add-module_license.patch
video-sis-remove-compat-code.patch
drivers-video-amifbc-cleanups.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
remove-is_tty.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
parport-sharec-proper-externs.patch
tpm_biosc-make-2-structs-static.patch
make-cgroup_seqfile_release-static.patch
make-kprobe_blacklist-static.patch
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
reiser4.patch

