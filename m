From: akpm@linux-foundation.org
Subject: [merged] ocfs2-remove-fs_ocfs2_nm.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:34:59 -0700
Message-ID: <20200403203459.NaLHs_FcY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, gechangwei@live.cn, ghe@suse.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: remove FS_OCFS2_NM
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-fs_ocfs2_nm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: ocfs2: remove FS_OCFS2_NM

This macro is unused since commit ab09203e302b ("sysctl fs: Remove dead
binary sysctl support").

Link: http://lkml.kernel.org/r/1579577812-251572-1-git-send-email-alex.shi@linux.alibaba.com
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

 fs/ocfs2/stackglue.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/ocfs2/stackglue.c~ocfs2-remove-fs_ocfs2_nm
+++ a/fs/ocfs2/stackglue.c
@@ -656,8 +656,6 @@ error:
  * and easier to preserve the name.
  */
 
-#define FS_OCFS2_NM		1
