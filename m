Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8004F68296
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 19:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JjQVELKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1912C433C8;
	Wed, 13 Dec 2023 19:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702496967;
	bh=CMXYMb6wc7ZB9NTFb87nW+EAKPnlxaIuP/D+LhPz1M8=;
	h=Date:To:From:Subject:From;
	b=JjQVELKVWmEjQ28iz0Ss7aQpe67dgpquSTp3/A1HwkxsVBWYc+mL5Jm1bQdcNcGsI
	 Y7rvYxQlBit+0fBQqZwX1XIf3mNUp0uOH3CHRRFsBHiD4HGXGyzR15ryMqUViQf9v4
	 KSsGx0kY+ySrX5dRwu8hsOh9Zp+0DlLSllSK0tAk=
Date: Wed, 13 Dec 2023 11:49:26 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-update-email-of-seongjae.patch added to mm-unstable branch
Message-Id: <20231213194926.E1912C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: update email of SeongJae
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-update-email-of-seongjae.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-update-email-of-seongjae.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: update email of SeongJae
Date: Wed, 13 Dec 2023 19:03:33 +0000

Patch series "mm/damon: misc updates for 6.8".

Update comments, tests, and documents for DAMON.


This patch (of 6):

SeongJae is using his kernel.org account for DAMON development.  Update
the old email addresses on the comments of DAMON source files.

Link: https://lkml.kernel.org/r/20231213190338.54146-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231213190338.54146-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h     |    2 +-
 mm/damon/core-test.h      |    2 +-
 mm/damon/core.c           |    2 +-
 mm/damon/dbgfs-test.h     |    2 +-
 mm/damon/dbgfs.c          |    2 +-
 mm/damon/modules-common.c |    2 +-
 mm/damon/vaddr-test.h     |    2 +-
 mm/damon/vaddr.c          |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-update-email-of-seongjae
+++ a/include/linux/damon.h
@@ -2,7 +2,7 @@
 /*
  * DAMON api
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifndef _DAMON_H_
--- a/mm/damon/core.c~mm-damon-update-email-of-seongjae
+++ a/mm/damon/core.c
@@ -2,7 +2,7 @@
 /*
  * Data Access Monitor
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon: " fmt
--- a/mm/damon/core-test.h~mm-damon-update-email-of-seongjae
+++ a/mm/damon/core-test.h
@@ -4,7 +4,7 @@
  *
  * Copyright 2019 Amazon.com, Inc. or its affiliates.  All rights reserved.
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifdef CONFIG_DAMON_KUNIT_TEST
--- a/mm/damon/dbgfs.c~mm-damon-update-email-of-seongjae
+++ a/mm/damon/dbgfs.c
@@ -2,7 +2,7 @@
 /*
  * DAMON Debugfs Interface
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon-dbgfs: " fmt
--- a/mm/damon/dbgfs-test.h~mm-damon-update-email-of-seongjae
+++ a/mm/damon/dbgfs-test.h
@@ -2,7 +2,7 @@
 /*
  * DAMON Debugfs Interface Unit Tests
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifdef CONFIG_DAMON_DBGFS_KUNIT_TEST
--- a/mm/damon/modules-common.c~mm-damon-update-email-of-seongjae
+++ a/mm/damon/modules-common.c
@@ -2,7 +2,7 @@
 /*
  * Common Primitives for DAMON Modules
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #include <linux/damon.h>
--- a/mm/damon/vaddr.c~mm-damon-update-email-of-seongjae
+++ a/mm/damon/vaddr.c
@@ -2,7 +2,7 @@
 /*
  * DAMON Primitives for Virtual Address Spaces
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #define pr_fmt(fmt) "damon-va: " fmt
--- a/mm/damon/vaddr-test.h~mm-damon-update-email-of-seongjae
+++ a/mm/damon/vaddr-test.h
@@ -4,7 +4,7 @@
  *
  * Copyright 2019 Amazon.com, Inc. or its affiliates.  All rights reserved.
  *
- * Author: SeongJae Park <sjpark@amazon.de>
+ * Author: SeongJae Park <sj@kernel.org>
  */
 
 #ifdef CONFIG_DAMON_VADDR_KUNIT_TEST
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch
mm-damon-update-email-of-seongjae.patch
mm-damon-core-test-test-max_nr_accesses-overflow-caused-divide-by-zero.patch
docs-mm-damon-design-place-execution-model-and-data-structures-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-context-directory-section-label.patch
docs-admin-guide-mm-damon-usage-add-links-to-sysfs-files-hierarchy.patch
docs-admin-guide-mm-damon-usage-use-a-list-for-state-sysfs-file-input-commands.patch

