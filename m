From: akpm@osdl.org
Subject: - acpi-correct-apparent-typo-config_acpi_debug_output.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:36:18 -0800
Message-ID: <200701302136.l0ULaJ5E029686@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50937 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbXA3VgW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:36:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: Correct apparent typo "CONFIG_ACPI_DEBUG_OUTPUT"
has been removed from the -mm tree.  Its filename was
     acpi-correct-apparent-typo-config_acpi_debug_output.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ACPI: Correct apparent typo "CONFIG_ACPI_DEBUG_OUTPUT"
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparent typo CONFIG_ACPI_DEBUG_OUTPUT with the non-Kconfig
conditional ACPI_DEBUG_OUTPUT, which is what every other file uses.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/scan.c~acpi-correct-apparent-typo-config_acpi_debug_output drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-correct-apparent-typo-config_acpi_debug_output
+++ a/drivers/acpi/scan.c
@@ -992,7 +992,7 @@ static int acpi_device_set_context(struc
 static void acpi_device_get_debug_info(struct acpi_device *device,
 				       acpi_handle handle, int type)
 {
-#ifdef CONFIG_ACPI_DEBUG_OUTPUT
+#ifdef ACPI_DEBUG_OUTPUT
 	char *type_string = NULL;
 	char name[80] = { '?', '\0' };
 	struct acpi_buffer buffer = { sizeof(name), name };
@@ -1029,7 +1029,7 @@ static void acpi_device_get_debug_info(s
 	}
 
 	printk(KERN_DEBUG "Found %s %s [%p]\n", type_string, name, handle);
-#endif				/*CONFIG_ACPI_DEBUG_OUTPUT */
+#endif				/* ACPI_DEBUG_OUTPUT */
 }
 
 static int acpi_bus_remove(struct acpi_device *dev, int rmdevice)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-acpi.patch
acpi-correct-apparent-typo-config_acpi_debug_output.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
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
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
