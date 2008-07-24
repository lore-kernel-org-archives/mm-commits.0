From: akpm@linux-foundation.org
Subject: - alpha-remove-the-unused-alpha_core_agp-option.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:07 -0700
Message-ID: <200807242325.m6ONP7be010852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755563AbYGXXZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ink@jurassic.park.msu.ru, rpjday@crashcourse.ca, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: remove the unused ALPHA_CORE_AGP option
has been removed from the -mm tree.  Its filename was
     alpha-remove-the-unused-alpha_core_agp-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: remove the unused ALPHA_CORE_AGP option
From: Adrian Bunk <bunk@kernel.org>

The real option is named AGP_ALPHA_CORE.

Reviewed-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-remove-the-unused-alpha_core_agp-option arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-remove-the-unused-alpha_core_agp-option
+++ a/arch/alpha/Kconfig
@@ -333,11 +333,6 @@ config PCI_SYSCALL
 config IOMMU_HELPER
 	def_bool PCI
 
-config ALPHA_CORE_AGP
-	bool
-	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL
-	default y
-
 config ALPHA_NONAME
 	bool
 	depends on ALPHA_BOOK1 || ALPHA_NONAME_CH
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
init-do_mountsc-should-include-linux-initrdh.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
asm-generic-int-ll64h-always-provide-__su64.patch
remove-some-more-tipar-bits.patch
include-linux-kernelh-userspace-header-cleanup.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
remove-the-in-kernel-struct-dirent64.patch
remove-unused-include-linux-direnths.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
pty-remove-unused-unix98_pty_count-options.patch
proper-extern-for-mwave_s_mdd.patch
if-0-hpet_unregister.patch
unexport-proc_clear_tty.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proper-pidhashmap_init-prototypes.patch
unexport-uts_sem.patch
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

