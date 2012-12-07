From: akpm@linux-foundation.org
Subject: + x86-fix-a-compile-error-a-section-type-conflict.patch added to -mm tree
Date: Fri, 07 Dec 2012 15:38:47 -0800
Message-ID: <20121207233848.0535320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:52959 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab2LGXiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 18:38:50 -0500
Received: by mail-lb0-f202.google.com with SMTP id s4so66241lbc.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 15:38:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yangyongqiang01@baidu.com


The patch titled
     Subject: arch/x86/kernel/cpu/perf_event_p6.c: fix section warning
has been added to the -mm tree.  Its filename is
     x86-fix-a-compile-error-a-section-type-conflict.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yangyongqiang <yangyongqiang01@baidu.com>
Subject: arch/x86/kernel/cpu/perf_event_p6.c: fix section warning

Fix a compile error - 'a section type conflict' by removing __initconst.

Signed-off-by: yangyongqiang <yangyongqiang01@baidu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_p6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/perf_event_p6.c~x86-fix-a-compile-error-a-section-type-conflict arch/x86/kernel/cpu/perf_event_p6.c
--- a/arch/x86/kernel/cpu/perf_event_p6.c~x86-fix-a-compile-error-a-section-type-conflict
+++ a/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[] 
 
 };
 
-static __initconst u64 p6_hw_cache_event_ids
+static u64 p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
_

Patches currently in -mm which might be from yangyongqiang01@baidu.com are

x86-fix-a-compile-error-a-section-type-conflict.patch

