From: akpm@linux-foundation.org
Subject: [merged] kdump-remove-unneeded-include.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:20:09 -0700
Message-ID: <20121005202009.9D2AD1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41893 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUUK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:20:10 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so237228vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:20:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, horms@verge.net.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kdump: remove unneeded include
has been removed from the -mm tree.  Its filename was
     kdump-remove-unneeded-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: kdump: remove unneeded include

The inclusion of <generated/utsrelease.h> is unnecessary.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/kexec.c~kdump-remove-unneeded-include kernel/kexec.c
--- a/kernel/kexec.c~kdump-remove-unneeded-include
+++ a/kernel/kexec.c
@@ -21,7 +21,6 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
 #include <linux/suspend.h>
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

