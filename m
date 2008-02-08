From: akpm@linux-foundation.org
Subject: - tty-kill-tty_flipbuf_size.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:01:56 -0800
Message-ID: <200802080801.m1881bDL013977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbYBHICY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:02:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty: Kill TTY_FLIPBUF_SIZE
has been removed from the -mm tree.  Its filename was
     tty-kill-tty_flipbuf_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: Kill TTY_FLIPBUF_SIZE
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This legacy define from the old buffer code is now only used in a single
power pc driver than doesn't compile anyway.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tty.h |    7 -------
 1 file changed, 7 deletions(-)

diff -puN include/linux/tty.h~tty-kill-tty_flipbuf_size include/linux/tty.h
--- a/include/linux/tty.h~tty-kill-tty_flipbuf_size
+++ a/include/linux/tty.h
@@ -53,13 +53,6 @@
  */
 #define __DISABLED_CHAR '\0'
 
-/*
- * This is the flip buffer used for the tty driver.  The buffer is
- * located in the tty structure, and is used as a high speed interface
- * between the tty driver and the tty line discipline.
- */
-#define TTY_FLIPBUF_SIZE 512
-
 struct tty_buffer {
 	struct tty_buffer *next;
 	char *char_buf_ptr;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
tty-let-architectures-override-the-user-kernel-macros.patch
tty-s390-support-for-termios2.patch
moxa-first-pass-at-termios-reporting.patch
n_tty-clean-up-old-code-to-follow-coding-style-and-mostly-checkpatch.patch
rocket-first-pass-at-termios-reporting.patch
rocket-dont-let-random-users-reset-the-controller.patch
tty_audit-fix-checkpatch-complaint.patch
tty_io-drag-screaming-into-coding-style-compliance.patch
tty_ioctl-drag-screaming-into-compliance-with-the-coding.patch
8250_early-coding-style.patch
8250_gsc-coding-style.patch
8250_hp300-coding-style.patch
8250_hub6-codding-style.patch
8250_pci-coding-style.patch
serial8250-coding-style.patch
8250-enable-rate-reporting-via-termios.patch
serial_core-bring-mostly-into-line-with-coding-style.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
