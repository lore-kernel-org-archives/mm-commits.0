From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:23:33 -0700
Message-ID: <51db11b5.uhuE6gfe1rMyJFg9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHTXe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:23:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tm@tao.ma, sunil.mushran@gmail.com, srinivas.eeda@oracle.com, n_iwamatsu@jp.fujitsu.com, mfasheh@suse.com, jlbec@evilplan.org, gurudas.pai@oracle.com, jeff.liu@oracle.com

Subject: [merged] ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch removed from -mm tree
To: jeff.liu@oracle.com,gurudas.pai@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,n_iwamatsu@jp.fujitsu.com,srinivas.eeda@oracle.com,sunil.mushran@gmail.com,tm@tao.ma,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:23:33 -0700


The patch titled
     Subject: ocfs2: fix a comments typo at o2quo_hb_still_up()
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jie Liu <jeff.liu@oracle.com>
Subject: ocfs2: fix a comments typo at o2quo_hb_still_up()

Fix a comment typo in o2quo_hb_still_up()

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: Gurudas Pai <gurudas.pai@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Noboru Iwamatsu <n_iwamatsu@jp.fujitsu.com>
Cc: Srinivas Eeeda <srinivas.eeda@oracle.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Tao Ma <tm@tao.ma>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/quorum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/quorum.c~ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up fs/ocfs2/cluster/quorum.c
--- a/fs/ocfs2/cluster/quorum.c~ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up
+++ a/fs/ocfs2/cluster/quorum.c
@@ -264,7 +264,7 @@ void o2quo_hb_still_up(u8 node)
 /* This is analogous to hb_up.  as a node's connection comes up we delay the
  * quorum decision until we see it heartbeating.  the hold will be droped in
  * hb_up or hb_down.  it might be perpetuated by con_err until hb_down.  if
- * it's already heartbeating we we might be dropping a hold that conn_up got.
+ * it's already heartbeating we might be dropping a hold that conn_up got.
  * */
 void o2quo_conn_up(u8 node)
 {
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
linux-next.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

