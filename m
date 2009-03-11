From: akpm@linux-foundation.org
Subject: [merged] m68knommu-m5206e-build-fix.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:49 -0700
Message-ID: <200903111809.n2BI9nwu020002@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbZCKSLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfking@fdwdc.com, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     m68knommu: m5206e build fix
has been removed from the -mm tree.  Its filename was
     m68knommu-m5206e-build-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: m5206e build fix
From: Steven King <sfking@fdwdc.com>

Signed-off-by: Steven King <sfking@fdwdc.com>
Acked-by: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/platform/5206e/config.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/m68knommu/platform/5206e/config.c~m68knommu-m5206e-build-fix arch/m68knommu/platform/5206e/config.c
--- a/arch/m68knommu/platform/5206e/config.c~m68knommu-m5206e-build-fix
+++ a/arch/m68knommu/platform/5206e/config.c
@@ -17,6 +17,7 @@
 #include <asm/coldfire.h>
 #include <asm/mcfsim.h>
 #include <asm/mcfdma.h>
+#include <asm/mcfuart.h>
 
 /***************************************************************************/
 
_

Patches currently in -mm which might be from sfking@fdwdc.com are

origin.patch

