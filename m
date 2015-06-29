From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:33 -0700
Message-ID: <5591ac51.cMveCUnebRgrC6cg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbF2Uge (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: cleanup unused function __dlm_wait_on_lockres_flags_set
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2/dlm: cleanup unused function __dlm_wait_on_lockres_flags_set

__dlm_wait_on_lockres_flags_set() is declared but not implemented and
used.  So remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmcommon.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set fs/ocfs2/dlm/dlmcommon.h
--- a/fs/ocfs2/dlm/dlmcommon.h~ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set
+++ a/fs/ocfs2/dlm/dlmcommon.h
@@ -1014,7 +1014,6 @@ void dlm_move_lockres_to_recovery_list(s
 
 /* will exit holding res->spinlock, but may drop in function */
 void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags);
-void __dlm_wait_on_lockres_flags_set(struct dlm_lock_resource *res, int flags);
 
 /* will exit holding res->spinlock, but may drop in function */
 static inline void __dlm_wait_on_lockres(struct dlm_lock_resource *res)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

