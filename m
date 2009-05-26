From: akpm@linux-foundation.org
Subject: + maintainers-pair-edac-e752x-p-and-m-entries.patch added to -mm tree
Date: Tue, 26 May 2009 13:11:07 -0700
Message-ID: <200905262011.n4QKB9A8031110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbZEZUMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 16:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, dougthompson@xmission.com


The patch titled
     MAINTAINERS: pair EDAC-E752X P: and M: entries
has been added to the -mm tree.  Its filename is
     maintainers-pair-edac-e752x-p-and-m-entries.patch

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
Subject: MAINTAINERS: pair EDAC-E752X P: and M: entries
From: Joe Perches <joe@perches.com>

Entries should be P: name then M: email address.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-pair-edac-e752x-p-and-m-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-pair-edac-e752x-p-and-m-entries
+++ a/MAINTAINERS
@@ -1971,8 +1971,8 @@ F:	include/linux/edac.h
 
 EDAC-E752X
 P:	Mark Gross
-P:	Doug Thompson
 M:	mark.gross@intel.com
+P:	Doug Thompson
 M:	dougthompson@xmission.com
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-pair-edac-e752x-p-and-m-entries.patch
linux-next.patch

