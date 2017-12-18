From: akpm@linux-foundation.org
Subject: [merged] power-remove-unneeded-kallsyms-include.patch
 removed from -mm tree
Date: Mon, 18 Dec 2017 11:58:25 -0800
Message-ID: <20171218195825.1YdaZmu0t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdLRT61 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Dec 2017 14:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: len.brown@intel.com, mm-commits@vger.kernel.org, rjw@rjwysocki.net, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com


The patch titled
     Subject: power: remove unneeded kallsyms include
has been removed from the -mm tree.  Its filename was
     power-remove-unneeded-kallsyms-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: power: remove unneeded kallsyms include

The file was converted from print_fn_descriptor_symbol() to %pF some time
ago (c80cfb0406c01bb "vsprintf: use new vsprintf symbolic function pointer
format").  kallsyms does not seem to be needed anymore.

Link: http://lkml.kernel.org/r/20171208025616.16267-4-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/base/power/main.c~power-remove-unneeded-kallsyms-include drivers/base/power/main.c
--- a/drivers/base/power/main.c~power-remove-unneeded-kallsyms-include
+++ a/drivers/base/power/main.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/device.h>
-#include <linux/kallsyms.h>
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

mm-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

