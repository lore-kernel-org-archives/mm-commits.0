From: akpm@linux-foundation.org
Subject: + export-usb_gadgetfsh-to-userspace.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:44:39 -0700
Message-ID: <200706252244.l5PMidh5012841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbXFYWou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com


The patch titled
     Export usb_gadgetfs.h to userspace
has been added to the -mm tree.  Its filename is
     export-usb_gadgetfsh-to-userspace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Export usb_gadgetfs.h to userspace
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

The gadgetfs test program from http://www.linux-usb.org/gadget/ depends on
it.  I assume most other users of gadgetfs needs this header too.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/Kbuild~export-usb_gadgetfsh-to-userspace include/linux/Kbuild
--- a/include/linux/Kbuild~export-usb_gadgetfsh-to-userspace
+++ a/include/linux/Kbuild
@@ -152,6 +152,7 @@ header-y += tipc.h
 header-y += toshiba.h
 header-y += ultrasound.h
 header-y += un.h
+header-y += usb_gadgetfs.h
 header-y += utime.h
 header-y += video_decoder.h
 header-y += video_encoder.h
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-avr32.patch
export-usb_gadgetfsh-to-userspace.patch
git-watchdog.patch
atmel_serial-fix-break-handling.patch
atmel_spi-minor-updates.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
