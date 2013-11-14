From: akpm@linux-foundation.org
Subject: [folded-merged] kfifo-api-type-safety-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 14 Nov 2013 14:25:55 -0800
Message-ID: <52854df3.NJ41LCy7HjFB3ZJG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab3KNWZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 17:25:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stefani@seibold.net, akpm@linux-foundation.org

Subject: [folded-merged] kfifo-api-type-safety-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,stefani@seibold.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 14:25:55 -0800


The patch titled
     Subject: kfifo-api-type-safety-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kfifo-api-type-safety-checkpatch-fixes.patch

This patch was dropped because it was folded into kfifo-api-type-safety.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kfifo-api-type-safety-checkpatch-fixes

ERROR: code indent should use tabs where possible
#201: FILE: include/linux/kfifo.h:504:
+ ^Itypeof(__tmp->ptr_const) __buf = (buf); \$

WARNING: please, no space before tabs
#201: FILE: include/linux/kfifo.h:504:
+ ^Itypeof(__tmp->ptr_const) __buf = (buf); \$

WARNING: please, no spaces at the start of a line
#201: FILE: include/linux/kfifo.h:504:
+ ^Itypeof(__tmp->ptr_const) __buf = (buf); \$

total: 1 errors, 2 warnings, 221 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/kfifo-api-type-safety.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kfifo.h~kfifo-api-type-safety-checkpatch-fixes include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-api-type-safety-checkpatch-fixes
+++ a/include/linux/kfifo.h
@@ -501,7 +501,7 @@ __kfifo_uint_must_check_helper( \
 #define	kfifo_in(fifo, buf, n) \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
- 	typeof(__tmp->ptr_const) __buf = (buf); \
+	typeof(__tmp->ptr_const) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
tree-wide-use-reinit_completion-instead-of-init_completion.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety.patch

