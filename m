From: akpm@linux-foundation.org
Subject: [merged] mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible.patch removed from -mm tree
Date: Thu, 05 Feb 2009 11:14:48 -0800
Message-ID: <200902051914.n15JEmZ6012154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617AbZBETRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 14:17:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     mfd: mark WM835x USB_SLV_500MA bit as accessible
has been removed from the -mm tree.  Its filename was
     mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: mark WM835x USB_SLV_500MA bit as accessible
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/wm8350-regmap.c~mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible drivers/mfd/wm8350-regmap.c
--- a/drivers/mfd/wm8350-regmap.c~mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible
+++ a/drivers/mfd/wm8350-regmap.c
@@ -3188,7 +3188,7 @@ const struct wm8350_reg_access wm8350_re
 	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
 	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
 	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
-	{ 0xFCF7, 0xFCF7, 0xF800 }, /* R4   - System Control 2 */
+	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */
 	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
 	{ 0xFB0E, 0xFB0E, 0x0000 }, /* R6   - Interface Control */
 	{ 0x0000, 0x0000, 0x0000 }, /* R7 */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
mfd-support-active-high-irqs-on-wm835x.patch
mfd-ensure-all-wm8350-irqs-are-masked-at-startup.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

