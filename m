From: akpm@linux-foundation.org
Subject: - drm-make-drm_minors_cleanup-static.patch removed from -mm tree
Date: Fri, 11 Jul 2008 16:24:44 -0700
Message-ID: <200807112324.m6BNOiBR010009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752315AbYGKXZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 19:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drm: make drm_minors_cleanup() static
has been removed from the -mm tree.  Its filename was
     drm-make-drm_minors_cleanup-static.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drm: make drm_minors_cleanup() static
From: Adrian Bunk <bunk@kernel.org>

Male the needlessly global drm_minors_cleanup() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/drm_drv.c~drm-make-drm_minors_cleanup-static drivers/char/drm/drm_drv.c
--- a/drivers/char/drm/drm_drv.c~drm-make-drm_minors_cleanup-static
+++ a/drivers/char/drm/drm_drv.c
@@ -318,7 +318,7 @@ static void drm_cleanup(struct drm_devic
 		DRM_ERROR("Cannot unload module\n");
 }
 
-int drm_minors_cleanup(int id, void *ptr, void *data)
+static int drm_minors_cleanup(int id, void *ptr, void *data)
 {
 	struct drm_minor *minor = ptr;
 	struct drm_device *dev;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
drm-make-drm_minors_cleanup-static.patch
git-dvb.patch
git-input.patch
git-jfs.patch
git-kbuild-next.patch
git-kvm.patch
m32r-remove-the-unused-nohighmem-option.patch
git-async-tx.patch
git-mmc.patch
git-mtd.patch
git-net-next.patch
git-nfs.patch
git-nfsd.patch
git-pci-next.patch
git-sh.patch
git-scsi-misc.patch
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
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
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
rtc-bcd-codeshrink.patch
video-sis-remove-compat-code.patch
drivers-video-amifbc-cleanups.patch
minix-remove-no_truncate-code.patch
jbd-unexport-journal_update_superblock.patch
coda-remove-coda_fs_old_api.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
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
video-console-sticonrec-make-code-static.patch
video-console-sticonrec-make-code-static-checkpatch-fixes.patch
video-stifbc-make-2-functions-static.patch
reiser4.patch

