From: akpm@osdl.org
Subject: + fix-apparent-typo-config_usb_cdcether.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:23:57 -0800
Message-ID: <200701260623.l0Q6Nvan009306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47937 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030786AbXAZGYA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:24:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, greg@kroah.com


The patch titled
     Fix apparent typo CONFIG_USB_CDCETHER
has been added to the -mm tree.  Its filename is
     fix-apparent-typo-config_usb_cdcether.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix apparent typo CONFIG_USB_CDCETHER
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the apparent typo CONFIG_USB_CDCETHER with CONFIG_USB_NET_CDCETHER.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/core/otg_whitelist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/otg_whitelist.h~fix-apparent-typo-config_usb_cdcether drivers/usb/core/otg_whitelist.h
--- a/drivers/usb/core/otg_whitelist.h~fix-apparent-typo-config_usb_cdcether
+++ a/drivers/usb/core/otg_whitelist.h
@@ -31,7 +31,7 @@ static struct usb_device_id whitelist_ta
 { USB_DEVICE_INFO(7, 1, 3) },
 #endif
 
-#ifdef	CONFIG_USB_CDCETHER
+#ifdef	CONFIG_USB_NET_CDCETHER
 /* Linux-USB CDC Ethernet gadget */
 { USB_DEVICE(0x0525, 0xa4a1), },
 /* Linux-USB CDC Ethernet + RNDIS gadget */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
fix-various-kernel-doc-in-header-files.patch
fix-config_x86_64_-typo-in-drivers-kvm-svmc.patch
git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
fix-apparent-typo-config_serial_cpm_smc.patch
remove-the-unused-kernel-config-option-video_videobuf.patch
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
