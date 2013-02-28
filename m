From: akpm@linux-foundation.org
Subject: [folded-dropped] coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:41:38 -0800
Message-ID: <20130228004138.96D335A408F@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:59618 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3B1Alj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:41:39 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so138710ves.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:41:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, msb@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/exit.c: remove duplicated include
has been removed from the -mm tree.  Its filename was
     coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix.patch

This patch was dropped because it was folded into coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: kernel/exit.c: remove duplicated include

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/exit.c~coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix kernel/exit.c
--- a/kernel/exit.c~coredump-use-a-freezable_schedule-for-the-coredump_finish-wait-fix
+++ a/kernel/exit.c
@@ -32,7 +32,6 @@
 #include <linux/mempolicy.h>
 #include <linux/taskstats_kern.h>
 #include <linux/delayacct.h>
-#include <linux/freezer.h>
 #include <linux/cgroup.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
ib-ipath-convert-to-idr_alloc-fix.patch
memstick-move-the-dereference-below-the-null-test.patch

