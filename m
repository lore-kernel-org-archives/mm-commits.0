From: akpm@linux-foundation.org
Subject: - ttyh-remove-dead-define.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:11 -0700
Message-ID: <200710180657.l9I6vBP5030795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760048AbXJRHRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty.h: remove dead define
has been removed from the -mm tree.  Its filename was
     ttyh-remove-dead-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty.h: remove dead define
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

No longer used. TTY_FLIPBUF_SIZE will also go soon but needs a couple of
other cleanups first

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tty.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/tty.h~ttyh-remove-dead-define include/linux/tty.h
--- a/include/linux/tty.h~ttyh-remove-dead-define
+++ a/include/linux/tty.h
@@ -81,11 +81,6 @@ struct tty_bufhead {
 	int memory_used;		/* Buffer space used excluding free queue */
 };
 /*
- * The pty uses char_buf and flag_buf as a contiguous buffer
- */
-#define PTY_BUF_SIZE	4*TTY_FLIPBUF_SIZE
-
-/*
  * When a break, frame error, or parity error happens, these codes are
  * stuffed into the flags buffer.
  */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
tty_ioctl-fix-the-baud_table-check-in-encode_baud_rate.patch
git-libata-all.patch
pata_cs5536-mwdma-fix.patch
libata-sff-correct-use-of-check_status.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
isd200-sort-out-usb-ide-dependancy-mess.patch
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
