From: akpm@linux-foundation.org
Subject: + power-remove-unneeded-kallsyms-include.patch added to -mm tree
Date: Fri, 08 Dec 2017 14:24:51 -0800
Message-ID: <5a2b1133.p/eWYUy1B/VAWAZd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51356 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbdLHWYw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Dec 2017 17:24:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, len.brown@intel.com, rjw@rjwysocki.net, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: power: remove unneeded kallsyms include
has been added to the -mm tree.  Its filename is
     power-remove-unneeded-kallsyms-include.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/power-remove-unneeded-kallsyms-include.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/power-remove-unneeded-kallsyms-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sched-autogroup-remove-unneeded-kallsyms-include.patch
mm-remove-unneeded-kallsyms-include.patch
power-remove-unneeded-kallsyms-include.patch
pci-remove-unneeded-kallsyms-include.patch
pnp-remove-unneeded-kallsyms-include.patch
workqueue-remove-unneeded-kallsyms-include.patch
hrtimer-remove-unneeded-kallsyms-include.patch
genirq-remove-unneeded-kallsyms-include.patch

