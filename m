From: akpm@linux-foundation.org
Subject: + maintainers-update-edac-i82975x.patch added to -mm tree
Date: Thu, 25 Jun 2009 12:31:07 -0700
Message-ID: <200906251931.n5PJV7GO029332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758951AbZFYTbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jun 2009 15:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, arvind@jetztechnologies.com, norsk5@yahoo.com, ravi@jetztechnologies.com


The patch titled
     MAINTAINERS: update EDAC-I82975X
has been added to the -mm tree.  Its filename is
     maintainers-update-edac-i82975x.patch

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
Subject: MAINTAINERS: update EDAC-I82975X
From: Joe Perches <joe@perches.com>

As per Ranganathan's request.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ranganathan Desikan <ravi@jetztechnologies.com>
Cc: Arvind R. <arvind@jetztechnologies.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-edac-i82975x MAINTAINERS
--- a/MAINTAINERS~maintainers-update-edac-i82975x
+++ a/MAINTAINERS
@@ -2087,9 +2087,9 @@ F:	drivers/edac/i5400_edac.c
 
 EDAC-I82975X
 P:	Ranganathan Desikan
-M:	rdesikan@jetzbroadband.com
+M:	ravi@jetztechnologies.com
 P:	Arvind R.
-M:	arvind@acarlab.com
+M:	arvind@jetztechnologies.com
 L:	bluesmoke-devel@lists.sourceforge.net (moderated for non-subscribers)
 W:	bluesmoke.sourceforge.net
 S:	Maintained
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-update-edac-i82975x.patch
linux-next.patch
maintainers-starfire-duralan-update.patch

