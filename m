From: akpm@linux-foundation.org
Subject: + staging-rtl8192e-add-missing-vmalloch-include.patch added to -mm tree
Date: Tue, 29 Sep 2009 14:47:53 -0700
Message-ID: <200909292147.n8TLlrR3016209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbZI2Vr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 17:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: plagnioj@jcrosoft.com, gregkh@suse.de


The patch titled
     staging/rtl8192e: add missing vmalloc.h include
has been added to the -mm tree.  Its filename is
     staging-rtl8192e-add-missing-vmalloch-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -47,6 +47,7 @@
 
 //#define CONFIG_RTL8192_IO_MAP
 #include <asm/uaccess.h>
+#include <linux/vmalloc.h>
 #include "r8192E_hw.h"
 #include "r8192E.h"
 #include "r8190_rtl8256.h" /* RTL8225 Radio frontend */
_

Patches currently in -mm which might be from plagnioj@jcrosoft.com are

staging-rtl8192e-add-missing-vmalloch-include.patch

