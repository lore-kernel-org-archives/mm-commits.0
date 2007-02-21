From: akpm@linux-foundation.org
Subject: + make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch added to -mm tree
Date: Wed, 21 Feb 2007 14:09:42 -0800
Message-ID: <200702212209.l1LM9g1s027890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161178AbXBUWM5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 17:12:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, greg@kroah.com


The patch titled
     make drivers/usb/misc/iowarrior.c:iowarrior_ids[] static
has been added to the -mm tree.  Its filename is
     make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make drivers/usb/misc/iowarrior.c:iowarrior_ids[] static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/iowarrior.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/misc/iowarrior.c~make-drivers-usb-misc-iowarriorciowarrior_ids-static drivers/usb/misc/iowarrior.c
--- a/drivers/usb/misc/iowarrior.c~make-drivers-usb-misc-iowarriorciowarrior_ids-static
+++ a/drivers/usb/misc/iowarrior.c
@@ -140,7 +140,7 @@ static int usb_set_report(struct usb_int
 /* driver registration */
 /*---------------------*/
 /* table of devices that work with this driver */
-struct usb_device_id iowarrior_ids[] = {
+static struct usb_device_id iowarrior_ids[] = {
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW40)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOW24)},
 	{USB_DEVICE(USB_VENDOR_ID_CODEMERCS, USB_DEVICE_ID_CODEMERCS_IOWPV1)},
_

Patches currently in -mm which might be from bunk@stusta.de are

arch-arm26-kernel-entrys-remove-dead-code.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
make-dvb_usb_gl861_debug-static.patch
make-pvr2_encoder_prep_config-static.patch
git-ieee1394.patch
mips-remove-smp_tune_scheduling.patch
remove-fs-jffs2-ioctlc.patch
git-ubi.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
net-uninline-skb_put-fix.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
make-drivers-usb-misc-iowarriorciowarrior_ids-static.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
lumpy-reclaim-cleanup.patch
kill-net-rxrpc-rxrpc_symsc.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
