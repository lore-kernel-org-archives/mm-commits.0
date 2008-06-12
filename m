From: akpm@linux-foundation.org
Subject: - drivers-atm-enih-remove-unused-macro-kernel_offset.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:54 -0700
Message-ID: <200806122036.m5CKasfc005376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755506AbYFLUg4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:36:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rautelap@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/atm/eni.h: remove unused macro KERNEL_OFFSET
has been removed from the -mm tree.  Its filename was
     drivers-atm-enih-remove-unused-macro-kernel_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/atm/eni.h: remove unused macro KERNEL_OFFSET
From: Pradeep Singh Rautela <rautelap@gmail.com>

KERNEL_OFFSET macro in eni.h is not required as it is not used anywhere. 
Remove the unused macro from eni.h header file.

Signed-off-by: Pradeep Singh <rautelap@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/atm/eni.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/atm/eni.h~drivers-atm-enih-remove-unused-macro-kernel_offset drivers/atm/eni.h
--- a/drivers/atm/eni.h~drivers-atm-enih-remove-unused-macro-kernel_offset
+++ a/drivers/atm/eni.h
@@ -18,7 +18,6 @@
 #include "midway.h"
 
 
-#define KERNEL_OFFSET	0xC0000000	/* kernel 0x0 is at phys 0xC0000000 */
 #define DEV_LABEL	"eni"
 
 #define UBR_BUFFER	(128*1024)	/* UBR buffer size */
_

Patches currently in -mm which might be from rautelap@gmail.com are

origin.patch

