From: akpm@linux-foundation.org
Subject: [folded] usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch removed from -mm tree
Date: Thu, 11 Mar 2010 14:10:26 -0800
Message-ID: <201003112210.o2BMARRs013709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758459Ab0CKWKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Mar 2010 17:10:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@lisas.de, daniel.sangorrin@gmail.com, gregkh@suse.de, liboska@uochb.cas.cz, mm-commits@vger.kernel.org


The patch titled
     usb-serial-ftdi-add-contec-vendor-and-product-id-fix
has been removed from the -mm tree.  Its filename was
     usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch

This patch was dropped because it was folded into usb-serial-ftdi-add-contec-vendor-and-product-id.patch

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
@@ -501,6 +501,13 @@
 #define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
 
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
@@ -1011,13 +1018,6 @@
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

add-generic-sys_ipc-wrapper.patch
broadsheetfb-support-storing-waveform.patch
drivers-char-memc-cleanups.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-implement-memory-thresholds.patch
documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch
pps-linuxpps-clients-support.patch
pps-serial-clients-support.patch
linux-next.patch
linux-next-fixups.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-make-it-build.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-i2c-busses-i2c-xiicc-is-borked.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
bitops-remove-temporary-for_each_bit.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

