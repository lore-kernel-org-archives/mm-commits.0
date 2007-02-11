From: akpm@linux-foundation.org
Subject: - remove-unused-kernel-config-option-paride_parport.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:03 -0800
Message-ID: <200702112255.l1BMt3OK016290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60551 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852AbXBKWzG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:55:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Remove unused kernel config option PARIDE_PARPORT
has been removed from the -mm tree.  Its filename was
     remove-unused-kernel-config-option-paride_parport.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unused kernel config option PARIDE_PARPORT
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused kernel config option PARIDE_PARPORT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/paride/Kconfig |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/block/paride/Kconfig~remove-unused-kernel-config-option-paride_parport drivers/block/paride/Kconfig
--- a/drivers/block/paride/Kconfig~remove-unused-kernel-config-option-paride_parport
+++ a/drivers/block/paride/Kconfig
@@ -2,14 +2,8 @@
 # PARIDE configuration
 #
 # PARIDE doesn't need PARPORT, but if PARPORT is configured as a module,
-# PARIDE must also be a module.  The bogus CONFIG_PARIDE_PARPORT option
-# controls the choices given to the user ...
+# PARIDE must also be a module.
 # PARIDE only supports PC style parports. Tough for USB or other parports...
-config PARIDE_PARPORT
-	tristate
-	depends on PARIDE!=n
-	default m if PARPORT_PC=m
-	default y if PARPORT_PC!=m
 
 comment "Parallel IDE high-level drivers"
 	depends on PARIDE
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
