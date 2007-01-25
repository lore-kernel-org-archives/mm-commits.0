From: akpm@osdl.org
Subject: + remove-unused-kernel-config-option-lcd_device.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:35:20 -0800
Message-ID: <200701250535.l0P5ZKq0006964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47899 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244AbXAYFfh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:35:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     Remove unused kernel config option LCD_DEVICE
has been added to the -mm tree.  Its filename is
     remove-unused-kernel-config-option-lcd_device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-unused-kernel-config-option-x86_xadd.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
remove-a-couple-final-references-to-obsolete-verify_area.patch
remove-the-last-reference-to-rwlock_is_locked-macro.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
remove-final-reference-to-superfluous-smp_commence.patch
replace-regular-code-with-appropriate-calls-to-container_of.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
remove-unused-kernel-config-option-zisofs_fs.patch
remove-unused-kernel-config-option-lcd_device.patch
remove-unused-kernel-config-option-paride_parport.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
