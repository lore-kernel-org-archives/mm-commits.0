From: akpm@linux-foundation.org
Subject: - cciss-add-p700m-to-list-of-supported-controllers.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:40 -0800
Message-ID: <200811102032.mAAKWeaM024089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbYKJUiu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:38:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@hp.com, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: add P700m to list of supported controllers
has been removed from the -mm tree.  Its filename was
     cciss-add-p700m-to-list-of-supported-controllers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: add P700m to list of supported controllers
From: dann frazier <dannf@hp.com>

P700m support was added in:
  9cff3b383dad193b0762c27278a16237e10b53dc

Update cciss.txt to match.

Signed-off-by: dann frazier <dannf@hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cciss.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/cciss.txt~cciss-add-p700m-to-list-of-supported-controllers Documentation/cciss.txt
--- a/Documentation/cciss.txt~cciss-add-p700m-to-list-of-supported-controllers
+++ a/Documentation/cciss.txt
@@ -21,6 +21,7 @@ This driver is known to work with the fo
 	* SA E200
 	* SA E200i
 	* SA E500
+	* SA P700m
 	* SA P212
 	* SA P410
 	* SA P410i
_

Patches currently in -mm which might be from dannf@hp.com are


