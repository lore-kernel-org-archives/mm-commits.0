From: akpm@linux-foundation.org
Subject: + git-x86-unbreak-uml.patch added to -mm tree
Date: Thu, 17 Jan 2008 10:48:52 -0800
Message-ID: <200801171848.m0HImX35007195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58808 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbYAQStL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 13:49:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     git-x86: unbreak UML
has been added to the -mm tree.  Its filename is
     git-x86-unbreak-uml.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-x86-unbreak-uml.patch
uml-code-tidying-under-arch-um-os-linux.patch
uml-const-and-other-tidying.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
