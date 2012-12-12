From: akpm@linux-foundation.org
Subject: [folded-merged] numa-add-config_movable_node-for-movable-dedicated-node-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:39:21 -0800
Message-ID: <20121212213922.AD6A2200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:33409 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2LLVj0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:39:26 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so68294wib.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:39:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de, minchan.kim@gmail.com, rientjes@google.com, rusty@rustcorp.com.au, wency@cn.fujitsu.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: numa-add-config_movable_node-for-movable-dedicated-node-fix
has been removed from the -mm tree.  Its filename was
     numa-add-config_movable_node-for-movable-dedicated-node-fix.patch

This patch was dropped because it was folded into numa-add-config_movable_node-for-movable-dedicated-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: numa-add-config_movable_node-for-movable-dedicated-node-fix

Cc: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/Kconfig~numa-add-config_movable_node-for-movable-dedicated-node-fix mm/Kconfig
--- a/mm/Kconfig~numa-add-config_movable_node-for-movable-dedicated-node-fix
+++ a/mm/Kconfig
@@ -144,7 +144,7 @@ config MEMORY_ISOLATION
 	boolean
 
 config MOVABLE_NODE
-	boolean "Enable to assign a node has only movable memory"
+	boolean "Enable to assign a node which has only movable memory"
 	depends on HAVE_MEMBLOCK
 	depends on NO_BOOTMEM
 	depends on X86_64
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch

