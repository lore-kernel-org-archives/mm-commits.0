From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-__rcu-as-a-sparse-modifier.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:56:03 -0700
Message-ID: <201107260755.p6Q7t6kD003424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252Ab1GZHz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sven@narfation.org, apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add __rcu as a sparse modifier
has been removed from the -mm tree.  Its filename was
     checkpatch-add-__rcu-as-a-sparse-modifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add __rcu as a sparse modifier
From: Sven Eckelmann <sven@narfation.org>

Fix "need consistent spacing around '*'" error after a __rcu sparse
annotation which was caused by the missing __rcu entry in the
checkpatch.pl internal list of sparse keywords.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-__rcu-as-a-sparse-modifier scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-__rcu-as-a-sparse-modifier
+++ a/scripts/checkpatch.pl
@@ -145,7 +145,8 @@ our $Sparse	= qr{
 			__must_check|
 			__init_refok|
 			__kprobes|
-			__ref
+			__ref|
+			__rcu
 		}x;
 
 # Notes to $Attribute:
_

Patches currently in -mm which might be from sven@narfation.org are

origin.patch

