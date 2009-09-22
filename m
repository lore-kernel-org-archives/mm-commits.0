From: akpm@linux-foundation.org
Subject: [merged] ksm-change-copyright-message.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:39:36 -0700
Message-ID: <200909222039.n8MKdae7003763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbZIVUmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, balbir@in.ibm.com, chrisw@redhat.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, lee.s


The patch titled
     ksm: change copyright message
has been removed from the -mm tree.  Its filename was
     ksm-change-copyright-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: change copyright message
From: Izik Eidus <ieidus@redhat.com>

Adding Hugh Dickins into the authors list.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/ksm.c~ksm-change-copyright-message mm/ksm.c
--- a/mm/ksm.c~ksm-change-copyright-message
+++ a/mm/ksm.c
@@ -4,11 +4,12 @@
  * This code enables dynamic sharing of identical pages found in different
  * memory areas, even if they are not shared by fork()
  *
- * Copyright (C) 2008 Red Hat, Inc.
+ * Copyright (C) 2008-2009 Red Hat, Inc.
  * Authors:
  *	Izik Eidus
  *	Andrea Arcangeli
  *	Chris Wright
+ *	Hugh Dickins
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
_

Patches currently in -mm which might be from ieidus@redhat.com are

origin.patch

