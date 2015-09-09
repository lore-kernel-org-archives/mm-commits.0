From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:54:27 -0700
Message-ID: <55f08e73.ZMfJ8fTBPEtY+P75%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41516 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbbIITy1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:54:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: selftest: update userfaultfd x86 32bit syscall number
has been removed from the -mm tree.  Its filename was
     userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: selftest: update userfaultfd x86 32bit syscall number

It changed as result of linux-next merge of other syscalls.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number tools/testing/selftests/vm/userfaultfd.c
--- a/tools/testing/selftests/vm/userfaultfd.c~userfaultfd-selftest-update-userfaultfd-x86-32bit-syscall-number
+++ a/tools/testing/selftests/vm/userfaultfd.c
@@ -70,7 +70,7 @@
 #ifdef __x86_64__
 #define __NR_userfaultfd 323
 #elif defined(__i386__)
-#define __NR_userfaultfd 359
+#define __NR_userfaultfd 374
 #elif defined(__powewrpc__)
 #define __NR_userfaultfd 364
 #else
_

Patches currently in -mm which might be from aarcange@redhat.com are


