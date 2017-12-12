From: akpm@linux-foundation.org
Subject: [merged] workqueue-remove-unneeded-kallsyms-include.patch
 removed from -mm tree
Date: Tue, 12 Dec 2017 12:08:33 -0800
Message-ID: <20171212200833.r_yv6Kg0n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdLLUIe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 15:08:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangshanlai@gmail.com, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, tj@kernel.org


The patch titled
     Subject: workqueue: remove unneeded kallsyms include
has been removed from the -mm tree.  Its filename was
     workqueue-remove-unneeded-kallsyms-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: workqueue: remove unneeded kallsyms include

The file was converted from print_symbol() to %pf some time ago in
044c782ce3a901fb ("workqueue: fix checkpatch issues").  kallsyms does not
seem to be needed anymore.

Link: http://lkml.kernel.org/r/20171208025616.16267-8-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/workqueue.c~workqueue-remove-unneeded-kallsyms-include kernel/workqueue.c
--- a/kernel/workqueue.c~workqueue-remove-unneeded-kallsyms-include
+++ a/kernel/workqueue.c
@@ -38,7 +38,6 @@
 #include <linux/hardirq.h>
 #include <linux/mempolicy.h>
 #include <linux/freezer.h>
-#include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

mm-remove-unneeded-kallsyms-include.patch
power-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
pnp-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

