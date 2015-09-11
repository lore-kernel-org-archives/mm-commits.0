From: akpm@linux-foundation.org
Subject: [folded-merged]
 selftests-vm-add-tests-for-lock-on-fault-fix-2.patch removed from -mm tree
Date: Fri, 11 Sep 2015 15:00:30 -0700
Message-ID: <55f34efe.PVYFuK2z/kYQPuZe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbbIKWAb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:00:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, emunson@akamai.com, shuahkh@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: vm: ensure the mlock2 syscall number can be found
has been removed from the -mm tree.  Its filename was
     selftests-vm-add-tests-for-lock-on-fault-fix-2.patch

This patch was dropped because it was folded into selftests-vm-add-tests-for-lock-on-fault.patch

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: selftests: vm: ensure the mlock2 syscall number can be found

Include the syscall.h header to ensure that the mlock2 syscall number is
available. Otherwise the test program will always return ENOSYS from the
mlock2() implementation.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Eric B Munson <emunson@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/mlock2-tests.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix-2 tools/testing/selftests/vm/mlock2-tests.c
--- a/tools/testing/selftests/vm/mlock2-tests.c~selftests-vm-add-tests-for-lock-on-fault-fix-2
+++ a/tools/testing/selftests/vm/mlock2-tests.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <syscall.h>
 #include <errno.h>
 #include <stdbool.h>
 
_

Patches currently in -mm which might be from treding@nvidia.com are

userfaultfd-selftest-fix.patch
selftests-vm-add-tests-for-lock-on-fault.patch
selftests-vm-add-tests-for-lock-on-fault-fix-3.patch

