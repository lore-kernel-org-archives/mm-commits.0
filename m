From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-disable-branch-tracing-for-core-runtime-v2.patch
 added to -mm tree
Date: Fri, 22 May 2020 16:45:30 -0700
Message-ID: <20200522234530.zq8TmwTt5%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731169AbgEVXpb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 22 May 2020 19:45:31 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, cai@lca.pw, dvyukov@google.com, elver@google.com, glider@google.com, mm-commits@vger.kernel.org, rong.a.chen@intel.com


The patch titled
     Subject: kasan-disable-branch-tracing-for-core-runtime-v2
has been added to the -mm tree.  Its filename is
     kasan-disable-branch-tracing-for-core-runtime-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-disable-branch-tracing-for-core-runtime-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-disable-branch-tracing-for-core-runtime-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kasan-disable-branch-tracing-for-core-runtime-v2

remove duplicate DISABLE_BRANCH_PROFILING, per Qian Cai

Link: https://lore.kernel.org/lkml/20200517011732.GE24705@shao2-debian/
Link: http://lkml.kernel.org/r/20200522075207.157349-1-elver@google.com
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/tags.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/kasan/tags.c~kasan-disable-branch-tracing-for-core-runtime-v2
+++ a/mm/kasan/tags.c
@@ -12,7 +12,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DISABLE_BRANCH_PROFILING
 
 #include <linux/export.h>
 #include <linux/interrupt.h>
_

Patches currently in -mm which might be from elver@google.com are

kasan-disable-branch-tracing-for-core-runtime.patch
kasan-disable-branch-tracing-for-core-runtime-v2.patch
