From: akpm@linux-foundation.org
Subject: + char-stallion-remove-user-class-report-request.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:01:16 -0700
Message-ID: <200706060101.l5611GEe006536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765740AbXFFBBX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:01:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: stallion, remove user class report request
has been added to the -mm tree.  Its filename is
     char-stallion-remove-user-class-report-request.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: stallion, remove user class report request
From: Jiri Slaby <jirislaby@gmail.com>

stallion, remove user class report request

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/char/stallion.c~char-stallion-remove-user-class-report-request drivers/char/stallion.c
--- a/drivers/char/stallion.c~char-stallion-remove-user-class-report-request
+++ a/drivers/char/stallion.c
@@ -2357,9 +2357,6 @@ static int __devinit stl_pciprobe(struct
 	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE)
 		goto err;
 
-	dev_info(&pdev->dev, "please, report this to LKML: %x/%x/%x\n",
-			pdev->vendor, pdev->device, pdev->class);
-
 	retval = pci_enable_device(pdev);
 	if (retval)
 		goto err;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

ide-ide-generic-add-another-device-exception.patch
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
char-stallion-dont-fail-with-less-than-max-panels.patch
char-stallion-alloc-tty-before-pci-devices-init.patch
char-stallion-proper-fail-return-values.patch
char-stallion-remove-user-class-report-request.patch
shrink_slab-handle-bad-shrinkers.patch
