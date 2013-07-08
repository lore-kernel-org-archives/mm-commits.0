From: akpm@linux-foundation.org
Subject: [merged] selftests-add-gitignore-for-kcmp.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:37:32 -0700
Message-ID: <51db14fc.MT5P4xEGd2rZizlu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHThc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com, artagnon@gmail.com

Subject: [merged] selftests-add-gitignore-for-kcmp.patch removed from -mm tree
To: artagnon@gmail.com,dyoung@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:32 -0700


The patch titled
     Subject: selftests: add .gitignore for kcmp
has been removed from the -mm tree.  Its filename was
     selftests-add-gitignore-for-kcmp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ramkumar Ramachandra <artagnon@gmail.com>
Subject: selftests: add .gitignore for kcmp

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kcmp/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff -puN /dev/null tools/testing/selftests/kcmp/.gitignore
--- /dev/null
+++ a/tools/testing/selftests/kcmp/.gitignore
@@ -0,0 +1,2 @@
+kcmp_test
+kcmp-test-file
_

Patches currently in -mm which might be from artagnon@gmail.com are

origin.patch

