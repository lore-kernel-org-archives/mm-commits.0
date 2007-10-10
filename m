From: akpm@linux-foundation.org
Subject: - include-linux-kbuild-remove-duplicate-entries.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:38 -0700
Message-ID: <200710102110.l9ALAcmi025946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42774 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275AbXJJVVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/Kbuild: remove duplicate entries
has been removed from the -mm tree.  Its filename was
     include-linux-kbuild-remove-duplicate-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/linux/Kbuild: remove duplicate entries
From: Adrian Bunk <bunk@stusta.de>

This patch removes three headers from header-y that were also listed as
unifdef-y.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    3 ---
 1 file changed, 3 deletions(-)

diff -puN include/linux/Kbuild~include-linux-kbuild-remove-duplicate-entries include/linux/Kbuild
--- a/include/linux/Kbuild~include-linux-kbuild-remove-duplicate-entries
+++ a/include/linux/Kbuild
@@ -78,7 +78,6 @@ header-y += if_arcnet.h
 header-y += if_bonding.h
 header-y += if_cablemodem.h
 header-y += if_fc.h
-header-y += if_fddi.h
 header-y += if.h
 header-y += if_hippi.h
 header-y += if_infiniband.h
@@ -121,7 +120,6 @@ header-y += nl80211.h
 header-y += oom.h
 header-y += param.h
 header-y += pci_regs.h
-header-y += personality.h
 header-y += pfkeyv2.h
 header-y += pg.h
 header-y += phantom.h
@@ -159,7 +157,6 @@ header-y += video_decoder.h
 header-y += video_encoder.h
 header-y += videotext.h
 header-y += vt.h
-header-y += wireless.h
 header-y += x25.h
 
 unifdef-y += acct.h
_

Patches currently in -mm which might be from bunk@stusta.de are

slow-down-printk-during-boot.patch
git-acpi.patch
git-alsa.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-net.patch
git-backlight.patch
git-nfs.patch
parisc-extern-inline-static-inline.patch
git-scsi-misc.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
script-to-check-for-undefined-kconfig-symbols.patch
drivers-block-ccissc-fix-check-after-use.patch
dontdiff-update-based-on-gitignore-updates.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
