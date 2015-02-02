From: akpm@linux-foundation.org
Subject: + checkpatch-neaten-printk_ratelimited-message-position.patch
 added to -mm tree
Date: Mon, 02 Feb 2015 15:21:28 -0800
Message-ID: <54d00678.Knc1SOiJPcCcbkKX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbbBBXV3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 18:21:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: neaten printk_ratelimited message position
has been added to the -mm tree.  Its filename is
     checkpatch-neaten-printk_ratelimited-message-position.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-neaten-printk_ratelimited-message-position.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-neaten-printk_ratelimited-message-position.patch

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
Subject: checkpatch: neaten printk_ratelimited message position

Just neatening...

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-neaten-printk_ratelimited-message-position scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-neaten-printk_ratelimited-message-position
+++ a/scripts/checkpatch.pl
@@ -3243,7 +3243,7 @@ sub process {
 # check for uses of printk_ratelimit
 		if ($line =~ /\bprintk_ratelimit\s*\(/) {
 			WARN("PRINTK_RATELIMITED",
-"Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
+			     "Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit\n" . $herecurr);
 		}
 
 # printk should use KERN_* levels.  Note that follow on printk's on the
_

Patches currently in -mm which might be from joe@perches.com are

printk-correct-timeout-comment-neaten-module_parm_desc.patch
mm-utilc-add-kstrimdup.patch
checkpatch-emit-an-error-when-using-predefined-timestamp-macros.patch
checkpatch-improve-octal-permissions-tests.patch
checkpatch-ignore-__pure-attribute.patch
checkpatch-fix-unnecessary_kern_level-false-positive.patch
checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-allow-comments-in-macros-tested-for-single-statements.patch
checkpatch-update-git-commit-message.patch
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
checkpatch-add-ability-to-coalesce-commit-descriptions-on-multiple-lines.patch
checkpatch-add-types-for-other-os-typedefs.patch
checkpatch-add-ability-to-fix-unnecessary-blank-lines-around-braces.patch
checkpatch-improve-seq_print-seq_puts-suggestion.patch
checkpatch-improve-no-space-necessary-after-cast-test.patch
checkpatch-neaten-printk_ratelimited-message-position.patch
checkpatch-add-strict-test-for-spaces-around-arithmetic.patch
checkpatch-make-sure-a-commit-reference-description-uses-parentheses.patch
fs-ufs-superc-remove-unnecessary-casting.patch
linux-next.patch

