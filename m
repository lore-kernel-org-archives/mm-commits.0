From: akpm@linux-foundation.org
Subject: [merged] um-include-linux-prefetchh.patch removed from -mm tree
Date: Wed, 25 May 2011 13:31:06 -0700
Message-ID: <201105252029.p4PKTTak014844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756045Ab1EYUok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: include linux/prefetch.h
has been removed from the -mm tree.  Its filename was
     um-include-linux-prefetchh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: include linux/prefetch.h
From: Richard Weinberger <richard@nod.at>

Fix build failures on UML.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/processor-generic.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/include/asm/processor-generic.h~um-include-linux-prefetchh arch/um/include/asm/processor-generic.h
--- a/arch/um/include/asm/processor-generic.h~um-include-linux-prefetchh
+++ a/arch/um/include/asm/processor-generic.h
@@ -14,6 +14,8 @@ struct task_struct;
 #include "registers.h"
 #include "sysdep/archsetjmp.h"
 
+#include <linux/prefetch.h>
+
 struct mm_struct;
 
 struct thread_struct {
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch

