From: akpm@linux-foundation.org
Subject: [patch 088/114] hrtimer: remove unneeded kallsyms include
Date: Tue, 06 Feb 2018 15:41:10 -0800
Message-ID: <20180206234110.VjOjUcRrb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753346AbeBFXlL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:41:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, tglx@linutronix.de, torvalds@linux-foundation.org

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
