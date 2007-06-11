From: akpm@linux-foundation.org
Subject: + rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:18:15 -0700
Message-ID: <200706111818.l5BIIFmx025705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60859 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbXFKSSn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, a.zummo@towertech.it, david-b@pacbell.net, hskinnemoen@atmel.com


The patch titled
     rtc: make example code jump to done instead of return when ioctl not supported
has been added to the -mm tree.  Its filename is
     rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: make example code jump to done instead of return when ioctl not supported
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/rtc.txt~rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported
+++ a/Documentation/rtc.txt
@@ -385,7 +385,7 @@ test_PIE:
 		/* not all RTCs support periodic IRQs */
 		if (errno == ENOTTY) {
 			fprintf(stderr, "\nNo periodic IRQ support\n");
-			return 0;
+			goto done;
 		}
 		perror("RTC_IRQP_READ ioctl");
 		exit(errno);
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-avr32.patch
watchdog-driver-for-at32ap700x-devices.patch
watchdog-driver-for-at32ap700x-devices-fix.patch
watchdog-driver-for-at32ap700x-devices-fix-2.patch
watchdog-driver-for-at32ap700x-devices-fix-3.patch
watchdog-driver-for-at32ap700x-devices-fix-4.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
