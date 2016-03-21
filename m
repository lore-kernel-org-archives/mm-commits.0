From: akpm@linux-foundation.org
Subject: [merged] fix-my-email-addresses.patch removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:08 -0700
Message-ID: <56f04044.8Jzcn4TTKxZ83g6r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbcCUT4g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix Christoph's email addresses
has been removed from the -mm tree.  Its filename was
     fix-my-email-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: fix Christoph's email addresses

There are various email addresses for me throughout the kernel. Use the
one that will always be valid.

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v1/cgroups.txt |    2 +-
 Documentation/cgroup-v1/cpusets.txt |    2 +-
 MAINTAINERS                         |    2 +-
 arch/ia64/include/asm/rwsem.h       |    2 +-
 include/linux/quicklist.h           |    2 +-
 mm/mmu_notifier.c                   |    2 +-
 mm/quicklist.c                      |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN Documentation/cgroup-v1/cgroups.txt~fix-my-email-addresses Documentation/cgroup-v1/cgroups.txt
--- a/Documentation/cgroup-v1/cgroups.txt~fix-my-email-addresses
+++ a/Documentation/cgroup-v1/cgroups.txt
@@ -8,7 +8,7 @@ Original copyright statements from cpuse
 Portions Copyright (C) 2004 BULL SA.
 Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.
 Modified by Paul Jackson <pj@sgi.com>
-Modified by Christoph Lameter <clameter@sgi.com>
+Modified by Christoph Lameter <cl@linux.com>
 
 CONTENTS:
 =========
diff -puN Documentation/cgroup-v1/cpusets.txt~fix-my-email-addresses Documentation/cgroup-v1/cpusets.txt
--- a/Documentation/cgroup-v1/cpusets.txt~fix-my-email-addresses
+++ a/Documentation/cgroup-v1/cpusets.txt
@@ -6,7 +6,7 @@ Written by Simon.Derr@bull.net
 
 Portions Copyright (c) 2004-2006 Silicon Graphics, Inc.
 Modified by Paul Jackson <pj@sgi.com>
-Modified by Christoph Lameter <clameter@sgi.com>
+Modified by Christoph Lameter <cl@linux.com>
 Modified by Paul Menage <menage@google.com>
 Modified by Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
 
diff -puN MAINTAINERS~fix-my-email-addresses MAINTAINERS
--- a/MAINTAINERS~fix-my-email-addresses
+++ a/MAINTAINERS
@@ -8473,7 +8473,7 @@ F:	include/crypto/pcrypt.h
 
 PER-CPU MEMORY ALLOCATOR
 M:	Tejun Heo <tj@kernel.org>
-M:	Christoph Lameter <cl@linux-foundation.org>
+M:	Christoph Lameter <cl@linux.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git
 S:	Maintained
 F:	include/linux/percpu*.h
diff -puN arch/ia64/include/asm/rwsem.h~fix-my-email-addresses arch/ia64/include/asm/rwsem.h
--- a/arch/ia64/include/asm/rwsem.h~fix-my-email-addresses
+++ a/arch/ia64/include/asm/rwsem.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2003 Ken Chen <kenneth.w.chen@intel.com>
  * Copyright (C) 2003 Asit Mallick <asit.k.mallick@intel.com>
- * Copyright (C) 2005 Christoph Lameter <clameter@sgi.com>
+ * Copyright (C) 2005 Christoph Lameter <cl@linux.com>
  *
  * Based on asm-i386/rwsem.h and other architecture implementation.
  *
diff -puN include/linux/quicklist.h~fix-my-email-addresses include/linux/quicklist.h
--- a/include/linux/quicklist.h~fix-my-email-addresses
+++ a/include/linux/quicklist.h
@@ -5,7 +5,7 @@
  * as needed after allocation when they are freed. Per cpu lists of pages
  * are kept that only contain node local pages.
  *
- * (C) 2007, SGI. Christoph Lameter <clameter@sgi.com>
+ * (C) 2007, SGI. Christoph Lameter <cl@linux.com>
  */
 #include <linux/kernel.h>
 #include <linux/gfp.h>
diff -puN mm/mmu_notifier.c~fix-my-email-addresses mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~fix-my-email-addresses
+++ a/mm/mmu_notifier.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2008  Qumranet, Inc.
  *  Copyright (C) 2008  SGI
- *             Christoph Lameter <clameter@sgi.com>
+ *             Christoph Lameter <cl@linux.com>
  *
  *  This work is licensed under the terms of the GNU GPL, version 2. See
  *  the COPYING file in the top-level directory.
diff -puN mm/quicklist.c~fix-my-email-addresses mm/quicklist.c
--- a/mm/quicklist.c~fix-my-email-addresses
+++ a/mm/quicklist.c
@@ -8,7 +8,7 @@
  * improved on it.
  *
  * Copyright (C) 2007 SGI,
- * 	Christoph Lameter <clameter@sgi.com>
+ * 	Christoph Lameter <cl@linux.com>
  * 		Generalized, added support for multiple lists and
  * 		constructors / destructors.
  */
_

Patches currently in -mm which might be from cl@linux.com are


