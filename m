From: akpm@linux-foundation.org
Subject: [merged] hrtimer-remove-unneeded-kallsyms-include.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:59:35 -0800
Message-ID: <20180207195935.uqrn6a6Z-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754493AbeBGT7g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, tglx@linutronix.de


The patch titled
     Subject: hrtimer: remove unneeded kallsyms include
has been removed from the -mm tree.  Its filename was
     hrtimer-remove-unneeded-kallsyms-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: hrtimer: remove unneeded kallsyms include

hrtimer does not seem to use any of kallsyms functions/defines.

Link: http://lkml.kernel.org/r/20171208025616.16267-9-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/hrtimer.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/time/hrtimer.c~hrtimer-remove-unneeded-kallsyms-include kernel/time/hrtimer.c
--- a/kernel/time/hrtimer.c~hrtimer-remove-unneeded-kallsyms-include
+++ a/kernel/time/hrtimer.c
@@ -37,7 +37,6 @@
 #include <linux/hrtimer.h>
 #include <linux/notifier.h>
 #include <linux/syscalls.h>
-#include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/tick.h>
 #include <linux/seq_file.h>
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are


