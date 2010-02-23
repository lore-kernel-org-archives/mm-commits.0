From: akpm@linux-foundation.org
Subject: + usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch added to -mm tree
Date: Mon, 22 Feb 2010 17:08:03 -0800
Message-ID: <201002230108.o1N183MK002492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab0BWBIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 20:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andi@lisas.de, daniel.sangorrin@gmail.com, gregkh@suse.de, liboska@uochb.cas.cz


The patch titled
     usb-serial-ftdi-add-contec-vendor-and-product-id-fix
has been added to the -mm tree.  Its filename is
     usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb-serial-ftdi-add-contec-vendor-and-product-id-fix
From: Andrew Morton <akpm@linux-foundation.org>

Keep the VIDs sorted a bit

Cc: Andreas Mohr <andi@lisas.de>
Cc: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Radek Liboska <liboska@uochb.cas.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio_ids.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/usb/serial/ftdi_sio_ids.h~usb-serial-ftdi-add-contec-vendor-and-product-id-fix drivers/usb/serial/ftdi_sio_ids.h
--- a/drivers/usb/serial/ftdi_sio_ids.h~usb-serial-ftdi-add-contec-vendor-and-product-id-fix
+++ a/drivers/usb/serial/ftdi_sio_ids.h
@@ -494,6 +494,13 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020
 
 /*
+ * Contec products (http://www.contec.com)
+ * Submitted by Daniel Sangorrin
+ */
+#define CONTEC_VID		0x06CE	/* Vendor ID */
+#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
+
+/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */
@@ -1004,13 +1011,6 @@
 #define EVO_RCM4_PID		0x0303	/* Evolution robotics RCM4 PID */
 
 /*
- * Contec products (http://www.contec.com)
- * Submitted by Daniel Sangorrin
- */
-#define CONTEC_VID		0x06CE	/* Vendor ID */
-#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
-
-/*
  * MJS Gadgets HD Radio / XM Radio / Sirius Radio interfaces (using VID 0x0403)
  */
 #define MJSG_GENERIC_PID	0x9378
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-serial-clients-support-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

