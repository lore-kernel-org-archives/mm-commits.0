From: akpm@linux-foundation.org
Subject: [folded-merged] mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix.patch removed from -mm tree
Date: Tue, 18 Dec 2012 14:15:54 -0800
Message-ID: <20121218221554.CF629100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41605 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab2LRWPz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 17:15:55 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so145141vcd.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 14:15:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wujianguo@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix.patch

This patch was dropped because it was folded into mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix
+++ a/mm/hugetlb_cgroup.c
@@ -378,7 +378,7 @@ static void __init __hugetlb_cgroup_file
 	return;
 }
 
-void __init hugetlb_cgroup_file_init()
+void __init hugetlb_cgroup_file_init(void)
 {
 	struct hstate *h;
 
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init.patch

