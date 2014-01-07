From: akpm@linux-foundation.org
Subject: + maintainers-describe-differences-between-f-and-n-patterns.patch added to -mm tree
Date: Tue, 07 Jan 2014 15:59:09 -0800
Message-ID: <52cc94cd.Zzz5zaQQCmA0szX4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbaAGX7K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jan 2014 18:59:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org, broonie@linaro.org, joe@perches.com

Subject: + maintainers-describe-differences-between-f-and-n-patterns.patch added to -mm tree
To: joe@perches.com,broonie@linaro.org,gregkh@linuxfoundation.org,u.kleine-koenig@pengutronix.de
From: akpm@linux-foundation.org
Date: Tue, 07 Jan 2014 15:59:09 -0800


The patch titled
     Subject: MAINTAINERS: describe differences between F: and N: patterns
has been added to the -mm tree.  Its filename is
     maintainers-describe-differences-between-f-and-n-patterns.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-describe-differences-between-f-and-n-patterns.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-describe-differences-between-f-and-n-patterns.patch

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
Subject: MAINTAINERS: describe differences between F: and N: patterns

There is a difference in how scripts/get_maintainer.pl treats
F: and N: file pattern matches.

Describe those differences in the MAINTAINERS file.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@linaro.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-describe-differences-between-f-and-n-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-describe-differences-between-f-and-n-patterns
+++ a/MAINTAINERS
@@ -93,6 +93,11 @@ Descriptions of section entries:
 	N: Files and directories with regex patterns.
 	   N:	[^a-z]tegra	all files whose path contains the word tegra
 	   One pattern per line.  Multiple N: lines acceptable.
+	   scripts/get_maintainer.pl has different behavior for files that
+	   match F: pattern and matches of N: patterns.  By default,
+	   get_maintainer will not look at git log history when an F: pattern
+	   match occurs.  When an N: match occurs, git log history is used
+	   to also notify the people that have git commit signatures.
 	X: Files and directories that are NOT maintained, same rules as F:
 	   Files exclusions are tested before file matches.
 	   Can be useful for excluding a specific subdirectory, for instance:
_

Patches currently in -mm which might be from joe@perches.com are

lib-parserc-add-match_wildcard-function.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
dynamic_debug-add-wildcard-support-to-filter-files-functions-modules.patch
dynamic-debug-howtotxt-update-since-new-wildcard-support.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
vsprintf-add-%pad-extension-for-dma_addr_t-use.patch
printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch
get_maintainer-add-commit-author-information-to-rolestats.patch
maintainers-describe-differences-between-f-and-n-patterns.patch
test-add-minimal-module-for-verification-testing.patch
test-check-copy_to-from_user-boundary-validation.patch
test-check-copy_to-from_user-boundary-validation-fix.patch
checkpatch-more-comprehensive-split-strings-warning.patch
checkpatch-warn-only-on-space-before-semicolon-at-end-of-line.patch
checkpatch-add-warning-of-future-__gfp_nofail-use.patch
checkpatch-attempt-to-find-missing-switch-case-break.patch
checkpatch-add-a-fix-inplace-option.patch
checkpatch-improve-space-before-tab-fix-option.patch
checkpatch-check-for-ifs-with-unnecessary-parentheses.patch
checkpatch-update-the-fsf-gpl-address-check.patch
checkpatch-add-tests-for-function-pointer-style-misuses.patch
checkpatch-add-warning-with-unnecessary-parentheses-in-if-statements.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

