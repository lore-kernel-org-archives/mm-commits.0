From: akpm@linux-foundation.org
Subject: - unexport-fb_prepare_logo.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:42:41 -0700
Message-ID: <200710162042.l9GKgfif015904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936012AbXJPVHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     unexport fb_prepare_logo
has been removed from the -mm tree.  Its filename was
     unexport-fb_prepare_logo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unexport fb_prepare_logo
From: Adrian Bunk <bunk@stusta.de>

The logo code is not and should not be used by modules.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/fbmem.c~unexport-fb_prepare_logo drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~unexport-fb_prepare_logo
+++ a/drivers/video/fbmem.c
@@ -1663,7 +1663,6 @@ EXPORT_SYMBOL(register_framebuffer);
 EXPORT_SYMBOL(unregister_framebuffer);
 EXPORT_SYMBOL(num_registered_fb);
 EXPORT_SYMBOL(registered_fb);
-EXPORT_SYMBOL(fb_prepare_logo);
 EXPORT_SYMBOL(fb_show_logo);
 EXPORT_SYMBOL(fb_set_var);
 EXPORT_SYMBOL(fb_blank);
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
