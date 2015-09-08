From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-adding-misspelled-word-for-check.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:01:42 -0700
Message-ID: <55ef2286.6MYgIycGXeTWccl+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbbIHSBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maninder1.s@samsung.com, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add misspelled words for check
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-adding-misspelled-word-for-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: add whcih->which, whcih I always get wrong]
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    4 ++++
 1 file changed, 4 insertions(+)

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
@@ -1028,6 +1031,7 @@ visiters||visitors
 vitual||virtual
 wating||waiting
 whataver||whatever
+whcih||which
 whenver||whenever
 wheter||whether
 whe||when
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

ipc-msgc-msgsnd-use-freezable-blocking-call.patch

