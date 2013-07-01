From: akpm@linux-foundation.org
Subject: + ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch added to
 -mm tree
Date: Mon, 01 Jul 2013 16:18:55 -0700
Message-ID: <51d20e5f.L3+dSV9HHY9oAw7A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3GAXS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 19:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tm@tao.ma, sunil.mushran@gmail.com, srinivas.eeda@oracle.com, n_iwamatsu@jp.fujitsu.com, mfasheh@suse.com, jlbec@evilplan.org, gurudas.pai@oracle.com, jeff.liu@oracle.com

Subject: + ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch added to -mm tree
To: jeff.liu@oracle.com,gurudas.pai@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,n_iwamatsu@jp.fujitsu.com,srinivas.eeda@oracle.com,sunil.mushran@gmail.com,tm@tao.ma
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 16:18:55 -0700


The patch titled
     Subject: ocfs2: fix a comments typo at o2quo_hb_still_up()
has been added to the -mm tree.  Its filename is
     ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
ocfs2-should-not-use-le32_add_cpu-to-set-ocfs2_dinode-i_flags.patch
ocfs2-add-missing-dlm_put-in-dlm_begin_reco_handler.patch
ocfs2-remove-unecessary-variable-needs_checkpoint.patch
ocfs2-fix-mutex_unlock-and-possible-memory-leak-in-ocfs2_remove_btree_range.patch
fs-ocfs2-journalh-add-bits_wanted-while-calculating-credits-in-ocfs2_calc_extend_credits.patch
fs-ocfs2-cluster-tcpc-free-sc-sc_page-in-sc_kref_release.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-xattr-remove-useless-free-space-checking-fix.patch
ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-dlmlock_master-should-return-dlm_normal-after-adding-lock-to-blocked-list.patch
ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add.patch
ocfs2-need-rollback-when-journal_access-failed-in-ocfs2_orphan_add-v3.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink-fix-2.patch
ocfs2-llseek-requires-ocfs2-inode-lock-for-the-file-in-seek_end.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch
ocfs2-xattr-fix-inlined-xattr-reflink.patch
ocfs2-submit-disk-heartbeat-bio-using-write_sync.patch
ocfs2-consolidate-o2hb_global_hearbeat_mode_set-naming-convention.patch
ocfs2-fix-a-comments-typo-at-o2quo_hb_still_up.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

