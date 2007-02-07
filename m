From: akpm@linux-foundation.org
Subject: - remove-unused-kernel-config-option-dlci_count.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:53:17 -0800
Message-ID: <200702071953.l17JrHD1025309@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161430AbXBGTxq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     Remove unused kernel config option DLCI_COUNT
has been removed from the -mm tree.  Its filename was
     remove-unused-kernel-config-option-dlci_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unused kernel config option DLCI_COUNT
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the unused kernel config option DLCI_COUNT.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof Halasa {khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/Kconfig |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN drivers/net/wan/Kconfig~remove-unused-kernel-config-option-dlci_count drivers/net/wan/Kconfig
--- a/drivers/net/wan/Kconfig~remove-unused-kernel-config-option-dlci_count
+++ a/drivers/net/wan/Kconfig
@@ -357,17 +357,6 @@ config DLCI
 	  To compile this driver as a module, choose M here: the
 	  module will be called dlci.
 
-config DLCI_COUNT
-	int "Max open DLCI"
-	depends on DLCI
-	default "24"
-	help
-	  Maximal number of logical point-to-point frame relay connections
-	  (the identifiers of which are called DCLIs) that the driver can
-	  handle.
-
-	  The default is probably fine.
-
 config DLCI_MAX
 	int "Max DLCI per device"
 	depends on DLCI
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-acpi.patch
git-alsa.patch
git-powerpc.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
git-dvb.patch
change-incorrect-config_input_atixl-to-config_mouse_atixl.patch
kbuild-remove-references-to-deprecated-prepare-all-target.patch
git-netdev-all.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
fix-apparent-typo-config_usb_cdcether.patch
git-wireless.patch
replace-incorrect-macro-name-wireless_ext-with.patch
remove-unused-kernel-config-option-x86_xadd.patch
remove-final-references-to-deprecated-map_anon-page-protection-flag.patch
uml-fix-apparent-config_64_bit-typo.patch
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
ntfs-rename-incorrect-check-of-ntfs_debug-with-just-debug.patch
quota-have-linux-quotah-include-linux-rwsemh-explicitly.patch
isdn-fix-typo-config_hisax_quadro-config_hisax_sct_quadro.patch
isdn-rename-some-debugging-macros-to-not-resemble-config.patch
isdn-rename-debug-option-config_serial_nopause_io.patch
isdn-remove-defunct-test-emulator.patch
isdn-rename-special-macro-config_hisax_hfc4s8s_pcimem.patch
correct-apparent-typo-config_aty_ct-in-aty-video.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
