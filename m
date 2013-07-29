From: akpm@linux-foundation.org
Subject: + rbtree-allow-tests-to-run-as-builtin.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:43:58 -0700
Message-ID: <51f6f02e.hbQDxwIJJwREB4lM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3G2Wn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, sjenning@linux.vnet.ibm.com, riel@redhat.com, David.Woodhouse@intel.com, cody@linux.vnet.ibm.com

Subject: + rbtree-allow-tests-to-run-as-builtin.patch added to -mm tree
To: cody@linux.vnet.ibm.com,David.Woodhouse@intel.com,riel@redhat.com,sjenning@linux.vnet.ibm.com,walken@google.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:43:58 -0700


The patch titled
     Subject: rbtree: allow tests to run as builtin
has been added to the -mm tree.  Its filename is
     rbtree-allow-tests-to-run-as-builtin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-allow-tests-to-run-as-builtin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-allow-tests-to-run-as-builtin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: rbtree: allow tests to run as builtin

No reason require rbtree test code to be a module, allow it to be builtin
(streamlines my development process)

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~rbtree-allow-tests-to-run-as-builtin lib/Kconfig.debug
--- a/lib/Kconfig.debug~rbtree-allow-tests-to-run-as-builtin
+++ a/lib/Kconfig.debug
@@ -1461,7 +1461,7 @@ config BACKTRACE_SELF_TEST
 
 config RBTREE_TEST
 	tristate "Red-Black tree test"
-	depends on m && DEBUG_KERNEL
+	depends on DEBUG_KERNEL
 	help
 	  A benchmark measuring the performance of the rbtree library.
 	  Also includes rbtree invariant checks.
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint.patch
rbtree-add-postorder-iteration-functions.patch
rbtree-add-rbtree_postorder_for_each_entry_safe-helper.patch
rbtree_test-add-test-for-postorder-iteration.patch
rbtree-allow-tests-to-run-as-builtin.patch
mm-zswap-use-postorder-iteration-when-destroying-rbtree.patch

