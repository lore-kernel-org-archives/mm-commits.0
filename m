From: akpm@linux-foundation.org
Subject: + documentation-00-index-remove-reference-to-exceptiontxt.patch added to -mm tree
Date: Thu, 29 Jul 2010 12:36:12 -0700
Message-ID: <201007291936.o6TJaCgq029464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757393Ab0G2TgO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jul 2010 15:36:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com


The patch titled
     Documentation/00-INDEX: remove reference to exception.txt
has been added to the -mm tree.  Its filename is
     documentation-00-index-remove-reference-to-exceptiontxt.patch

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
Subject: Documentation/00-INDEX: remove reference to exception.txt
From: Huang Shijie <shijie8@gmail.com>

The exception.txt has been removed from the Documentation directory.  So
update the index file for it.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/00-INDEX |    2 --
 1 file changed, 2 deletions(-)

diff -puN Documentation/00-INDEX~documentation-00-index-remove-reference-to-exceptiontxt Documentation/00-INDEX
--- a/Documentation/00-INDEX~documentation-00-index-remove-reference-to-exceptiontxt
+++ a/Documentation/00-INDEX
@@ -130,8 +130,6 @@ edac.txt
 	- information on EDAC - Error Detection And Correction
 eisa.txt
 	- info on EISA bus support.
-exception.txt
-	- how Linux v2.2 handles exceptions without verify_area etc.
 fault-injection/
 	- dir with docs about the fault injection capabilities infrastructure.
 fb/
_

Patches currently in -mm which might be from shijie8@gmail.com are

linux-next.patch
documentation-00-index-remove-reference-to-exceptiontxt.patch

