From: akpm@linux-foundation.org
Subject: + scripts-spellingtxt-adding-misspelled-word-for-check.patch
 added to -mm tree
Date: Thu, 09 Jul 2015 15:38:56 -0700
Message-ID: <559ef800.5MychxYVfGiX3vxC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbbGIWi5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maninder1.s@samsung.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add misspelled words for check
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-adding-misspelled-word-for-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-adding-misspelled-word-for-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-adding-misspelled-word-for-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: scripts/spelling.txt: add misspelled words for check

misspelled words for check:-
chcek
chck
cehck

I myself did these spell mistakes in changelog for patches, Thus
suggesting to add in spelling.txt, so that checkpatch.pl warns it earlier.
 References:-

./arch/powerpc/kernel/exceptions-64e.S:456: . . . make sure you chcek
https://lkml.org/lkml/2015/6/25/289
./arch/x86/mm/pageattr.c:1368: * No need to cehck in that case

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/spelling.txt~scripts-spellingtxt-adding-misspelled-word-for-check scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-adding-misspelled-word-for-check
+++ a/scripts/spelling.txt
@@ -187,6 +187,7 @@ capatibilities||capabilities
 carefuly||carefully
 cariage||carriage
 catagory||category
+cehck||check
 challange||challenge
 challanges||challenges
 chanell||channel
@@ -199,6 +200,8 @@ charactor||character
 charater||character
 charaters||characters
 charcter||character
+chcek||check
+chck||check
 checksuming||checksumming
 childern||children
 childs||children
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

scripts-spellingtxt-adding-misspelled-word-for-check.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch

