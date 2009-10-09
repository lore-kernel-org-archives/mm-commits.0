From: akpm@linux-foundation.org
Subject: [merged] staging-rtl8192e-add-missing-vmalloch-include.patch removed from -mm tree
Date: Fri, 09 Oct 2009 15:05:52 -0700
Message-ID: <200910092205.n99M5qh2022352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934701AbZJIWGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 18:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: plagnioj@jcrosoft.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     staging/rtl8192e: add missing vmalloc.h include
has been removed from the -mm tree.  Its filename was
     staging-rtl8192e-add-missing-vmalloch-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: staging/rtl8192e: add missing vmalloc.h include
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rtl8192e/r8192E_core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/rtl8192e/r8192E_core.c~staging-rtl8192e-add-missing-vmalloch-include drivers/staging/rtl8192e/r8192E_core.c
--- a/drivers/staging/rtl8192e/r8192E_core.c~staging-rtl8192e-add-missing-vmalloch-include
+++ a/drivers/staging/rtl8192e/r8192E_core.c
@@ -48,6 +48,7 @@
 //#define CONFIG_RTL8192_IO_MAP
 #include <linux/vmalloc.h>
 #include <asm/uaccess.h>
+#include <linux/vmalloc.h>
 #include "r8192E_hw.h"
 #include "r8192E.h"
 #include "r8190_rtl8256.h" /* RTL8225 Radio frontend */
_

Patches currently in -mm which might be from plagnioj@jcrosoft.com are


