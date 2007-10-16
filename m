From: akpm@linux-foundation.org
Subject: - radeon_driver_vblank_do_wait-static.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:39 -0700
Message-ID: <200710162042.l9GKgd5j015901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760411AbXJPVCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     radeon_driver_vblank_do_wait() static
has been removed from the -mm tree.  Its filename was
     radeon_driver_vblank_do_wait-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: radeon_driver_vblank_do_wait() static
From: Adrian Bunk <bunk@stusta.de>

radeon_driver_vblank_do_wait() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/radeon_irq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/drm/radeon_irq.c~radeon_driver_vblank_do_wait-static drivers/char/drm/radeon_irq.c
--- a/drivers/char/drm/radeon_irq.c~radeon_driver_vblank_do_wait-static
+++ a/drivers/char/drm/radeon_irq.c
@@ -144,8 +144,8 @@ static int radeon_wait_irq(struct drm_de
 	return ret;
 }
 
-int radeon_driver_vblank_do_wait(struct drm_device * dev, unsigned int *sequence,
-				 int crtc)
+static int radeon_driver_vblank_do_wait(struct drm_device * dev,
+					unsigned int *sequence, int crtc)
 {
 	drm_radeon_private_t *dev_priv =
 	    (drm_radeon_private_t *) dev->dev_private;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
git-alsa.patch
git-kvm.patch
remove-fs-jffs2-ioctlc.patch
parisc-extern-inline-static-inline.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-ipwireless_cs.patch
maps2-add-proc-kpagemap-interface.patch
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
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
