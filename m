From: akpm@linux-foundation.org
Subject: [patch 016/117] ocfs2: fix comment in struct ocfs2_extended_slot
Date: Thu, 19 May 2016 17:09:44 -0700
Message-ID: <573e55c8.rLwZKYBnFF4L9fs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbcETAJp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:09:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de

From: Guozhonghua <guozhonghua@h3c.com>
Subject: ocfs2: fix comment in struct ocfs2_extended_slot

The comment in ocfs2_extended_slot has the offset wrong.

Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/ocfs2_fs.h~ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08 fs/ocfs2/ocfs2_fs.h
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -580,7 +580,7 @@ struct ocfs2_extended_slot {
 /*00*/	__u8	es_valid;
 	__u8	es_reserved1[3];
 	__le32	es_node_num;
-/*10*/
+/*08*/
 };
 
 /*
_
