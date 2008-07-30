From: akpm@linux-foundation.org
Subject: - sgi-xp-define-xpsalerror-reason-code.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:19 -0700
Message-ID: <200807301916.m6UJGJBC011115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261AbYG3TX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: define xpSalError reason code
has been removed from the -mm tree.  Its filename was
     sgi-xp-define-xpsalerror-reason-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: define xpSalError reason code
From: Dean Nelson <dcn@sgi.com>

Define xpSalError reason code.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xp.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-define-xpsalerror-reason-code drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-define-xpsalerror-reason-code
+++ a/drivers/misc/sgi-xp/xp.h
@@ -249,8 +249,9 @@ enum xp_retval {
 	xpDisconnected,		/* 51: channel disconnected (closed) */
 
 	xpBteCopyError,		/* 52: bte_copy() returned error */
+	xpSalError,		/* 53: sn SAL error */
 
-	xpUnknownReason		/* 53: unknown reason - must be last in enum */
+	xpUnknownReason		/* 54: unknown reason - must be last in enum */
 };
 
 /*
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch

