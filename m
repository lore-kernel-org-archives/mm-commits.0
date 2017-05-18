From: akpm@linux-foundation.org
Subject: + lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch added to -mm tree
Date: Thu, 18 May 2017 12:32:05 -0700
Message-ID: <591df6b5.bu+K4+ihYgZq+6Xc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755682AbdERTcG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2017 15:32:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/interval_tree_test.c: allow the module to be compiled-in
has been added to the -mm tree.  Its filename is
     lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: lib/interval_tree_test.c: allow the module to be compiled-in

Patch series "lib/interval_tree_test: some debugging improvements".

Here are some patches that update the interval_tree_test module allowing
users to pass finer grained options to run the actual test.


This patch (of 4):

It is a tristate after all, and also serves well for quick debugging.

Link: http://lkml.kernel.org/r/20170518174936.20265-2-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~lib-interval_tree_test-allow-the-module-to-be-compiled-in lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-interval_tree_test-allow-the-module-to-be-compiled-in
+++ a/lib/Kconfig.debug
@@ -1773,7 +1773,7 @@ config RBTREE_TEST
 
 config INTERVAL_TREE_TEST
 	tristate "Interval tree test"
-	depends on m && DEBUG_KERNEL
+	depends on DEBUG_KERNEL
 	select INTERVAL_TREE
 	help
 	  A benchmark measuring the performance of the interval tree library
_

Patches currently in -mm which might be from dave@stgolabs.net are

lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch
lib-interval_tree_test-make-test-options-module-parameters.patch
lib-interval_tree_test-allow-users-to-limit-scope-of-endpoint.patch
lib-interval_tree_test-allow-full-tree-search.patch

