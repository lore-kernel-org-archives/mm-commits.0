From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch added to -mm tree
Date: Tue, 11 Jun 2013 15:50:39 -0700
Message-ID: <51b7a9bf.l3NxiqPED445lsR+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3FKWuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:50:39 -0700


The patch titled
     Subject: checkpatch: add a placeholder to check blank lines before declarations
has been added to the -mm tree.  Its filename is
     checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add a placeholder to check blank lines before declarations

Figure out first how to determine if this is in a struct declaration or in
a function body before enabling this.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations
+++ a/scripts/checkpatch.pl
@@ -2750,6 +2750,14 @@ sub process {
 			      "space required before the open brace '{'\n" . $herecurr);
 		}
 
+## # check for blank lines before declarations
+##		if ($line =~ /^.\t+$Type\s+$Ident(?:\s*=.*)?;/ &&
+##		    $prevrawline =~ /^.\s*$/) {
+##			WARN("SPACING",
+##			     "No blank lines before declarations\n" . $hereprev);
+##		}
+##
+
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch

