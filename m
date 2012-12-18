From: akpm@linux-foundation.org
Subject: [folded-merged] mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:15:51 -0800
Message-ID: <20121218221551.D8EBC100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51259 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2LRWPx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:15:53 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so145351vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:15:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch

This patch was dropped because it was folded into mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2

In file included from mm/migrate.c:36:
include/linux/hugetlb_cgroup.h:115: warning: function declaration isn't a prototype

Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2 include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2
+++ a/include/linux/hugetlb_cgroup.h
@@ -111,7 +111,7 @@ hugetlb_cgroup_uncharge_cgroup(int idx, 
 	return;
 }
 
-static inline void hugetlb_cgroup_file_init()
+static inline void hugetlb_cgroup_file_init(void)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
irq-tsk-comm-is-an-array.patch
memory-hotplug-document-and-enable-config_movable_node.patch
memcg-kmem-accounting-basic-infrastructure.patch
slub-slub-specific-propagation-changes.patch
mm-mprotectc-coding-style-cleanups.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch
mm-avoid-possible-deadlock-caused-by-too_many_isolated-fix.patch

