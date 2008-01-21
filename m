From: akpm@linux-foundation.org
Subject: - git-x86-unbreak-uml.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:14:05 -0800
Message-ID: <200801212314.m0LNE5Q5024954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761153AbYAUXTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-x86: unbreak UML
has been removed from the -mm tree.  Its filename was
     git-x86-unbreak-uml.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86: unbreak UML
From: WANG Cong <xiyou.wangcong@gmail.com>

include/asm/arch/system.h:8:22: error: asm/nops.h: No such file or directory

Acked-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/nops.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN /dev/null include/asm-um/nops.h
--- /dev/null
+++ a/include/asm-um/nops.h
@@ -0,0 +1,6 @@
+#ifndef __UM_NOPS_H
+#define __UM_NOPS_H
+
+#include "asm/arch/nops.h"
+
+#endif
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-kbuild.patch
git-net.patch
git-s390.patch
git-x86.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
