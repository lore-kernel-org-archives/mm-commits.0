From: akpm@linux-foundation.org
Subject: + uml-remove-a-duplicate-include.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:31:12 -0700
Message-ID: <200806031931.m53JVCsF015897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789AbYFCTbP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, jdike@linux.intel.com


The patch titled
     uml: remove a duplicate include
has been added to the -mm tree.  Its filename is
     uml-remove-a-duplicate-include.patch

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
Subject: uml: remove a duplicate include
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include file "kern_util.h" in
arch/um/drivers/ubd_kern.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-remove-a-duplicate-include arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-remove-a-duplicate-include
+++ a/arch/um/drivers/ubd_kern.c
@@ -49,7 +49,6 @@
 #include "irq_user.h"
 #include "irq_kern.h"
 #include "ubd_user.h"
-#include "kern_util.h"
 #include "os.h"
 #include "mem.h"
 #include "mem_kern.h"
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
uml-remove-a-duplicate-include.patch
linux-next.patch

