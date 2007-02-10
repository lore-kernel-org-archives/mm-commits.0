From: akpm@linux-foundation.org
Subject: - change-incorrect-config_input_atixl-to-config_mouse_atixl.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:24:54 -0800
Message-ID: <200702100524.l1A5OsYm004593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbXBJFZM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:25:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     Change incorrect "CONFIG_INPUT_ATIXL" to "CONFIG_MOUSE_ATIXL"
has been removed from the -mm tree.  Its filename was
     change-incorrect-config_input_atixl-to-config_mouse_atixl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Change incorrect "CONFIG_INPUT_ATIXL" to "CONFIG_MOUSE_ATIXL"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Change the apparently incorrect check for CONFIG_INPUT_ATIXL in a source
file to be consistent with the kernel config option CONFIG_MOUSE_ATIXL.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/inport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/mouse/inport.c~change-incorrect-config_input_atixl-to-config_mouse_atixl drivers/input/mouse/inport.c
--- a/drivers/input/mouse/inport.c~change-incorrect-config_input_atixl-to-config_mouse_atixl
+++ a/drivers/input/mouse/inport.c
@@ -61,7 +61,7 @@ MODULE_LICENSE("GPL");
 #define INPORT_REG_MODE		0x07
 #define INPORT_RESET		0x80
 
-#ifdef CONFIG_INPUT_ATIXL
+#ifdef CONFIG_MOUSE_ATIXL
 #define INPORT_NAME		"ATI XL Mouse"
 #define INPORT_VENDOR		0x0002
 #define INPORT_SPEED_30HZ	0x01
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
