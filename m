From: akpm@linux-foundation.org
Subject: [wrecked]
 ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch removed
 from -mm tree
Date: Tue, 22 Aug 2017 15:23:16 -0700
Message-ID: <599caed4.zC+zRM9uG+rYCTop%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51784 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdHVWXR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, zren@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: optimize freeing of dead node locks
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2/dlm: optimize freeing of dead node locks

Three loops can be optimized into one and its sub loops, so less code can
do the same work.

Link: http://lkml.kernel.org/r/71604351584F6A4EBAE558C676F37CA4C4AF898E@H3CMLB12-EX.srv.huawei-3com.com
Signed-off-by: Guozhonghua <guozhonghua@h3c.com>
Reviewed-by: Eric Ren <zren@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 0 files changed

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-optimization-of-code-while-free-dead-node-locks fs/ocfs2/dlm/dlmrecovery.c
_

Patches currently in -mm which might be from guozhonghua@h3c.com are

ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called.patch

