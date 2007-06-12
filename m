From: akpm@linux-foundation.org
Subject: - documentation-atomic_opstxt.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:54 -0700
Message-ID: <200706121856.l5CIusHH018429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40674 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756543AbXFLS5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ratn.josh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/atomic_ops.txt typo fix
has been removed from the -mm tree.  Its filename was
     documentation-atomic_opstxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation/atomic_ops.txt typo fix
From: "Ratnadeep Joshi" <ratn.josh@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/atomic_ops.txt~documentation-atomic_opstxt Documentation/atomic_ops.txt
--- a/Documentation/atomic_ops.txt~documentation-atomic_opstxt
+++ a/Documentation/atomic_ops.txt
@@ -149,7 +149,7 @@ defined which accomplish this:
 	void smp_mb__before_atomic_dec(void);
 	void smp_mb__after_atomic_dec(void);
 	void smp_mb__before_atomic_inc(void);
-	void smp_mb__after_atomic_dec(void);
+	void smp_mb__after_atomic_inc(void);
 
 For example, smp_mb__before_atomic_dec() can be used like so:
 
_

Patches currently in -mm which might be from ratn.josh@gmail.com are

origin.patch
