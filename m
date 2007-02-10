From: akpm@linux-foundation.org
Subject: - remove-unused-kernel-config-option-lcd_device.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:27:36 -0800
Message-ID: <200702100527.l1A5RaDh004677@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbXBJF2R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:28:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Remove unused kernel config option LCD_DEVICE
has been removed from the -mm tree.  Its filename was
     remove-unused-kernel-config-option-lcd_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unused kernel config option LCD_DEVICE
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused kernel config option LCD_DEVICE.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Antonino Daplas <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/backlight/Kconfig |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/video/backlight/Kconfig~remove-unused-kernel-config-option-lcd_device drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~remove-unused-kernel-config-option-lcd_device
+++ a/drivers/video/backlight/Kconfig
@@ -37,11 +37,6 @@ config LCD_CLASS_DEVICE
 	  To have support for your specific LCD panel you will have to
 	  select the proper drivers which depend on this option.
 
-config LCD_DEVICE
-	bool
-	depends on LCD_CLASS_DEVICE
-	default y
-
 config BACKLIGHT_CORGI
 	tristate "Sharp Corgi Backlight Driver (SL Series)"
 	depends on BACKLIGHT_DEVICE && PXA_SHARPSL
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-avr32.patch
git-dvb.patch
git-input.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-mips.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
remove-final-references-to-deprecated-map_anon-page-protection-flag.patch
uml-fix-apparent-config_64_bit-typo.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-paride_parport.patch
fix-apparent-typo-config_lockdep_debug.patch
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
