From: akpm@linux-foundation.org
Subject: - drivers-edac-add-rddr2-memory-types.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:15 -0700
Message-ID: <200707192005.l6JK5F21020029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52771 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754865AbXGSUPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add RDDR2 memory types
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-rddr2-memory-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add RDDR2 memory types
From: Douglas Thompson <dougthompson@xmission.com>

Add Registered RDDR2 memory types for displaying DDR2 memories

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/edac/edac_mc.h~drivers-edac-add-rddr2-memory-types drivers/edac/edac_mc.h
--- a/drivers/edac/edac_mc.h~drivers-edac-add-rddr2-memory-types
+++ a/drivers/edac/edac_mc.h
@@ -126,6 +126,7 @@ enum mem_type {
 	MEM_RMBS,		/* Rambus DRAM */
 	MEM_DDR2,               /* DDR2 RAM */
 	MEM_FB_DDR2,            /* fully buffered DDR2 */
+	MEM_RDDR2,              /* Registered DDR2 RAM */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -141,6 +142,7 @@ enum mem_type {
 #define MEM_FLAG_RMBS		BIT(MEM_RMBS)
 #define MEM_FLAG_DDR2           BIT(MEM_DDR2)
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
+#define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
