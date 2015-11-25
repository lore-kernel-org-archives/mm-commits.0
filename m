From: akpm@linux-foundation.org
Subject: [nacked] scripts-fix-the-sys-path-for-gdb-scripts.patch removed
 from -mm tree
Date: Wed, 25 Nov 2015 13:58:34 -0800
Message-ID: <56562f0a.va0b1xaKiJ0mVSVW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbKYV6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Nov 2015 16:58:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, jan.kiszka@siemens.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/vmlinux-gdb.py: fix the sys path for gdb scripts
has been removed from the -mm tree.  Its filename was
     scripts-fix-the-sys-path-for-gdb-scripts.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: scripts/gdb/vmlinux-gdb.py: fix the sys path for gdb scripts

The sys.path should be scripts/gdb, so that we can import linux lib
correctly.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/vmlinux-gdb.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gdb/vmlinux-gdb.py~scripts-fix-the-sys-path-for-gdb-scripts scripts/gdb/vmlinux-gdb.py
--- a/scripts/gdb/vmlinux-gdb.py~scripts-fix-the-sys-path-for-gdb-scripts
+++ a/scripts/gdb/vmlinux-gdb.py
@@ -13,7 +13,7 @@
 
 import os
 
-sys.path.insert(0, os.path.dirname(__file__) + "/scripts/gdb")
+sys.path.insert(0, os.path.dirname(__file__))
 
 try:
     gdb.parse_and_eval("0")
_

Patches currently in -mm which might be from yalin.wang2010@gmail.com are

mm-change-trace_mm_vmscan_writepage-proto-type.patch
mm-change-mm_vmscan_lru_shrink_inactive-proto-types.patch
mm-fix-kernel-crash-in-khugepaged-thread.patch

