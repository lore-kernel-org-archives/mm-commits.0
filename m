From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
 added to -mm tree
Date: Mon, 27 Apr 2015 16:22:26 -0700
Message-ID: <553ec4b2.KWRBdoAt17nXRS7Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbbD0XW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Apr 2015 19:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/dlm: cleanup unused function __dlm_wait_on_lockres_flags_set
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-a-tiny-race-when-truncate-dio-orohaned-entry.patch
ocfs2-use-retval-instead-of-status-for-checking-error.patch
ocfs2-dlm-cleanup-unused-function-__dlm_wait_on_lockres_flags_set.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

