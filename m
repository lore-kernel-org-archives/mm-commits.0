From: akpm@linux-foundation.org
Subject: + mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix.patch added to -mm tree
Date: Mon, 17 Dec 2012 12:54:26 -0800
Message-ID: <20121217205427.1CF2F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:50449 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2LQUyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 15:54:32 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so694828vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 12:54:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wujianguo@huawei.com


The patch titled
     Subject: mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2.patch
mm-hugetlb-create-hugetlb-cgroup-file-in-hugetlb_init-fix-2-fix.patch

