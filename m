From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-drivers-w1.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:35 -0700
Message-ID: <200710180653.l9I6rZs1030457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279AbXJRHnB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:43:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in drivers/w1/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-drivers-w1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in drivers/w1/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	drivers/w1/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/matrox_w1.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/w1/masters/matrox_w1.c~clean-up-duplicate-includes-in-drivers-w1 drivers/w1/masters/matrox_w1.c
--- a/drivers/w1/masters/matrox_w1.c~clean-up-duplicate-includes-in-drivers-w1
+++ a/drivers/w1/masters/matrox_w1.c
@@ -33,7 +33,6 @@
 #include <linux/slab.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
-#include <linux/timer.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
