From: akpm@linux-foundation.org
Subject: + extable-remove-duplicated-include-from-extablec.patch added to
 -mm tree
Date: Wed, 22 Jul 2015 15:39:34 -0700
Message-ID: <55b01ba6.DfUD8PfgWn9SmwvO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbGVWjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jul 2015 18:39:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/extable.c: remove duplicated include
has been added to the -mm tree.  Its filename is
     extable-remove-duplicated-include-from-extablec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/extable-remove-duplicated-include-from-extablec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/extable-remove-duplicated-include-from-extablec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

extable-remove-duplicated-include-from-extablec.patch
linux-next.patch

