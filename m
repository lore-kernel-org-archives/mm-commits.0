From: akpm@linux-foundation.org
Subject: [merged] edac-x83-fix-mchbar-high-register-addr.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:35:01 -0700
Message-ID: <200907302035.n6UKZ1Wc007478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbZG3UgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:36:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tombowfly@gmail.com, dougthompson@xmission.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     edac: x38 fix mchbar high register addr
has been removed from the -mm tree.  Its filename was
     edac-x83-fix-mchbar-high-register-addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: x38 fix mchbar high register addr
From: Lu Zhihe <tombowfly@gmail.com>

Intel X38 MCHBAR is a 64bits register, base from 0x48, so its higher base
is 0x4C.

Signed-off-by: Lu Zhihe <tombowfly@gmail.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: <stable@kernel.org>		[2.6.30.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/x38_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/x38_edac.c~edac-x83-fix-mchbar-high-register-addr drivers/edac/x38_edac.c
--- a/drivers/edac/x38_edac.c~edac-x83-fix-mchbar-high-register-addr
+++ a/drivers/edac/x38_edac.c
@@ -30,7 +30,7 @@
 /* Intel X38 register addresses - device 0 function 0 - DRAM Controller */
 
 #define X38_MCHBAR_LOW	0x48	/* MCH Memory Mapped Register BAR */
-#define X38_MCHBAR_HIGH	0x4b
+#define X38_MCHBAR_HIGH	0x4c
 #define X38_MCHBAR_MASK	0xfffffc000ULL	/* bits 35:14 */
 #define X38_MMR_WINDOW_SIZE	16384
 
_

Patches currently in -mm which might be from tombowfly@gmail.com are

origin.patch

