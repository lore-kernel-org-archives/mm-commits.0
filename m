From: akpm@linux-foundation.org
Subject: [merged] selftests-fix-clean-target-in-kcmp-makefile.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:30 -0700
Message-ID: <51db14fa.Qm5b2i3NjyjSZqSh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3GHTha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com, artagnon@gmail.com

Subject: [merged] selftests-fix-clean-target-in-kcmp-makefile.patch removed from -mm tree
To: artagnon@gmail.com,dyoung@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:30 -0700


The patch titled
     Subject: selftests: fix clean target in kcmp Makefile
has been removed from the -mm tree.  Its filename was
     selftests-fix-clean-target-in-kcmp-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ramkumar Ramachandra <artagnon@gmail.com>
Subject: selftests: fix clean target in kcmp Makefile

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN tools/testing/selftests/kcmp/Makefile~selftests-fix-clean-target-in-kcmp-makefile tools/testing/selftests/kcmp/Makefile
--- a/tools/testing/selftests/kcmp/Makefile~selftests-fix-clean-target-in-kcmp-makefile
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -25,5 +25,4 @@ run_tests: all
 	@./kcmp_test || echo "kcmp_test: [FAIL]"
 
 clean:
-	rm -fr ./run_test
-	rm -fr ./test-file
+	$(RM) kcmp_test kcmp-test-file
_

Patches currently in -mm which might be from artagnon@gmail.com are

origin.patch

