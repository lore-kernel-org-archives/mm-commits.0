From: akpm@linux-foundation.org
Subject: [merged] tools-vm-fix-page-flags-build.patch removed from -mm
 tree
Date: Mon, 18 May 2015 11:44:12 -0700
Message-ID: <555a32fc.ufEgLJ9TCwyopoUs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbbERSoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 May 2015 14:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, n-horiguchi@ah.jp.nec.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm: fix page-flags build
has been removed from the -mm tree.  Its filename was
     tools-vm-fix-page-flags-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: tools/vm: fix page-flags build

libabikfs.a doesn't exist anymore, so we now need to link with libapi.a.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/vm/Makefile~tools-vm-fix-page-flags-build tools/vm/Makefile
--- a/tools/vm/Makefile~tools-vm-fix-page-flags-build
+++ a/tools/vm/Makefile
@@ -3,7 +3,7 @@
 TARGETS=page-types slabinfo page_owner_sort
 
 LIB_DIR = ../lib/api
-LIBS = $(LIB_DIR)/libapikfs.a
+LIBS = $(LIB_DIR)/libapi.a
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra -I../lib/
_

Patches currently in -mm which might be from ak@linux.intel.com are

mm-hwpoison-add-comment-describing-when-to-add-new-cases.patch
mm-hwpoison-remove-obsolete-notebook-todo-list.patch
hexdump-make-test-data-really-const.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

