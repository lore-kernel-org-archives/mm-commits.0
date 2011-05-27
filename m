From: akpm@linux-foundation.org
Subject: [merged] documentation-atomic_opstxt-avoid-volatile-in-sample-code.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:24 -0700
Message-ID: <201105271955.p4RJtTRx017456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754576Ab1E0UFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: knikanth@suse.de, mm-commits@vger.kernel.org


The patch titled
     Documentation/atomic_ops.txt: avoid volatile in sample code
has been removed from the -mm tree.  Its filename was
     documentation-atomic_opstxt-avoid-volatile-in-sample-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/atomic_ops.txt: avoid volatile in sample code
From: Nikanth Karthikesan <knikanth@suse.de>

As declaring counter as volatile is discouraged, it is best not to use it
in sample code as well.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/atomic_ops.txt~documentation-atomic_opstxt-avoid-volatile-in-sample-code Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~documentation-atomic_opstxt-avoid-volatile-in-sample-code
+++ a/Documentation/atomic_ops.txt
@@ -12,7 +12,7 @@ Also, it should be made opaque such that
 C integer type will fail.  Something like the following should
 suffice:
 
-	typedef struct { volatile int counter; } atomic_t;
+	typedef struct { int counter; } atomic_t;
 
 Historically, counter has been declared volatile.  This is now discouraged.
 See Documentation/volatile-considered-harmful.txt for the complete rationale.
_

Patches currently in -mm which might be from knikanth@suse.de are

origin.patch

