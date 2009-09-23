From: akpm@linux-foundation.org
Subject: [folded] edac-i3200-memory-controller-driver-fix-offset-of-reg-in-i3200_edac-module.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:37:17 -0700
Message-ID: <200909232237.n8NMbIAv032733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbZIWWhQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:37:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juhlenko@akamai.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: fix offset of reg in i3200_edac module
has been removed from the -mm tree.  Its filename was
     edac-i3200-memory-controller-driver-fix-offset-of-reg-in-i3200_edac-module.patch

This patch was dropped because it was folded into edac-i3200-memory-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: fix offset of reg in i3200_edac module
From: Jason Uhlenkott <juhlenko@akamai.com>

Fix an obviously wrong hardware register offset, which was inheirited
from x38_edac (which was previously fixed).

Thanks to Lu Zhihe for spotting this.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i3200_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/i3200_edac.c~edac-i3200-memory-controller-driver-fix-offset-of-reg-in-i3200_edac-module drivers/edac/i3200_edac.c
--- a/drivers/edac/i3200_edac.c~edac-i3200-memory-controller-driver-fix-offset-of-reg-in-i3200_edac-module
+++ a/drivers/edac/i3200_edac.c
@@ -29,7 +29,7 @@
 /* Intel 3200 register addresses - device 0 function 0 - DRAM Controller */
 
 #define I3200_MCHBAR_LOW	0x48	/* MCH Memory Mapped Register BAR */
-#define I3200_MCHBAR_HIGH	0x4b
+#define I3200_MCHBAR_HIGH	0x4c
 #define I3200_MCHBAR_MASK	0xfffffc000ULL	/* bits 35:14 */
 #define I3200_MMR_WINDOW_SIZE	16384
 
_

Patches currently in -mm which might be from juhlenko@akamai.com are

edac-i3200-memory-controller-driver.patch
edac-i3200-memory-controller-driver-fix-offset-of-reg-in-i3200_edac-module.patch

