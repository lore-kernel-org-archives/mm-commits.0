From: akpm@linux-foundation.org
Subject: + checkpatch-spell-check-reudce.patch added to -mm tree
Date: Wed, 11 Mar 2015 15:16:41 -0700
Message-ID: <5500bec9.mcTYz+FyX9AZYo0x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbCKWQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 18:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jani.nikula@intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: spell check reudce
has been added to the -mm tree.  Its filename is
     checkpatch-spell-check-reudce.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-spell-check-reudce.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-spell-check-reudce.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jani Nikula <jani.nikula@intel.com>
Subject: checkpatch: spell check reudce

References: http://mid.gmane.org/1424977312-24902-1-git-send-email-ville.syrjala@linux.intel.com

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/spelling.txt~checkpatch-spell-check-reudce scripts/spelling.txt
--- a/scripts/spelling.txt~checkpatch-spell-check-reudce
+++ a/scripts/spelling.txt
@@ -825,6 +825,7 @@ retreived||retrieved
 retreive||retrieve
 retrive||retrieve
 retuned||returned
+reudce||reduce
 reuest||request
 reuqest||request
 reutnred||returned
_

Patches currently in -mm which might be from jani.nikula@intel.com are

checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
linux-next.patch

