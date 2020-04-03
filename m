From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-ocfs2_sec_bits-in-macro.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:35:05 -0700
Message-ID: <20200403203505.hxUeK-ZHI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: use OCFS2_SEC_BITS in macro
has been removed from the -mm tree.  Its filename was
     ocfs2-use-ocfs2_sec_bits-in-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: ocfs2: use OCFS2_SEC_BITS in macro

This macro should be used.

Link: http://lkml.kernel.org/r/1579577840-251956-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmglue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/dlmglue.c~ocfs2-use-ocfs2_sec_bits-in-macro
+++ a/fs/ocfs2/dlmglue.c
@@ -2133,7 +2133,7 @@ static void ocfs2_downconvert_on_unlock(
 }
 
 #define OCFS2_SEC_BITS   34
-#define OCFS2_SEC_SHIFT  (64 - 34)
+#define OCFS2_SEC_SHIFT  (64 - OCFS2_SEC_BITS)
 #define OCFS2_NSEC_MASK  ((1ULL << OCFS2_SEC_SHIFT) - 1)
 
 /* LVB only has room for 64 bits of time here so we pack it for
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are
