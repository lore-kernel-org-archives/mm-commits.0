From: akpm@linux-foundation.org
Subject: + checkpatch-add-tp_printk-to-list-of-logging-functions.patch
 added to -mm tree
Date: Tue, 17 Oct 2017 16:38:45 -0700
Message-ID: <59e69485.fSME3TUw/ytRyz0B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33040 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764751AbdJQXir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 19:38:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, songliubraving@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add TP_printk to list of logging functions
has been added to the -mm tree.  Its filename is
     checkpatch-add-tp_printk-to-list-of-logging-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-tp_printk-to-list-of-logging-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-tp_printk-to-list-of-logging-functions.patch

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
Subject: checkpatch: add TP_printk to list of logging functions

So the line length check can be bypassed by its callers.

Link: http://lkml.kernel.org/r/7de542c08a6e79f2ebe7c1416c9f403c23fdcc09.1508282823.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-tp_printk-to-list-of-logging-functions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-tp_printk-to-list-of-logging-functions
+++ a/scripts/checkpatch.pl
@@ -454,6 +454,7 @@ our $zero_initializer = qr{(?:(?:0[xX])?
 our $logFunctions = qr{(?x:
 	printk(?:_ratelimited|_once|_deferred_once|_deferred|)|
 	(?:[a-z0-9]+_){1,2}(?:printk|emerg|alert|crit|err|warning|warn|notice|info|debug|dbg|vdbg|devel|cont|WARN)(?:_ratelimited|_once|)|
+	TP_printk|
 	WARN(?:_RATELIMIT|_ONCE|)|
 	panic|
 	MODULE_[A-Z_]+|
_

Patches currently in -mm which might be from joe@perches.com are

spellingtxt-add-unnecessary-typo-variants.patch
parse-maintainers-add-ability-to-specify-filenames.patch
checkpatch-printks-always-need-a-kern_level.patch
checkpatch-allow-define_per_cpu-definitions-to-exceed-line-length.patch
checkpatch-add-tp_printk-to-list-of-logging-functions.patch

