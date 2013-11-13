From: akpm@linux-foundation.org
Subject: [merged] documentation-vm-zswaptxt-fix-typos.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:38:22 -0800
Message-ID: <5283e33e.Lcx1WTzze01Bpt5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3KMUiW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, mail@eworm.de

Subject: [merged] documentation-vm-zswaptxt-fix-typos.patch removed from -mm tree
To: mail@eworm.de,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:22 -0800


The patch titled
     Subject: Documentation/vm/zswap.txt: fix typos
has been removed from the -mm tree.  Its filename was
     documentation-vm-zswaptxt-fix-typos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christian Hesse <mail@eworm.de>
Subject: Documentation/vm/zswap.txt: fix typos

Signed-off-by: Christian Hesse <mail@eworm.de>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/zswap.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/zswap.txt~documentation-vm-zswaptxt-fix-typos Documentation/vm/zswap.txt
--- a/Documentation/vm/zswap.txt~documentation-vm-zswaptxt-fix-typos
+++ a/Documentation/vm/zswap.txt
@@ -8,7 +8,7 @@ significant performance improvement if r
 faster than reads from a swap device.
 
 NOTE: Zswap is a new feature as of v3.11 and interacts heavily with memory
-reclaim.  This interaction has not be fully explored on the large set of
+reclaim.  This interaction has not been fully explored on the large set of
 potential configurations and workloads that exist.  For this reason, zswap
 is a work in progress and should be considered experimental.
 
@@ -23,7 +23,7 @@ Some potential benefits:
     drastically reducing life-shortening writes.
 
 Zswap evicts pages from compressed cache on an LRU basis to the backing swap
-device when the compressed pool reaches it size limit.  This requirement had
+device when the compressed pool reaches its size limit.  This requirement had
 been identified in prior community discussions.
 
 To enabled zswap, the "enabled" attribute must be set to 1 at boot time.  e.g.
@@ -37,7 +37,7 @@ the backing swap device in the case that
 
 Zswap makes use of zbud for the managing the compressed memory pool.  Each
 allocation in zbud is not directly accessible by address.  Rather, a handle is
-return by the allocation routine and that handle must be mapped before being
+returned by the allocation routine and that handle must be mapped before being
 accessed.  The compressed memory pool grows on demand and shrinks as compressed
 pages are freed.  The pool is not preallocated.
 
@@ -56,7 +56,7 @@ in the swap_map goes to 0) the swap code
 via frontswap, to free the compressed entry.
 
 Zswap seeks to be simple in its policies.  Sysfs attributes allow for one user
-controlled policies:
+controlled policy:
 * max_pool_percent - The maximum percentage of memory that the compressed
     pool can occupy.
 
_

Patches currently in -mm which might be from mail@eworm.de are

origin.patch

