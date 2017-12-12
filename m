From: akpm@linux-foundation.org
Subject: [merged]
 sched-autogroup-remove-unneeded-kallsyms-include.patch removed from -mm
 tree
Date: Tue, 12 Dec 2017 12:08:30 -0800
Message-ID: <20171212200830.3Ys8JDH9P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751612AbdLLUIb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 15:08:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com


The patch titled
     Subject: sched/autogroup: remove unneeded kallsyms include
has been removed from the -mm tree.  Its filename was
     sched-autogroup-remove-unneeded-kallsyms-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: sched/autogroup: remove unneeded kallsyms include

Autogroup does not seem to use any of kallsyms functions/defines.

Link: http://lkml.kernel.org/r/20171208025616.16267-2-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/autogroup.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/sched/autogroup.c~sched-autogroup-remove-unneeded-kallsyms-include kernel/sched/autogroup.c
--- a/kernel/sched/autogroup.c~sched-autogroup-remove-unneeded-kallsyms-include
+++ a/kernel/sched/autogroup.c
@@ -3,7 +3,6 @@
 
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/kallsyms.h>
 #include <linux/utsname.h>
 #include <linux/security.h>
 #include <linux/export.h>
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

mm-remove-unneeded-kallsyms-include.patch
power-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
pnp-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

