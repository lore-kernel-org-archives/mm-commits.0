From: akpm@linux-foundation.org
Subject: + spellingtxt-modeled-is-spelt-correctly.patch added to -mm tree
Date: Mon, 29 Aug 2016 16:36:44 -0700
Message-ID: <57c4c70c.+VqvJBxWQJWKp6Mm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40555 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756398AbcH2Xgp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 19:36:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: spelling.txt: "modeled" is spelt correctly
has been added to the -mm tree.  Its filename is
     spellingtxt-modeled-is-spelt-correctly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/spellingtxt-modeled-is-spelt-correctly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/spellingtxt-modeled-is-spelt-correctly.patch

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
Subject: spelling.txt: "modeled" is spelt correctly

No need to correct the correct.

Link: http://lkml.kernel.org/r/1472490791.3425.38.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 -
 1 file changed, 1 deletion(-)

diff -puN scripts/spelling.txt~spellingtxt-modeled-is-spelt-correctly scripts/spelling.txt
--- a/scripts/spelling.txt~spellingtxt-modeled-is-spelt-correctly
+++ a/scripts/spelling.txt
@@ -629,7 +629,6 @@ mispelt||misspelt
 miximum||maximum
 mmnemonic||mnemonic
 mnay||many
-modeled||modelled
 modulues||modules
 monochorome||monochrome
 monochromo||monochrome
_

Patches currently in -mm which might be from joe@perches.com are

seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char.patch
meminfo-break-apart-a-very-long-seq_printf-with-ifdefs.patch
spellingtxt-modeled-is-spelt-correctly.patch
checkpatch-see-if-modified-files-are-marked-obsolete-in-maintainers.patch
checkpatch-look-for-symbolic-permissions-and-suggest-octal-instead.patch
checkpatch-test-multiple-line-block-comment-alignment.patch

