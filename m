From: akpm@linux-foundation.org
Subject: [merged] selftests-add-gitignore-for-vm.patch removed from -mm
 tree
Date: Mon, 08 Jul 2013 12:37:28 -0700
Message-ID: <51db14f8.DK5Jc75CUr6k6mAq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab3GHTh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com, artagnon@gmail.com

Subject: [merged] selftests-add-gitignore-for-vm.patch removed from -mm tree
To: artagnon@gmail.com,dyoung@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:28 -0700


The patch titled
     Subject: selftests: add .gitignore for vm
has been removed from the -mm tree.  Its filename was
     selftests-add-gitignore-for-vm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ramkumar Ramachandra <artagnon@gmail.com>
Subject: selftests: add .gitignore for vm

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/.gitignore |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN /dev/null tools/testing/selftests/vm/.gitignore
--- /dev/null
+++ a/tools/testing/selftests/vm/.gitignore
@@ -0,0 +1,4 @@
+hugepage-mmap
+hugepage-shm
+map_hugetlb
+thuge-gen
_

Patches currently in -mm which might be from artagnon@gmail.com are

origin.patch

