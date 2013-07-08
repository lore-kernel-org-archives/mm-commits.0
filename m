From: akpm@linux-foundation.org
Subject: [merged] mm-hotplug-prepare-for-removing-num_physpages.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:26:52 -0700
Message-ID: <51db127c.Xlgd0WkjxQvkljGR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3GHT0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com

Subject: [merged] mm-hotplug-prepare-for-removing-num_physpages.patch removed from -mm tree
To: liuj97@gmail.com,isimatu.yasuaki@jp.fujitsu.com,jiang.liu@huawei.com,tangchen@cn.fujitsu.com,wency@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:26:52 -0700


The patch titled
     Subject: mm/hotplug: prepare for removing num_physpages
has been removed from the -mm tree.  Its filename was
     mm-hotplug-prepare-for-removing-num_physpages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/hotplug: prepare for removing num_physpages

Prepare for removing num_physpages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-hotplug-prepare-for-removing-num_physpages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-hotplug-prepare-for-removing-num_physpages
+++ a/mm/memory_hotplug.c
@@ -763,10 +763,6 @@ EXPORT_SYMBOL_GPL(restore_online_page_ca
 
 void __online_page_set_limits(struct page *page)
 {
-	unsigned long pfn = page_to_pfn(page);
