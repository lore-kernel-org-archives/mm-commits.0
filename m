From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 09/25] ocfs2: fix spelling mistake and grammar
Date: Wed, 10 Jun 2020 18:41:47 -0700
Message-ID: <20200611014147.RTu0qMF3l%akpm@linux-foundation.org>
References: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgFKBlt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Jun 2020 21:41:49 -0400
In-Reply-To: <20200610184053.3fa7368ab80e23bfd44de71f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, iamkeyur96@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Keyur Patel <iamkeyur96@gmail.com>
Subject: ocfs2: fix spelling mistake and grammar

./ocfs2/mmap.c:65: bebongs ==> belonging

Link: http://lkml.kernel.org/r/20200608014818.102358-1-iamkeyur96@gmail.com
Signed-off-by: Keyur Patel <iamkeyur96@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/mmap.c~fs-ocfs2-fix-spelling-mistake-and-grammar
+++ a/fs/ocfs2/mmap.c
@@ -62,7 +62,7 @@ static vm_fault_t __ocfs2_page_mkwrite(s
 	last_index = (size - 1) >> PAGE_SHIFT;
 
 	/*
-	 * There are cases that lead to the page no longer bebongs to the
+	 * There are cases that lead to the page no longer belonging to the
 	 * mapping.
 	 * 1) pagecache truncates locally due to memory pressure.
 	 * 2) pagecache truncates when another is taking EX lock against 
_
