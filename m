From: akpm@linux-foundation.org
Subject: - remove-unused-kernel-config-option-zisofs_fs.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:01 -0800
Message-ID: <200702112255.l1BMt1vT016287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846AbXBKWzD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Remove unused kernel config option ZISOFS_FS
has been removed from the -mm tree.  Its filename was
     remove-unused-kernel-config-option-zisofs_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unused kernel config option ZISOFS_FS
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the kernel config option ZISOFS_FS, since it appears that the actual
option is simply ZISOFS.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/Kconfig~remove-unused-kernel-config-option-zisofs_fs fs/Kconfig
--- a/fs/Kconfig~remove-unused-kernel-config-option-zisofs_fs
+++ a/fs/Kconfig
@@ -674,12 +674,6 @@ config ZISOFS
 	  necessary to create such a filesystem.  Say Y here if you want to be
 	  able to read such compressed CD-ROMs.
 
-config ZISOFS_FS
-# for fs/nls/Config.in
-	tristate
-	depends on ZISOFS
-	default ISO9660_FS
-
 config UDF_FS
 	tristate "UDF file system support"
 	help
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
