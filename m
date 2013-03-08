From: akpm@linux-foundation.org
Subject: + mm-walk_memory_range-fix-typo-in-comment.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:31:47 -0800
Message-ID: <20130308213147.C126631C1B7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:51805 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3CHVbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:31:48 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so203928vcd.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:31:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: toshi.kani@hp.com


The patch titled
     Subject: mm: walk_memory_range(): fix typo in comment
has been added to the -mm tree.  Its filename is
     mm-walk_memory_range-fix-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm: walk_memory_range(): fix typo in comment

Fix a typo "end_pft" in the comment of walk_memory_range().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-walk_memory_range-fix-typo-in-comment mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-walk_memory_range-fix-typo-in-comment
+++ a/mm/memory_hotplug.c
@@ -1613,7 +1613,7 @@ int offline_pages(unsigned long start_pf
 /**
  * walk_memory_range - walks through all mem sections in [start_pfn, end_pfn)
  * @start_pfn: start pfn of the memory range
- * @end_pfn: end pft of the memory range
+ * @end_pfn: end pfn of the memory range
  * @arg: argument passed to func
  * @func: callback for each memory section walked
  *
_

Patches currently in -mm which might be from toshi.kani@hp.com are

mm-walk_memory_range-fix-typo-in-comment.patch
mm-remove_memory-fix-end_pfn-setting.patch

