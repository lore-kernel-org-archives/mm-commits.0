From: akpm@linux-foundation.org
Subject: [merged] cpumask-remove-incorrect-information-from-comment.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:09 -0700
Message-ID: <56f2d535.K347DQP+HHgxEJbp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbcCWRlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiggers3@gmail.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: cpumask: remove incorrect information from comment
has been removed from the -mm tree.  Its filename was
     cpumask-remove-incorrect-information-from-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Biggers <ebiggers3@gmail.com>
Subject: cpumask: remove incorrect information from comment

Since commit cdfdef75e795f ("cpumask: only allocate nr_cpumask_bits."),
this comment above cpumask_size() is no longer relevant.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpumask.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/cpumask.h~cpumask-remove-incorrect-information-from-comment include/linux/cpumask.h
--- a/include/linux/cpumask.h~cpumask-remove-incorrect-information-from-comment
+++ a/include/linux/cpumask.h
@@ -607,8 +607,6 @@ static inline int cpulist_parse(const ch
 
 /**
  * cpumask_size - size to allocate for a 'struct cpumask' in bytes
- *
- * This will eventually be a runtime variable, depending on nr_cpu_ids.
  */
 static inline size_t cpumask_size(void)
 {
_

Patches currently in -mm which might be from ebiggers3@gmail.com are


