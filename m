From: akpm@linux-foundation.org
Subject: + geode-lists-are-subscriber-only.patch added to -mm tree
Date: Tue, 23 Oct 2007 23:15:56 -0700
Message-ID: <200710240615.l9O6FulX025982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbXJXGQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 02:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     geode lists are subscriber only
has been added to the -mm tree.  Its filename is
     geode-lists-are-subscriber-only.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: geode lists are subscriber only
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

This gave me bounces and moans when chasing CS5536 so document it.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~geode-lists-are-subscriber-only MAINTAINERS
--- a/MAINTAINERS~geode-lists-are-subscriber-only
+++ a/MAINTAINERS
@@ -353,13 +353,12 @@ S:	Maintained for 2.4; PCI support for 2
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
-L:	info-linux@geode.amd.com
+L:	info-linux@geode.amd.com	(subscribers-only)
 S:	Supported
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
-M:	info-linux@geode.amd.com
-L:	info-linux@geode.amd.com
+L:	info-linux@geode.amd.com	(subscribers-only)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-scsi-misc.patch
initio-fix-conflict-when-loading-driver.patch
isd200-sort-out-usb-ide-dependancy-mess.patch
geode-lists-are-subscriber-only.patch
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
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
