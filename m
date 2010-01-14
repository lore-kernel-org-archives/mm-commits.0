From: akpm@linux-foundation.org
Subject: + smp-fix-documentation-in-include-linux-smph.patch added to -mm tree
Date: Wed, 13 Jan 2010 16:50:40 -0800
Message-ID: <201001140050.o0E0oeXM006562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765Ab0ANAvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 19:51:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com


The patch titled
     smp: fix documentation in include/linux/smp.h
has been added to the -mm tree.  Its filename is
     smp-fix-documentation-in-include-linux-smph.patch

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
Subject: smp: fix documentation in include/linux/smp.h
From: Rakib Mullick <rakib.mullick@gmail.com>

	smp: Fix documentation.

Fix documentation in include/linux/smp.h: smp_processor_id()

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/smp.h~smp-fix-documentation-in-include-linux-smph include/linux/smp.h
--- a/include/linux/smp.h~smp-fix-documentation-in-include-linux-smph
+++ a/include/linux/smp.h
@@ -154,7 +154,7 @@ smp_call_function_any(const struct cpuma
 /*
  * smp_processor_id(): get the current CPU ID.
  *
- * if DEBUG_PREEMPT is enabled the we check whether it is
+ * if DEBUG_PREEMPT is enabled then we check whether it is
  * used in a preemption-safe way. (smp_processor_id() is safe
  * if it's used in a preemption-off critical section, or in
  * a thread that is bound to the current CPU.)
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
acpi-fix-unused-variable-warning-in-sbsc.patch
smp-fix-documentation-in-include-linux-smph.patch

