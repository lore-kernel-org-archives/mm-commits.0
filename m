From: akpm@linux-foundation.org
Subject: - remove-dead-kernel-config-option-aedsp16_mpu401.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:54:57 -0800
Message-ID: <200702112254.l1BMsvBZ016281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913AbXBKW6L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:58:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     Remove dead kernel config option AEDSP16_MPU401.
has been removed from the -mm tree.  Its filename was
     remove-dead-kernel-config-option-aedsp16_mpu401.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove dead kernel config option AEDSP16_MPU401.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the dead kernel config option AEDSP16_MPU401.

Signed-off-by: Robert P. J. Day <mindspring.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/Kconfig |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN sound/oss/Kconfig~remove-dead-kernel-config-option-aedsp16_mpu401 sound/oss/Kconfig
--- a/sound/oss/Kconfig~remove-dead-kernel-config-option-aedsp16_mpu401
+++ a/sound/oss/Kconfig
@@ -719,18 +719,6 @@ config AEDSP16_SBPRO
 
 endchoice
 
-config AEDSP16_MPU401
-	bool "Audio Excel DSP 16 (MPU401 emulation)"
-	depends on SOUND_AEDSP16 && SOUND_MPU401
-	help
-	  Answer Y if you want your audio card to emulate the MPU-401 midi
-	  interface. You should then also say Y to "MPU-401 support".
-
-	  Note that the I/O base for MPU-401 support of aedsp16 is the same
-	  you have selected for "MPU-401 support". If you are using this
-	  driver as a module you have to specify the MPU I/O base address with
-	  the parameter 'mpu_base=0xNNN'.
-
 config SOUND_VIDC
 	tristate "VIDC 16-bit sound"
 	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500) && SOUND_OSS
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
