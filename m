From: akpm@linux-foundation.org
Subject: + kdump-remove-unneeded-include.patch added to -mm tree
Date: Fri, 31 Aug 2012 16:27:32 -0700
Message-ID: <20120831232732.9FBF2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:57938 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HaX1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 19:27:33 -0400
Received: by yenq6 with SMTP id q6so403435yen.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 16:27:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, horms@verge.net.au


The patch titled
     Subject: kdump: remove unneeded include
has been added to the -mm tree.  Its filename is
     kdump-remove-unneeded-include.patch

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

cciss-remove-useless-set-memory-to-zero-use-memset.patch
kdump-remove-unneeded-include.patch

