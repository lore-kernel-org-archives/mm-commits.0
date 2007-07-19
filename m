From: akpm@linux-foundation.org
Subject: - drivers-edac-new-intel-5000-mc-driver-fix.patch removed from -mm tree
Date: Wed, 18 Jul 2007 22:54:50 -0700
Message-ID: <200707190554.l6J5sokJ016600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbXGSFzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, ericw@xmtp.net, norsk5@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac i5000 parenthesis balance fix
has been removed from the -mm tree.  Its filename was
     drivers-edac-new-intel-5000-mc-driver-fix.patch

This patch was dropped because it was folded into drivers-edac-new-intel-5000-mc-driver.patch

------------------------------------------------------
Subject: edac i5000 parenthesis balance fix
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Eric Wollesen <ericw@xmtp.net>
Cc: Doug Thompson <norsk5@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i5000_edac.c~drivers-edac-new-intel-5000-mc-driver-fix drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-new-intel-5000-mc-driver-fix
+++ a/drivers/edac/i5000_edac.c
@@ -277,7 +277,7 @@
 #define MTR_DRAM_BANKS(mtr)		((((mtr) >> 5) & 0x1) ? 8 : 4)
 #define MTR_DRAM_BANKS_ADDR_BITS(mtr)	((MTR_DRAM_BANKS(mtr) == 8) ? 3 : 2)
 #define MTR_DIMM_RANK(mtr)		(((mtr) >> 4) & 0x1)
-#define MTR_DIMM_RANK_ADDR_BITS(mtr)	((MTR_DIM_RANKS(mtr) ? 2 : 1)
+#define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIM_RANKS(mtr) ? 2 : 1)
 #define MTR_DIMM_ROWS(mtr)		(((mtr) >> 2) & 0x3)
 #define MTR_DIMM_ROWS_ADDR_BITS(mtr)	(MTR_DIMM_ROWS(mtr) + 13)
 #define MTR_DIMM_COLS(mtr)		((mtr) & 0x3)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
drivers-edac-new-intel-5000-mc-driver.patch
drivers-edac-new-intel-5000-mc-driver-fix.patch
driver-edac-i5000-define-typo.patch
