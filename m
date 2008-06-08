From: akpm@linux-foundation.org
Subject: - uml-remove-a-duplicate-include.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:41 -0700
Message-ID: <200806081947.m58JlfAg017436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247AbYFHTrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: remove a duplicate include
has been removed from the -mm tree.  Its filename was
     uml-remove-a-duplicate-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

