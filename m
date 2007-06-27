From: akpm@linux-foundation.org
Subject: - export-usb_gadgetfsh-to-userspace.patch removed from -mm tree
Date: Wed, 27 Jun 2007 00:31:49 -0700
Message-ID: <200706270735.l5R7ZmMT012380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793AbXF0Hf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 03:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Export usb_gadgetfs.h to userspace
has been removed from the -mm tree.  Its filename was
     export-usb_gadgetfsh-to-userspace.patch

This patch was dropped because it had testing failures

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
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch
