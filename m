From: akpm@linux-foundation.org
Subject: + rcu-remove-duplicated-include-in-kernel-rcupreemptc.patch added to -mm tree
Date: Mon, 12 May 2008 14:48:01 -0700
Message-ID: <200805122148.m4CLm1oO010875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554AbYELVsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 17:48:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com


The patch titled
     rcu: remove duplicated include in kernel/rcupreempt.c
has been added to the -mm tree.  Its filename is
     rcu-remove-duplicated-include-in-kernel-rcupreemptc.patch

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
Subject: rcu: remove duplicated include in kernel/rcupreempt.c
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include file <linux/rcupdate.h> in kernel/rcupreempt.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/rcupreempt.c~rcu-remove-duplicated-include-in-kernel-rcupreemptc kernel/rcupreempt.c
--- a/kernel/rcupreempt.c~rcu-remove-duplicated-include-in-kernel-rcupreemptc
+++ a/kernel/rcupreempt.c
@@ -50,7 +50,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

rcu-remove-duplicated-include-in-kernel-rcupreemptc.patch
remove-duplicated-include-in-kernel-rcupreempt_tracec.patch

