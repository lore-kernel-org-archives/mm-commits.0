From: akpm@osdl.org
Subject: + isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch added to -mm tree
Date: Sat, 27 Jan 2007 13:38:13 -0800
Message-ID: <200701272138.l0RLcDer017116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35325 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXA0ViX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Jan 2007 16:38:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, kkeil@suse.de


The patch titled
     ISDN: Fix typo "CONFIG_HISAX_QUADRO" -> "CONFIG_HISAX_SCT_QUADRO".
has been added to the -mm tree.  Its filename is
     isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ISDN: Fix typo "CONFIG_HISAX_QUADRO" -> "CONFIG_HISAX_SCT_QUADRO".
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace misspelled CONFIG_HISAX_QUADRO with CONFIG_HISAX_SCT_QUADRO.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/isdn/hisax/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hisax/config.c~isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro
+++ a/drivers/isdn/hisax/config.c
@@ -1881,7 +1881,7 @@ static struct pci_device_id hisax_pci_tb
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_DJINN_ITOO,   PCI_ANY_ID, PCI_ANY_ID},
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_OLITEC,       PCI_ANY_ID, PCI_ANY_ID},
 #endif
-#ifdef CONFIG_HISAX_QUADRO
+#ifdef CONFIG_HISAX_SCT_QUADRO
 	{PCI_VENDOR_ID_PLX,      PCI_DEVICE_ID_PLX_9050,         PCI_ANY_ID, PCI_ANY_ID},
 #endif
 #ifdef CONFIG_HISAX_NICCY
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
acpi-correct-apparent-typo-config_acpi_debug_output.patch
git-alsa.patch
remove-useless-reference-to-obsolete-kerneld.patch
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
fix-apparent-typo-config_lockdep_debug.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
