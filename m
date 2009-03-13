From: akpm@linux-foundation.org
Subject: [merged] mfd-add-support-for-wm8351-revision-b.patch removed from -mm tree
Date: Fri, 13 Mar 2009 11:19:42 -0700
Message-ID: <200903131819.n2DIJg5Z008627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758782AbZCMSWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 14:22:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: add support for WM8351 revision B
has been removed from the -mm tree.  Its filename was
     mfd-add-support-for-wm8351-revision-b.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: add support for WM8351 revision B
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

No software visible difference from revision A.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/mfd/wm8350-core.c~mfd-add-support-for-wm8351-revision-b drivers/mfd/wm8350-core.c
--- a/drivers/mfd/wm8350-core.c~mfd-add-support-for-wm8351-revision-b
+++ a/drivers/mfd/wm8350-core.c
@@ -1383,6 +1383,11 @@ int wm8350_device_init(struct wm8350 *wm
 			wm8350->power.rev_g_coeff = 1;
 			break;
 
+		case 1:
+			dev_info(wm8350->dev, "WM8351 Rev B\n");
+			wm8350->power.rev_g_coeff = 1;
+			break;
+
 		default:
 			dev_err(wm8350->dev, "Unknown WM8351 CHIP_REV\n");
 			ret = -ENODEV;
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
regulator-dont-warn-if-we-failed-to-get-a-regulator.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

