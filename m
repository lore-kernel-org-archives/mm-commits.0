From: akpm@linux-foundation.org
Subject: + mm-sparsec-removed-duplicated-include.patch added to -mm tree
Date: Mon, 11 Aug 2008 13:39:29 -0700
Message-ID: <200808112039.m7BKdTiH020237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313AbYHKUj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 16:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com


The patch titled
     mm/sparse.c: removed duplicated include
has been added to the -mm tree.  Its filename is
     mm-sparsec-removed-duplicated-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mm-sparsec-removed-duplicated-include.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

