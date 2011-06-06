From: akpm@linux-foundation.org
Subject: + checkpatch-add-__rcu-as-a-sparse-modifier.patch added to -mm tree
Date: Mon, 06 Jun 2011 14:34:00 -0700
Message-ID: <201106062134.p56LY0Vv023823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab1FFVeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 17:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sven@narfation.org, apw@canonical.com, joe@perches.com


The patch titled
     checkpatch: add __rcu as a sparse modifier
has been added to the -mm tree.  Its filename is
     checkpatch-add-__rcu-as-a-sparse-modifier.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch

