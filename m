From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:20 -0800
Message-ID: <548d0cf8.1la0M1cCo2qUHwML%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaLNEHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lcapitulino@redhat.com, andi@firstfloor.org, dave@stgolabs.net, isimatu.yasuaki@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: hugetlb_register_all_nodes(): add __init marker
has been removed from the -mm tree.  Its filename was
     hugetlb-hugetlb_register_all_nodes-add-__init-marker.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luiz Capitulino <lcapitulino@redhat.com>
Subject: hugetlb: hugetlb_register_all_nodes(): add __init marker

This function is only called during initialization.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-hugetlb_register_all_nodes-add-__init-marker mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-hugetlb_register_all_nodes-add-__init-marker
+++ a/mm/hugetlb.c
@@ -2083,7 +2083,7 @@ static void hugetlb_register_node(struct
  * devices of nodes that have memory.  All on-line nodes should have
  * registered their associated device by this time.
  */
-static void hugetlb_register_all_nodes(void)
+static void __init hugetlb_register_all_nodes(void)
 {
 	int nid;
 
_

Patches currently in -mm which might be from lcapitulino@redhat.com are

origin.patch
linux-next.patch

