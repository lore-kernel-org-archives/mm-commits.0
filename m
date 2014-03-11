From: akpm@linux-foundation.org
Subject: + mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch
 added to -mm tree
Date: Tue, 11 Mar 2014 14:33:29 -0700
Message-ID: <531f8129.FB+AoXirwvFO/ofm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbaCKVda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 17:33:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yangds.fnst@cn.fujitsu.com

Subject: + mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch added to -mm tree
To: yangds.fnst@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 14:33:29 -0700


The patch titled
     Subject: mm/huge_memory.c: replace hardcoding of 19 with MAX_NICE
has been added to the -mm tree.  Its filename is
     mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: mm/huge_memory.c: replace hardcoding of 19 with MAX_NICE

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice mm/huge_memory.c
--- a/mm/huge_memory.c~mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice
+++ a/mm/huge_memory.c
@@ -2803,7 +2803,7 @@ static int khugepaged(void *none)
 	struct mm_slot *mm_slot;
 
 	set_freezable();
-	set_user_nice(current, 19);
+	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
 		khugepaged_do_scan();
_

Patches currently in -mm which might be from yangds.fnst@cn.fujitsu.com are

mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch
linux-next.patch

