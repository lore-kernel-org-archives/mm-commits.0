From: akpm@linux-foundation.org
Subject: [folded-merged]
 userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix.patch removed
 from -mm tree
Date: Thu, 09 Mar 2017 16:13:00 -0800
Message-ID: <58c1ef8c.GH8w9gy2pXDWU0WJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752459AbdCJANC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:13:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: documentation fixup after removal of UFFD_EVENT_EXIT
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix.patch

This patch was dropped because it was folded into userfaultfd-non-cooperative-rollback-userfaultfd_exit.patch

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: documentation fixup after removal of UFFD_EVENT_EXIT

Link: http://lkml.kernel.org/r/1488345437-4364-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/userfaultfd.txt |    4 ----
 1 file changed, 4 deletions(-)

diff -puN Documentation/vm/userfaultfd.txt~userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix Documentation/vm/userfaultfd.txt
--- a/Documentation/vm/userfaultfd.txt~userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix
+++ a/Documentation/vm/userfaultfd.txt
@@ -172,10 +172,6 @@ the same read(2) protocol as for the pag
 manager has to explicitly enable these events by setting appropriate
 bits in uffdio_api.features passed to UFFDIO_API ioctl:
 
-UFFD_FEATURE_EVENT_EXIT - enable notification about exit() of the
-non-cooperative process. When the monitored process exits, the uffd
-manager will get UFFD_EVENT_EXIT.
