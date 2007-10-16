From: akpm@linux-foundation.org
Subject: - 8250_pci-autodetect-mainpine-cards-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 20:49:21 -0700
Message-ID: <200710160349.l9G3nL8S007286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38170 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758049AbXJPDtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 23:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pci.h: Add PCI identifiers for mainpine cards
has been removed from the -mm tree.  Its filename was
     8250_pci-autodetect-mainpine-cards-fix.patch

This patch was dropped because it was folded into 8250_pci-autodetect-mainpine-cards.patch

------------------------------------------------------
Subject: pci.h: Add PCI identifiers for mainpine cards
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/pci_ids.h~8250_pci-autodetect-mainpine-cards-fix include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~8250_pci-autodetect-mainpine-cards-fix
+++ a/include/linux/pci_ids.h
@@ -1993,6 +1993,8 @@
 #define PCI_VENDOR_ID_TOPIC		0x151f
 #define PCI_DEVICE_ID_TOPIC_TP560	0x0000
 
+#define PCI_VENDOR_ID_MAINPINE		0x1522
+#define PCI_DEVICE_ID_MAINPINE_PBRIDGE	0x0100
 #define PCI_VENDOR_ID_ENE		0x1524
 #define PCI_DEVICE_ID_ENE_CB712_SD	0x0550
 #define PCI_DEVICE_ID_ENE_CB712_SD_2	0x0551
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
introduce-dma_mask_none-as-a-signal-for-unable-to-do.patch
pcmcia-use-dma_mask_none-for-the-default-for-all.patch
serial_txx9-cleanup-includes.patch
8250_pci-autodetect-mainpine-cards.patch
8250_pci-autodetect-mainpine-cards-fix.patch
wake-up-from-a-serial-port.patch
initio-fix-conflict-when-loading-driver.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
tty-bring-the-old-cris-driver-back-somewhere-into-the.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
add-config_vt_unicode.patch
keys-missing-word-in-documentation.patch
ide-cd-is-unmaintained.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
fs-correct-sus-compliance-for-open-of-large-file-without.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
usb_serial-stop-passing-null-to-functions-that-expect-data.patch
ark3116-update-termios-handling.patch
usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch
ch341-fix-termios-handling.patch
digi_acceleport-fix-termios-and-also-readability-a-bit.patch
empeg-clean-up-and-handle-speeds.patch
ir_usb-termios-handling.patch
keyspan-termios-tidy.patch
kobil_sct-termios-encoding-fixups.patch
option-termios-handling.patch
sierra-termios.patch
usb-serial-handle-null-termios-methods-as-no-hardware-changing-support.patch
whiteheat-clean-up-cant-happen-checks-and-encode-baud.patch
cp2101-convert-to-new-termios.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
io_edgeport-cleanups-and-tty-speed-reporting.patch
tty-kill-tty_flipbuf_size.patch
