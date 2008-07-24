From: akpm@linux-foundation.org
Subject: - config_sound_wm97xx-remove-stale-makefile-line.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:27:02 -0700
Message-ID: <200807242327.m6ONR2Hb011133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945AbYGXX1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:27:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     CONFIG_SOUND_WM97XX: remove stale makefile line
has been removed from the -mm tree.  Its filename was
     config_sound_wm97xx-remove-stale-makefile-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CONFIG_SOUND_WM97XX: remove stale makefile line
From: Adrian Bunk <bunk@kernel.org>

The driver is gone for a long time.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/Makefile |    2 --
 1 file changed, 2 deletions(-)

diff -puN sound/oss/Makefile~config_sound_wm97xx-remove-stale-makefile-line sound/oss/Makefile
--- a/sound/oss/Makefile~config_sound_wm97xx-remove-stale-makefile-line
+++ a/sound/oss/Makefile
@@ -31,8 +31,6 @@ obj-$(CONFIG_SOUND_VWSND)	+= vwsnd.o
 obj-$(CONFIG_SOUND_AU1550_AC97)	+= au1550_ac97.o ac97_codec.o
 obj-$(CONFIG_SOUND_BCM_CS4297A)	+= swarm_cs4297a.o
 
-obj-$(CONFIG_SOUND_WM97XX)	+= ac97_plugin_wm97xx.o
-
 obj-$(CONFIG_DMASOUND)		+= dmasound/
 
 # Declare multi-part drivers.
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

