From: akpm@linux-foundation.org
Subject: [merged] set-git-diff-driver-for-c-source-code-files.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:58:05 -0700
Message-ID: <57fc1cfd.Bg8FSbVyvkUNeFSa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38107 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752356AbcJJW6G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, corbet@lwn.net, joe@perches.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: .gitattributes: set git diff driver for C source code files
has been removed from the -mm tree.  Its filename was
     set-git-diff-driver-for-c-source-code-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


