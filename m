From: akpm@linux-foundation.org
Subject: [merged] memfd_test-add-missing-argument-to-printf.patch removed
 from -mm tree
Date: Fri, 12 Sep 2014 13:12:52 -0700
Message-ID: <541353c4.s+pHD8R72YGhXyqy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaILUMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Sep 2014 16:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, dh.herrmann@gmail.com, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memfd_test: add missing argument to printf()
has been removed from the -mm tree.  Its filename was
     memfd_test-add-missing-argument-to-printf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: memfd_test: add missing argument to printf()

Add a missing path argument buf to printf().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/selftests/memfd/memfd_test.c~memfd_test-add-missing-argument-to-printf tools/testing/selftests/memfd/memfd_test.c
--- a/tools/testing/selftests/memfd/memfd_test.c~memfd_test-add-missing-argument-to-printf
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -205,7 +205,7 @@ static void mfd_fail_open(int fd, int fl
 	sprintf(buf, "/proc/self/fd/%d", fd);
 	r = open(buf, flags, mode);
 	if (r >= 0) {
-		printf("open(%s) didn't fail as expected\n");
+		printf("open(%s) didn't fail as expected\n", buf);
 		abort();
 	}
 }
_

Patches currently in -mm which might be from bobby.prani@gmail.com are

origin.patch
linux-next.patch

