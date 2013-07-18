From: akpm@linux-foundation.org
Subject: + documentation-development-process-update-mm-and-next-urls.patch added to -mm tree
Date: Thu, 18 Jul 2013 14:23:02 -0700
Message-ID: <51e85cb6.EhZK6QDJ7mp6QrSG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082Ab3GRVXD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jul 2013 17:23:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, enselic@gmail.com

Subject: + documentation-development-process-update-mm-and-next-urls.patch added to -mm tree
To: enselic@gmail.com,sfr@canb.auug.org.au
From: akpm@linux-foundation.org
Date: Thu, 18 Jul 2013 14:23:02 -0700


The patch titled
     Subject: Documentation/development-process/: update -mm and -next URLs
has been added to the -mm tree.  Its filename is
     documentation-development-process-update-mm-and-next-urls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-development-process-update-mm-and-next-urls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-development-process-update-mm-and-next-urls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Martin Nordholts <enselic@gmail.com>
Subject: Documentation/development-process/: update -mm and -next URLs

Both old URLs are broken, so update them.

Signed-off-by: Martin Nordholts <enselic@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/development-process/2.Process |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/development-process/2.Process~documentation-development-process-update-mm-and-next-urls Documentation/development-process/2.Process
--- a/Documentation/development-process/2.Process~documentation-development-process-update-mm-and-next-urls
+++ a/Documentation/development-process/2.Process
@@ -276,7 +276,7 @@ mainline get there via -mm.
 The current -mm patch is available in the "mmotm" (-mm of the moment)
 directory at:
 
-	http://userweb.kernel.org/~akpm/mmotm/
+	http://www.ozlabs.org/~akpm/mmotm/
 
 Use of the MMOTM tree is likely to be a frustrating experience, though;
 there is a definite chance that it will not even compile.
@@ -287,7 +287,7 @@ the mainline is expected to look like af
 Linux-next trees are announced on the linux-kernel and linux-next mailing
 lists when they are assembled; they can be downloaded from:
 
-	http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/
+	http://www.kernel.org/pub/linux/kernel/next/
 
 Some information about linux-next has been gathered at:
 
_

Patches currently in -mm which might be from enselic@gmail.com are

documentation-development-process-update-mm-and-next-urls.patch

