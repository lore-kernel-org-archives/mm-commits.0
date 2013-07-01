From: akpm@linux-foundation.org
Subject: + selftests-add-gitignore-for-vm.patch added to -mm tree
Date: Mon, 01 Jul 2013 13:45:52 -0700
Message-ID: <51d1ea80.ZN5Z+8YvD2lZybw2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab3GAUpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 16:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dyoung@redhat.com, artagnon@gmail.com

Subject: + selftests-add-gitignore-for-vm.patch added to -mm tree
To: artagnon@gmail.com,dyoung@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 13:45:52 -0700


The patch titled
     Subject: selftests: add .gitignore for vm
has been added to the -mm tree.  Its filename is
     selftests-add-gitignore-for-vm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ selftests-add-gitignore-for-vm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ selftests-add-gitignore-for-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

selftests-add-gitignore-for-vm.patch
selftests-fix-clean-target-in-kcmp-makefile.patch
selftests-add-gitignore-for-kcmp.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

