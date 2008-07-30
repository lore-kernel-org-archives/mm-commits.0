From: akpm@linux-foundation.org
Subject: - iscsi_ibft_find-fix-modpost-warning.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:14:29 -0700
Message-ID: <200807301914.m6UJET3B010911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674AbYG3TQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, konradr@linux.vnet.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     iscsi_ibft_find: fix modpost warning
has been removed from the -mm tree.  Its filename was
     iscsi_ibft_find-fix-modpost-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iscsi_ibft_find: fix modpost warning
From: "Jan Beulich" <jbeulich@novell.com>

Exporting __init functions is wrong.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Konrad Rzeszutek <konradr@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft_find.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/firmware/iscsi_ibft_find.c~iscsi_ibft_find-fix-modpost-warning drivers/firmware/iscsi_ibft_find.c
--- a/drivers/firmware/iscsi_ibft_find.c~iscsi_ibft_find-fix-modpost-warning
+++ a/drivers/firmware/iscsi_ibft_find.c
@@ -81,4 +81,3 @@ void __init reserve_ibft_region(void)
 	if (ibft_addr)
 		reserve_bootmem(pos, PAGE_ALIGN(len), BOOTMEM_DEFAULT);
 }
-EXPORT_SYMBOL_GPL(reserve_ibft_region);
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch

