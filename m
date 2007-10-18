From: akpm@linux-foundation.org
Subject: - mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:53 -0700
Message-ID: <200710180655.l9I6trJU030651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760437AbXJRHSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mxser: Remove use of dead TTY_FLIPBUF_SIZE definition
has been removed from the -mm tree.  Its filename was
     mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mxser: Remove use of dead TTY_FLIPBUF_SIZE definition
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

We simply define it to the same value.  Nowdays the TTY flip value is
irrelevant but the value it used is as good as any so why risk breaking it

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/mxser.h~mxser-remove-use-of-dead-tty_flipbuf_size-definition drivers/char/mxser.h
--- a/drivers/char/mxser.h~mxser-remove-use-of-dead-tty_flipbuf_size-definition
+++ a/drivers/char/mxser.h
@@ -30,8 +30,7 @@
 
 #define TTY_THRESHOLD_THROTTLE  128
 
-#define LO_WATER	 	(TTY_FLIPBUF_SIZE)
-#define HI_WATER		(TTY_FLIPBUF_SIZE*2*3/4)
+#define HI_WATER		768
 
 // added by James. 03-11-2004.
 #define MOXA_SDS_GETICOUNTER  	(MOXA + 68)
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
