From: akpm@linux-foundation.org
Subject: + set-git-diff-driver-for-c-source-code-files.patch added to -mm
 tree
Date: Thu, 08 Sep 2016 16:19:42 -0700
Message-ID: <57d1f20e.rt1oyZnGkmNWiF/s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47327 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754030AbcIHXTn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 19:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, corbet@lwn.net, joe@perches.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: .gitattributes: set git diff driver for C source code files
has been added to the -mm tree.  Its filename is
     set-git-diff-driver-for-c-source-code-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/set-git-diff-driver-for-c-source-code-files.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/set-git-diff-driver-for-c-source-code-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@suse.de>
Subject: .gitattributes: set git diff driver for C source code files

Git can be told to apply language-specific rules when generating diffs. 
Enable this for C source code files (*.c and *.h) so that function names
are printed right.  Specifically, doing so prevents "git diff" from
mistakenly considering unindented goto labels as function names.

Link: http://lkml.kernel.org/r/20160907143403.1449324f@endymion
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Joe Perches <joe@perches.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitattributes |    2 ++
 1 file changed, 2 insertions(+)

diff -puN /dev/null .gitattributes
--- /dev/null
+++ a/.gitattributes
@@ -0,0 +1,2 @@
+*.c   diff=cpp
+*.h   diff=cpp
_

Patches currently in -mm which might be from jdelvare@suse.de are

set-git-diff-driver-for-c-source-code-files.patch

