From: akpm@linux-foundation.org
Subject: + documentation-atomic_opstxt.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:24:18 -0700
Message-ID: <200706060624.l566OIgQ010882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758680AbXFFGYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ratn.josh@gmail.com


The patch titled
     Documentation/atomic_ops.txt typo fix
has been added to the -mm tree.  Its filename is
     documentation-atomic_opstxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/atomic_ops.txt typo fix
From: "Ratnadeep Joshi" <ratn.josh@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/atomic_ops.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

documentation-atomic_opstxt.patch
