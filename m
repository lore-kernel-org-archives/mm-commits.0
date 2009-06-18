From: akpm@linux-foundation.org
Subject: [merged] gru-remove-references-to-the-obsolete-global-status-handle.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:49:14 -0700
Message-ID: <200906182249.n5IMnE6l008318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876AbZFRWub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: remove references to the obsolete global status handle
has been removed from the -mm tree.  Its filename was
     gru-remove-references-to-the-obsolete-global-status-handle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: remove references to the obsolete global status handle
From: Jack Steiner <steiner@sgi.com>

Delete references to the SGI GRU GSH hardware resources.  These GRU
resources have been deleted from the hardware.  (These resources have
never benn used, anyway).

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruhandles.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/misc/sgi-gru/gruhandles.h~gru-remove-references-to-the-obsolete-global-status-handle drivers/misc/sgi-gru/gruhandles.h
--- a/drivers/misc/sgi-gru/gruhandles.h~gru-remove-references-to-the-obsolete-global-status-handle
+++ a/drivers/misc/sgi-gru/gruhandles.h
@@ -39,7 +39,6 @@
 #define GRU_NUM_CBE		128
 #define GRU_NUM_TFH		128
 #define GRU_NUM_CCH		16
-#define GRU_NUM_GSH		1
 
 /* Maximum resource counts that can be reserved by user programs */
 #define GRU_NUM_USER_CBR	GRU_NUM_CBE
@@ -56,7 +55,6 @@
 #define GRU_CBE_BASE		(GRU_MCS_BASE + 0x10000)
 #define GRU_TFH_BASE		(GRU_MCS_BASE + 0x18000)
 #define GRU_CCH_BASE		(GRU_MCS_BASE + 0x20000)
-#define GRU_GSH_BASE		(GRU_MCS_BASE + 0x30000)
 
 /* User gseg constants */
 #define GRU_GSEG_STRIDE		(4 * 1024 * 1024)
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

