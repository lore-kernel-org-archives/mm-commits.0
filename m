From: akpm@linux-foundation.org
Subject: + cciss-add-p700m-to-list-of-supported-controllers.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:01:25 -0700
Message-ID: <200810302101.m9UL1PsX006403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbYJ3VB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@hp.com, mike.miller@hp.com


The patch titled
     cciss: add P700m to list of supported controllers
has been added to the -mm tree.  Its filename is
     cciss-add-p700m-to-list-of-supported-controllers.patch

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
Subject: cciss: add P700m to list of supported controllers
From: dann frazier <dannf@hp.com>

P700m support was added in:
  9cff3b383dad193b0762c27278a16237e10b53dc

Update cciss.txt to match.

Signed-off-by: dann frazier <dannf@hp.com>
Acked-by: Mike Miller <mike.miller@hp.com>
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

cciss-add-p700m-to-list-of-supported-controllers.patch

