From: akpm@linux-foundation.org
Subject: - sx-switch-subven-and-subid-values.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:32:00 -0700
Message-ID: <200707132232.l6DMW0bl024892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759346AbXGMWco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, gmurray@webwayone.co.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sx: switch subven and subid values
has been removed from the -mm tree.  Its filename was
     sx-switch-subven-and-subid-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sx: switch subven and subid values
From: Jiri Slaby <jirislaby@gmail.com>

sx.c is failing to locate Graham's card.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Graham Murray <gmurray@webwayone.co.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/sx.c~sx-switch-subven-and-subid-values drivers/char/sx.c
--- a/drivers/char/sx.c~sx-switch-subven-and-subid-values
+++ a/drivers/char/sx.c
@@ -2721,9 +2721,9 @@ static void __devexit sx_pci_remove(stru
    its because the standard requires it. So check for SUBVENDOR_ID. */
 static struct pci_device_id sx_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0200,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0200 },
 	{ PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_SX_XIO_IO8,
-		.subvendor = 0x0300,.subdevice = PCI_ANY_ID },
+		.subvendor = PCI_ANY_ID, .subdevice = 0x0300 },
 	{ 0 }
 };
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
char-mxser_new-fix-sparse-warning.patch
char-tty_ioctl-use-wait_event_interruptible_timeout.patch
char-tty_ioctl-little-whitespace-cleanup.patch
char-genrtc-use-wait_event_interruptible.patch
char-n_r3964-use-wait_event_interruptible.patch
char-ip2-use-msleep-for-sleeping.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
