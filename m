From: akpm@linux-foundation.org
Subject: [folded-merged]
 sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch removed from -mm
 tree
Date: Fri, 17 Nov 2017 15:19:22 -0800
Message-ID: <5a0f6e7a.BG71R2A+LfkVM5oh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030454AbdKQXTX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:19:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc-make-get_maxid-o1-again-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch

This patch was dropped because it was folded into sysvipc-make-get_maxid-o1-again.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysvipc-make-get_maxid-o1-again-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#110: FILE: ipc/util.c:439:
+			if(lid == -1)

total: 1 errors, 0 warnings, 113 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/sysvipc-make-get_maxid-o1-again.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/util.c~sysvipc-make-get_maxid-o1-again-checkpatch-fixes ipc/util.c
--- a/ipc/util.c~sysvipc-make-get_maxid-o1-again-checkpatch-fixes
+++ a/ipc/util.c
@@ -437,7 +437,7 @@ void ipc_rmid(struct ipc_ids *ids, struc
 	if (unlikely(lid == ids->max_id)) {
 		do {
 			lid--;
-			if(lid == -1)
+			if (lid == -1)
 				break;
 		} while (!idr_find(&ids->ipcs_idr, lid));
 		ids->max_id = lid;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sysvipc-make-get_maxid-o1-again.patch

