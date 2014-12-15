From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch
 removed from -mm tree
Date: Mon, 15 Dec 2014 14:28:05 -0800
Message-ID: <548f6075.L8CkavEIV1tpRKrj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaLOW2H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Dec 2014 17:28:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2.patch

This patch was dropped because it was folded into ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

------------------------------------------------------
From: jiangyiwen <jiangyiwen@huawei.com>
Subject: ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2

Signed-off-by: jiangyiwen <jiangyiwen@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2 fs/ocfs2/dlm/dlmthread.c
--- a/fs/ocfs2/dlm/dlmthread.c~ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v2
+++ a/fs/ocfs2/dlm/dlmthread.c
@@ -217,7 +217,7 @@ static void dlm_purge_lockres(struct dlm
 	else {
 		mlog(ML_ERROR, "Resource %.*s not on the Tracking list\n",
 				res->lockname.len, res->lockname.name);
-		dlm_print_one_lock_resource(res);
+		__dlm_print_one_lock_resource(res);
 	}
 	spin_unlock(&dlm->track_lock);
 
_

Patches currently in -mm which might be from jiangyiwen@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

