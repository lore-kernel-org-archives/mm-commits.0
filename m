From: akpm@linux-foundation.org
Subject: [merged] um-add-asm-percpuh.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:26 -0700
Message-ID: <201106282042.p5SKg83Y002974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab1F1UmS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: add asm/percpu.h
has been removed from the -mm tree.  Its filename was
     um-add-asm-percpuh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

