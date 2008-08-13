From: akpm@linux-foundation.org
Subject: - mm-sparsec-removed-duplicated-include.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:53:05 -0700
Message-ID: <200808130853.m7D8r5vL008290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681AbYHMJB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm/sparse.c: removed duplicated include
has been removed from the -mm tree.  Its filename was
     mm-sparsec-removed-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/sparse.c: removed duplicated include
From: Huang Weiyi <weiyi.huang@gmail.com>

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/sparse.c~mm-sparsec-removed-duplicated-include mm/sparse.c
--- a/mm/sparse.c~mm-sparsec-removed-duplicated-include
+++ a/mm/sparse.c
@@ -12,7 +12,6 @@
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
-#include "internal.h"
 
 /*
  * Permanent SPARSEMEM data:
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

