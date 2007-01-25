From: akpm@osdl.org
Subject: + fix-misspelled-usbnet_mii-kernel-config-option.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:47:43 -0800
Message-ID: <200701250547.l0P5lhxU007213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48303 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965278AbXAYFrq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:47:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, greg@kroah.com


The patch titled
     Fix misspelled "USBNET_MII" kernel config option.
has been added to the -mm tree.  Its filename is
     fix-misspelled-usbnet_mii-kernel-config-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix misspelled "USBNET_MII" kernel config option.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Fix the misspelling of "USBNET_MII" to "USB_USBNET_MII".

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/net/Kconfig~fix-misspelled-usbnet_mii-kernel-config-option drivers/usb/net/Kconfig
--- a/drivers/usb/net/Kconfig~fix-misspelled-usbnet_mii-kernel-config-option
+++ a/drivers/usb/net/Kconfig
@@ -99,7 +99,7 @@ config USB_USBNET_MII
 
 config USB_USBNET
 	tristate "Multi-purpose USB Networking Framework"
-	select MII if USBNET_MII != n
+	select MII if USB_USBNET_MII != n
 	---help---
 	  This driver supports several kinds of network links over USB,
 	  with "minidrivers" built around a common network driver core
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
remove-unused-kernel-config-option-dlci_count.patch
remove-useless-find_first_bit-macro-from-cardbusc.patch
remove-some-unused-scsi-related-kernel-config-variables.patch
fix-misspelled-usbnet_mii-kernel-config-option.patch
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
