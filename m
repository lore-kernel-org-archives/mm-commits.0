From: akpm@linux-foundation.org
Subject: [merged] mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon.patch removed from -mm tree
Date: Mon, 04 May 2009 13:13:52 -0700
Message-ID: <200905042013.n44KDqvP022831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753255AbZEDUPf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:15:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     mfd: mark WM8350 mask revision as readable to match silicon
has been removed from the -mm tree.  Its filename was
     mfd-mark-wm8350-mask-revision-as-readable-to-match-silicon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

