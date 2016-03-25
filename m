From: akpm@linux-foundation.org
Subject: +
 ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch added to -mm tree
Date: Fri, 25 Mar 2016 12:32:21 -0700
Message-ID: <56f59245.IKF9S7pcOjxJHcy3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbcCYTcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2016 15:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guozhonghua@h3c.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix comment in struct ocfs2_extended_slot
has been added to the -mm tree.  Its filename is
     ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-error-code-comments-and-amendments-the-comment-of-ocfs2_extended_slot-should-be-0x08.patch

