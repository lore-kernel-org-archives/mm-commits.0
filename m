From: akpm@osdl.org
Subject: + change-incorrect-config_input_atixl-to-config_mouse_atixl.patch added to -mm tree
Date: Fri, 26 Jan 2007 11:55:12 -0800
Message-ID: <200701261955.l0QJtC1x025021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161249AbXAZTzP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 14:55:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com


The patch titled
     Change incorrect "CONFIG_INPUT_ATIXL" to "CONFIG_MOUSE_ATIXL"
has been added to the -mm tree.  Its filename is
     change-incorrect-config_input_atixl-to-config_mouse_atixl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Change incorrect "CONFIG_INPUT_ATIXL" to "CONFIG_MOUSE_ATIXL"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Change the apparently incorrect check for CONFIG_INPUT_ATIXL in a source
file to be consistent with the kernel config option CONFIG_MOUSE_ATIXL.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/input/mouse/inport.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

fix-various-kernel-doc-in-header-files.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
remove-unused-kernel-config-option-x86_xadd.patch
uml-fix-apparent-config_64_bit-typo.patch
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
