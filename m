From: akpm@linux-foundation.org
Subject: +
 hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
 added to -mm tree
Date: Mon, 17 Feb 2020 14:27:29 -0800
Message-ID: <20200217222729.S6WqZnKzn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbgBQW1c (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 17 Feb 2020 17:27:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, sfr@canb.auug.org.au, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix

forward declare struct resv_map

Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb_cgroup.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/hugetlb_cgroup.h~hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix
+++ a/include/linux/hugetlb_cgroup.h
@@ -18,6 +18,8 @@
 #include <linux/mmdebug.h>
 
 struct hugetlb_cgroup;
+struct resv_map;
+
 /*
  * Minimum page order trackable by hugetlb cgroup.
  * At least 4 pages are necessary for all the tracking information.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
linux-next-rejects.patch
linux-next-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
