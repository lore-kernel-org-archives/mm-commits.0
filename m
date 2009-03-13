From: akpm@linux-foundation.org
Subject: + mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon.patch added to -mm tree
Date: Fri, 13 Mar 2009 12:29:31 -0700
Message-ID: <200903131929.n2DJTVVt016717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbZCMTan (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Mar 2009 15:30:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com


The patch titled
     mfd: mark WM8350 mask revision as readable to match silicon
has been added to the -mm tree.  Its filename is
     mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: mark WM8350 mask revision as readable to match silicon
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

No impact unless someone has written additional kernel code.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/wm8350-regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/wm8350-regmap.c~mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon drivers/mfd/wm8350-regmap.c
--- a/drivers/mfd/wm8350-regmap.c~mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon
+++ a/drivers/mfd/wm8350-regmap.c
@@ -3186,7 +3186,7 @@ const struct wm8350_reg_access wm8350_re
 	/*  read    write volatile */
 	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R0   - Reset/ID */
 	{ 0x7CFF, 0x0C00, 0x7FFF }, /* R1   - ID */
-	{ 0x0000, 0x0000, 0x0000 }, /* R2 */
+	{ 0x007F, 0x0000, 0x0000 }, /* R2   - ROM Mask ID */
 	{ 0xBE3B, 0xBE3B, 0x8000 }, /* R3   - System Control 1 */
 	{ 0xFEF7, 0xFEF7, 0xF800 }, /* R4   - System Control 2 */
 	{ 0x80FF, 0x80FF, 0x8000 }, /* R5   - System Hibernate */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

linux-next.patch
input-add-wm97xx-accelerated-driver-for-avr32-at32ap700x-microprocessors.patch
mfd-use-the-value-of-the-final-spin-when-reading-the-auxadc.patch
mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon.patch
regulator-dont-warn-if-we-failed-to-get-a-regulator.patch
rtc-convert-wm8350-use-new-alarm-and-update-operations.patch
rtc-wm8350-retries-will-reach-1.patch

