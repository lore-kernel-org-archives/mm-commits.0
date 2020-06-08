From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ocfs2-fix-spelling-mistake-and-grammar.patch added
 to -mm tree
Date: Mon, 08 Jun 2020 16:57:50 -0700
Message-ID: <20200608235750.YrSv7kulO%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732750AbgFHX5v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 19:57:51 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, iamkeyur96@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: fix spelling mistake and grammar
has been added to the -mm tree.  Its filename is
     fs-ocfs2-fix-spelling-mistake-and-grammar.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ocfs2-fix-spelling-mistake-and-grammar.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ocfs2-fix-spelling-mistake-and-grammar.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from iamkeyur96@gmail.com are

fs-ocfs2-fix-spelling-mistake-and-grammar.patch
