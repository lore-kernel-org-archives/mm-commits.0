From: akpm@linux-foundation.org
Subject: + sysrq-remove-duplicated-include.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:05:32 -0700
Message-ID: <200904092205.n39M5WvY018892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbZDIWGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:06:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com


The patch titled
     sysrq: remove duplicated #include
has been added to the -mm tree.  Its filename is
     sysrq-remove-duplicated-include.patch

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
Subject: sysrq: remove duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include in drivers/char/sysrq.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/sysrq.c~sysrq-remove-duplicated-include drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-remove-duplicated-include
+++ a/drivers/char/sysrq.c
@@ -35,7 +35,6 @@
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
-#include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
hp_accel-remove-unused-include-versionh.patch
linux-next.patch
sysrq-remove-duplicated-include.patch

