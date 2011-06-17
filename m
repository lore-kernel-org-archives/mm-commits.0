From: akpm@linux-foundation.org
Subject: + um-add-asm-percpuh.patch added to -mm tree
Date: Fri, 17 Jun 2011 15:30:46 -0700
Message-ID: <201106172230.p5HMUkGZ004933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757571Ab1FQWel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 18:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: add asm/percpu.h
has been added to the -mm tree.  Its filename is
     um-add-asm-percpuh.patch

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
Subject: um: add asm/percpu.h
From: Richard Weinberger <richard@nod.at>

To make SLUB work on UML we need this_cpu_cmpxchg from
asm-generic/percpu.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/percpu.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null arch/um/include/asm/percpu.h
--- /dev/null
+++ a/arch/um/include/asm/percpu.h
@@ -0,0 +1,6 @@
+#ifndef __UM_PERCPU_H
+#define __UM_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif /* __UM_PERCPU_H */
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
um-add-asm-percpuh.patch
linux-next.patch
um-clean-up-vm-flagsh.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
um-clean-up-delay-functions.patch

