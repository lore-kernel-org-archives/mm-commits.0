From: akpm@linux-foundation.org
Subject: - codingstyle-relax-the-80-cole-rule.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:57:20 -0700
Message-ID: <200710180657.l9I6vKSQ030807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755503AbXJRHVG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:21:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     CodingStyle: relax the 80-cole rule
has been removed from the -mm tree.  Its filename was
     codingstyle-relax-the-80-cole-rule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CodingStyle: relax the 80-cole rule
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

I would suggest this change to make CodingStyle properly reflect the style
used by the kernel, rather than the current wording which is wishful
thinking and misleading, and comes from the same school of thought that
gets off on prescriptive grammar, latin and comp.std.c

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/CodingStyle~codingstyle-relax-the-80-cole-rule Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-relax-the-80-cole-rule
+++ a/Documentation/CodingStyle
@@ -77,12 +77,15 @@ Get a decent editor and don't leave whit
 Coding style is all about readability and maintainability using commonly
 available tools.
 
-The limit on the length of lines is 80 columns and this is a hard limit.
+The limit on the length of lines is 80 columns and this is a strongly
+preferred limit.
 
 Statements longer than 80 columns will be broken into sensible chunks.
 Descendants are always substantially shorter than the parent and are placed
 substantially to the right. The same applies to function headers with a long
-argument list. Long strings are as well broken into shorter strings.
+argument list. Long strings are as well broken into shorter strings. The
+only exception to this is where exceeding 80 columns significantly increases
+readability and does not hide information.
 
 void fun(int a, int b, int c)
 {
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
