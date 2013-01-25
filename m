From: akpm@linux-foundation.org
Subject: [merged] x86-fix-a-compile-error-a-section-type-conflict.patch removed from -mm tree
Date: Fri, 25 Jan 2013 13:37:58 -0800
Message-ID: <20130125213758.9E8E031C107@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49831 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3AYVh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 16:37:59 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so80969ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 13:37:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yangyongqiang01@baidu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/kernel/cpu/perf_event_p6.c: fix section warning
has been removed from the -mm tree.  Its filename was
     x86-fix-a-compile-error-a-section-type-conflict.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

