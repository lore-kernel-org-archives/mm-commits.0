From: akpm@linux-foundation.org
Subject: [failures]
 mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch removed from
 -mm tree
Date: Wed, 12 Mar 2014 13:49:02 -0700
Message-ID: <5320c83e.1csxDq7VrSKyM/em%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57929 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaCLUtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 16:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yangds.fnst@cn.fujitsu.com

Subject: [failures] mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch removed from -mm tree
To: yangds.fnst@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 13:49:02 -0700


The patch titled
     Subject: mm/huge_memory.c: replace hardcoding of 19 with MAX_NICE
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-replace-hardcoding-of-19-with-max_nice.patch

This patch was dropped because it had testing failures

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

linux-next.patch

