From: akpm@linux-foundation.org
Subject: + mm-vmscanc-remove-duplicate-include-of-compactionh.patch added to -mm tree
Date: Wed, 19 Jan 2011 14:17:06 -0800
Message-ID: <201101192217.p0JMH69G006571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1ASWRi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 17:17:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jj@chaosbits.net


The patch titled
     mm/vmscan.c: remove duplicate include of compaction.h
has been added to the -mm tree.  Its filename is
     mm-vmscanc-remove-duplicate-include-of-compactionh.patch

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
Subject: mm/vmscan.c: remove duplicate include of compaction.h
From: Jesper Juhl <jj@chaosbits.net>

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscanc-remove-duplicate-include-of-compactionh mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscanc-remove-duplicate-include-of-compactionh
+++ a/mm/vmscan.c
@@ -41,7 +41,6 @@
 #include <linux/memcontrol.h>
 #include <linux/delayacct.h>
 #include <linux/sysctl.h>
-#include <linux/compaction.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
_

Patches currently in -mm which might be from jj@chaosbits.net are

mm-vmscanc-remove-duplicate-include-of-compactionh.patch
linux-next.patch
x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
audit-always-follow-va_copy-with-va_end.patch

