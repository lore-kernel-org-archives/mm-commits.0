From: akpm@linux-foundation.org
Subject: + b3dfg-clean-up-module_parm_desc-newline.patch added to -mm tree
Date: Tue, 26 May 2009 14:55:32 -0700
Message-ID: <200905262155.n4QLtWR4006882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758073AbZEZVzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.neo.net@gmail.com, greg@kroah.com


The patch titled
     b3dfg: clean up MODULE_PARM_DESC newline
has been added to the -mm tree.  Its filename is
     b3dfg-clean-up-module_parm_desc-newline.patch

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

b3dfg-clean-up-module_parm_desc-newline.patch

