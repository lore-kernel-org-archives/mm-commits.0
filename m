From: akpm@linux-foundation.org
Subject: [merged] genirq-remove-unneeded-kallsyms-include.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:59:38 -0800
Message-ID: <20180207195938.82XXN8Mql%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754493AbeBGT7j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:59:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, tglx@linutronix.de


The patch titled
     Subject: genirq: remove unneeded kallsyms include
has been removed from the -mm tree.  Its filename was
     genirq-remove-unneeded-kallsyms-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: genirq: remove unneeded kallsyms include

The file was converted from print_symbol() to %pf some time ago in
ef26f20cd117eb3c18 ("genirq: Print threaded handler in spurious debug
output").  kallsyms does not seem to be needed anymore.

Link: http://lkml.kernel.org/r/20171208025616.16267-10-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/spurious.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/irq/spurious.c~genirq-remove-unneeded-kallsyms-include kernel/irq/spurious.c
--- a/kernel/irq/spurious.c~genirq-remove-unneeded-kallsyms-include
+++ a/kernel/irq/spurious.c
@@ -10,7 +10,6 @@
 #include <linux/jiffies.h>
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <linux/kallsyms.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/timer.h>
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are


