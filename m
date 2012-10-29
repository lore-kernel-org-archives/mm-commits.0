From: akpm@linux-foundation.org
Subject: + procfs-use-kbasename-fix.patch added to -mm tree
Date: Mon, 29 Oct 2012 15:59:08 -0700
Message-ID: <20121029225909.551445C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:38319 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2J2W7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 18:59:12 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so347595fae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 15:59:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, andriy.shevchenko@linux.intel.com


The patch titled
     Subject: proc_devtree: remove duplicated include from proc_devtree.c
has been added to the -mm tree.  Its filename is
     procfs-use-kbasename-fix.patch

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
Subject: proc_devtree: remove duplicated include from proc_devtree.c

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_devtree.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/proc_devtree.c~procfs-use-kbasename-fix fs/proc/proc_devtree.c
--- a/fs/proc/proc_devtree.c~procfs-use-kbasename-fix
+++ a/fs/proc/proc_devtree.c
@@ -13,7 +13,6 @@
 #include <linux/of.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/string.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
 #include "internal.h"
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
procfs-use-kbasename-fix.patch

