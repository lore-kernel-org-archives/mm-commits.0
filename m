From: akpm@linux-foundation.org
Subject: [folded-merged] procfs-use-kbasename-fix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:44:37 -0800
Message-ID: <20121217234437.D11EF20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52667 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2LQXok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:44:40 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so352251bkc.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:44:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, andriy.shevchenko@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc_devtree: remove duplicated include from proc_devtree.c
has been removed from the -mm tree.  Its filename was
     procfs-use-kbasename-fix.patch

This patch was dropped because it was folded into procfs-use-kbasename.patch

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

origin.patch
procfs-use-kbasename.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch

