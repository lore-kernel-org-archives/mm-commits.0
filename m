From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch removed from -mm tree
Date: Fri, 20 May 2016 14:02:58 -0700
Message-ID: <573f7b82.LCcePRnhUYb8Y9au%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:02:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix comment in struct ocfs2_extended_slot
has been removed from the -mm tree.  Its filename was
     ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from guozhonghua@h3c.com are


