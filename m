From: akpm@linux-foundation.org
Subject: [merged] b3dfg-clean-up-module_parm_desc-newline.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:17 -0700
Message-ID: <200906032002.n53K2HFF001591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840AbZFCUCR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.neo.net@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     b3dfg: clean up MODULE_PARM_DESC newline
has been removed from the -mm tree.  Its filename was
     b3dfg-clean-up-module_parm_desc-newline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: b3dfg: clean up MODULE_PARM_DESC newline
From: Andre Lopes <andre.neo.net@gmail.com>

Remove incorrect MODULE_PARM_DESC newline.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/b3dfg/b3dfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/b3dfg/b3dfg.c~b3dfg-clean-up-module_parm_desc-newline drivers/staging/b3dfg/b3dfg.c
--- a/drivers/staging/b3dfg/b3dfg.c~b3dfg-clean-up-module_parm_desc-newline
+++ a/drivers/staging/b3dfg/b3dfg.c
@@ -41,7 +41,7 @@ static unsigned int b3dfg_nbuf = 2;
 
 module_param_named(buffer_count, b3dfg_nbuf, uint, 0444);
 
-MODULE_PARM_DESC(buffer_count, "Number of buffers (min 2, default 2)\n");
+MODULE_PARM_DESC(buffer_count, "Number of buffers (min 2, default 2)");
 
 MODULE_AUTHOR("Daniel Drake <ddrake@brontes3d.com>");
 MODULE_DESCRIPTION("Brontes frame grabber driver");
_

Patches currently in -mm which might be from andre.neo.net@gmail.com are

linux-next.patch

