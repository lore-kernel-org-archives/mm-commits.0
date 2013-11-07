From: akpm@linux-foundation.org
Subject: +
 printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch added
 to -mm tree
Date: Thu, 07 Nov 2013 13:09:09 -0800
Message-ID: <527c0175.50GhlEHzYZa30d4W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3KGVJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Nov 2013 16:09:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, james.hogan@imgtec.com, fengguang.wu@intel.com, joe@perches.com

Subject: + printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch added to -mm tree
To: joe@perches.com,fengguang.wu@intel.com,james.hogan@imgtec.com
From: akpm@linux-foundation.org
Date: Thu, 07 Nov 2013 13:09:09 -0800


The patch titled
     Subject: printk-cache-mark-printk_once-test-variable-__read_mostly-fix
has been added to the -mm tree.  Its filename is
     printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch

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
Subject: printk-cache-mark-printk_once-test-variable-__read_mostly-fix

fix ia64 build

Cc: James Hogan <james.hogan@imgtec.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/processor.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/ia64/include/asm/processor.h~printk-cache-mark-printk_once-test-variable-__read_mostly-fix arch/ia64/include/asm/processor.h
--- a/arch/ia64/include/asm/processor.h~printk-cache-mark-printk_once-test-variable-__read_mostly-fix
+++ a/arch/ia64/include/asm/processor.h
@@ -71,6 +71,7 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 #include <linux/types.h>
+#include <linux/bitops.h>
 
 #include <asm/fpu.h>
 #include <asm/page.h>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
kernel-timerc-convert-kmalloc_nodegfp_zero-to-kzalloc_node.patch
ksm-remove-redundant-__gfp_zero-from-kcalloc.patch
printk-report-console-names-during-cut-over.patch
kernel-printk-printkc-convert-to-pr_foo.patch
vsprintf-check-real-user-group-id-for-%pk.patch
printkc-comments-should-refer-to-proc-vmcore-instead-of-proc-vmcoreinfo.patch
printk-cache-mark-printk_once-test-variable-__read_mostly.patch
printk-cache-mark-printk_once-test-variable-__read_mostly-fix.patch
get_maintainerpl-incomplete-output.patch
checkpatch-report-missing-spaces-around-trigraphs-with-strict.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-update-seq_foo-tests.patch
checkpatch-find-camelcase-definitions-of-struct-union-enum.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
checkpatch-add-rules-to-check-init-attribute-and-const-defects.patch
checkpatch-make-the-memory-barrier-test-noisier.patch
checkpatchpl-check-for-the-fsf-mailing-address.patch
checkpatch-improve-return-is-not-a-function-test.patch
checkpatch-add-check-for-sscanf-without-return-use.patch
checkpatch-add-check-for-sscanf-without-return-use-v2.patch
drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
drivers-rtc-rtc-pl030c-use-devm_kzalloc-instead-of-kmalloc.patch
kernel-modulec-use-pr_foo.patch
linux-next.patch
seq_file-introduce-seq_setwidth-and-seq_pad.patch
seq_file-remove-%n-usage-from-seq_file-users.patch
vsprintf-ignore-%n-again.patch

