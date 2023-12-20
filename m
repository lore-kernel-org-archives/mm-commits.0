Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6CD4D125
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tDU8l4/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D99C433C7;
	Wed, 20 Dec 2023 22:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112565;
	bh=7FtSTDoQgo4yJLmnnScz/oqcXPgMPQRzRV5QA7dGgKg=;
	h=Date:To:From:Subject:From;
	b=tDU8l4/dMZXZWkUZwiZk2BuCwYco19Yu0ayZ+E+f53q6Dp0eFTLsGrzCPiSga7qVD
	 tj/a7JyRqsOYf245oihp2D+bvwyf+soTDNwOgsEP3IbDaZJjlJCOpg71YT9TJ5GGCq
	 lKIj/98wztrdECKlm0f1F1aK9O4dQS1/gw0cqK40=
Date: Wed, 20 Dec 2023 14:49:24 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-update-email-of-seongjae.patch removed from -mm tree
Message-Id: <20231220224925.03D99C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: update email of SeongJae
has been removed from the -mm tree.  Its filename was
     mm-damon-update-email-of-seongjae.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


