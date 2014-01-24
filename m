From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-describe-differences-between-f-and-n-patterns.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:01:05 -0800
Message-ID: <52e2b871.2lVljxeHOzYuz+dS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaAXTBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, gregkh@linuxfoundation.org, broonie@linaro.org, joe@perches.com

Subject: [merged] maintainers-describe-differences-between-f-and-n-patterns.patch removed from -mm tree
To: joe@perches.com,broonie@linaro.org,gregkh@linuxfoundation.org,u.kleine-koenig@pengutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:05 -0800


The patch titled
     Subject: MAINTAINERS: describe differences between F: and N: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-describe-differences-between-f-and-n-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null.patch
ipc-whitespace-cleanup.patch
linux-next.patch
softirq-use-ffs-in-__do_softirq.patch
softirq-convert-printks-to-pr_level.patch
softirq-use-const-char-const-for-softirq_to_name-whitespace-neatening.patch
checkpatchpl-check-for-function-declarations-without-arguments.patch

