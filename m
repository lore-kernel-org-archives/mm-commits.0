From: akpm@linux-foundation.org
Subject: [merged]
 lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:26:34 -0700
Message-ID: <20170711192634.hNqgmRYPb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932973AbdGKT0f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/interval_tree_test.c: allow the module to be compiled-in
has been removed from the -mm tree.  Its filename was
     lib-interval_tree_test-allow-the-module-to-be-compiled-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1594,7 +1594,7 @@ config RBTREE_TEST
 
 config INTERVAL_TREE_TEST
 	tristate "Interval tree test"
-	depends on m && DEBUG_KERNEL
+	depends on DEBUG_KERNEL
 	select INTERVAL_TREE
 	help
 	  A benchmark measuring the performance of the interval tree library
_

Patches currently in -mm which might be from dave@stgolabs.net are

fs-kill-config_percpu_rwsem-some-more.patch

