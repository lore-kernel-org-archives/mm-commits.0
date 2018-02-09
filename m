From: akpm@linux-foundation.org
Subject: + ocfs2-clean-up-some-unused-function-declaration.patch added to
 -mm tree
Date: Fri, 09 Feb 2018 13:06:23 -0800
Message-ID: <5a7e0d4f.RMr4xPQ8C3F6nlT2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752732AbeBIVG3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Feb 2018 16:06:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove some unused function declarations
has been added to the -mm tree.  Its filename is
     ocfs2-clean-up-some-unused-function-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-clean-up-some-unused-function-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-clean-up-some-unused-function-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2: remove some unused function declarations

Remove some unused function declarations in dlmcommon.h.

Link: http://lkml.kernel.org/r/5A7D1034.7050807@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-clean-up-some-unused-function-declaration fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-clean-up-some-unused-function-declaration
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -960,13 +960,10 @@ static inline int dlm_send_proxy_ast(str
 void dlm_print_one_lock_resource(struct dlm_lock_resource *res);
 void __dlm_print_one_lock_resource(struct dlm_lock_resource *res);
 
-u8 dlm_nm_this_node(struct dlm_ctxt *dlm);
 void dlm_kick_thread(struct dlm_ctxt *dlm, struct dlm_lock_resource *res);
 void __dlm_dirty_lockres(struct dlm_ctxt *dlm, struct dlm_lock_resource *res);
 
 
-int dlm_nm_init(struct dlm_ctxt *dlm);
-int dlm_heartbeat_init(struct dlm_ctxt *dlm);
 void dlm_hb_node_down_cb(struct o2nm_node *node, int idx, void *data);
 void dlm_hb_node_up_cb(struct o2nm_node *node, int idx, void *data);
 
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-use-osb-instead-of-ocfs2_sb.patch
ocfs2-use-oi-instead-of-ocfs2_i.patch
ocfs2-clean-up-some-unused-function-declaration.patch

