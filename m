From: akpm@linux-foundation.org
Subject: [merged] extable-remove-duplicated-include-from-extablec.patch
 removed from -mm tree
Date: Fri, 11 Sep 2015 11:11:42 -0700
Message-ID: <55f3195e.sb/GhT3SYfN/DeIm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbIKSLm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:11:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/extable.c: remove duplicated include
has been removed from the -mm tree.  Its filename was
     extable-remove-duplicated-include-from-extablec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: kernel/extable.c: remove duplicated include

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/extable.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/extable.c~extable-remove-duplicated-include-from-extablec kernel/extable.c
--- a/kernel/extable.c~extable-remove-duplicated-include-from-extablec
+++ a/kernel/extable.c
@@ -18,7 +18,6 @@
 #include <linux/ftrace.h>
 #include <linux/memory.h>
 #include <linux/module.h>
-#include <linux/ftrace.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are


