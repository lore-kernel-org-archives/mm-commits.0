Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA5F3E8684
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 12:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776945870; cv=none; b=ZsIIUP4p9KjINu4xsYPgYT+XTzi9eFZZyh9dlF5zxZKKSBI3Yrd0ou7ig5omWJSLH+L3xFtcm7CmF8bRdchs8Y5OPXIlicxVxctNApYH0kjx4QcXTTTR387o9Hd9C7KQmvNXCxOfIbogM3yRFfXWc6h2+LAlDdwQ1t9ImfOeivI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776945870; c=relaxed/simple;
	bh=nraHOn26Ke9dJg+8iCsHAXR6vf6sf6pPx5hsm0pZyr0=;
	h=Date:To:From:Subject:Message-Id; b=iRJv5o7vZVrCcNlfo4ywc1yaV6Ez/iadGuwETgFEuVIH+PA3L06ULW6h94CBkEo1j3YPYKqXHuEyXNvxlTi1UZ+LwRSmbZmmeb4RDytNzxfwPCYdE3hQjJp4JtAOGRMb2bJTNe8WxBRQV9L+Bm/Y/bUcykgzG31GJfJeTPvgwYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tkPZoz0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tkPZoz0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24422C2BCAF;
	Thu, 23 Apr 2026 12:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776945870;
	bh=nraHOn26Ke9dJg+8iCsHAXR6vf6sf6pPx5hsm0pZyr0=;
	h=Date:To:From:Subject:From;
	b=tkPZoz0YFLSPjHCRK6MkcXQRpmsM/7HG70ep8Iz4xBMfRntRXttIPjOHDKCocjf/u
	 sQYndonnnkArV6/Nwi4bZIr30nG0rhA6Iymd43FjGrg3x/ty7UmUjPrUvHXX475SlE
	 9gf+YbPl2fDd4bTY2TKOlsEUTkRuAWg7j/KuKcgY=
Date: Thu, 23 Apr 2026 05:04:29 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20260423120430.24422C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Liam's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Liam R. Howlett" <liam@infradead.org>
Subject: MAINTAINERS: update Liam's email address
Date: Wed, 22 Apr 2026 14:43:10 -0400

Switching to private email address.  Update all contact information

Add an entry to mailmap at the same time.

Link: https://lore.kernel.org/20260422184310.2682901-1-liam@infradead.org
Signed-off-by: Liam R. Howlett <liam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                         |    1 +
 MAINTAINERS                      |   20 ++++++++++----------
 include/linux/maple_tree.h       |    2 +-
 lib/maple_tree.c                 |    2 +-
 lib/test_maple_tree.c            |    4 ++--
 tools/testing/radix-tree/maple.c |    2 +-
 6 files changed, 16 insertions(+), 15 deletions(-)

--- a/include/linux/maple_tree.h~maintainers-update-email-address
+++ a/include/linux/maple_tree.h
@@ -4,7 +4,7 @@
 /*
  * Maple Tree - An RCU-safe adaptive tree for storing ranges
  * Copyright (c) 2018-2022 Oracle
- * Authors:     Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * Authors:     Liam R. Howlett <liam@infradead.org>
  *              Matthew Wilcox <willy@infradead.org>
  */
 
--- a/lib/maple_tree.c~maintainers-update-email-address
+++ a/lib/maple_tree.c
@@ -2,7 +2,7 @@
 /*
  * Maple Tree implementation
  * Copyright (c) 2018-2022 Oracle Corporation
- * Authors: Liam R. Howlett <Liam.Howlett@oracle.com>
+ * Authors: Liam R. Howlett <liam@infradead.org>
  *	    Matthew Wilcox <willy@infradead.org>
  * Copyright (c) 2023 ByteDance
  * Author: Peng Zhang <zhangpeng.00@bytedance.com>
--- a/lib/test_maple_tree.c~maintainers-update-email-address
+++ a/lib/test_maple_tree.c
@@ -2,7 +2,7 @@
 /*
  * test_maple_tree.c: Test the maple tree API
  * Copyright (c) 2018-2022 Oracle Corporation
- * Author: Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * Author: Liam R. Howlett <liam@infradead.org>
  *
  * Any tests that only require the interface of the tree.
  */
@@ -4021,6 +4021,6 @@ static void __exit maple_tree_harvest(vo
 
 module_init(maple_tree_seed);
 module_exit(maple_tree_harvest);
-MODULE_AUTHOR("Liam R. Howlett <Liam.Howlett@Oracle.com>");
+MODULE_AUTHOR("Liam R. Howlett <liam@infradead.org>");
 MODULE_DESCRIPTION("maple tree API test module");
 MODULE_LICENSE("GPL");
--- a/.mailmap~maintainers-update-email-address
+++ a/.mailmap
@@ -495,6 +495,7 @@ Leon Romanovsky <leon@kernel.org> <leon@
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
 Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
 Leo Yan <leo.yan@linux.dev> <leo.yan@linaro.org>
+Liam R. Howlett <liam@infradead.org> <Liam.Howlett@oracle.com>
 Liam Mark <quic_lmark@quicinc.com> <lmark@codeaurora.org>
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
--- a/MAINTAINERS~maintainers-update-email-address
+++ a/MAINTAINERS
@@ -15397,7 +15397,7 @@ F:	include/net/netns/mctp.h
 F:	net/mctp/
 
 MAPLE TREE
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 R:	Alice Ryhl <aliceryhl@google.com>
 R:	Andrew Ballance <andrewjballance@gmail.com>
 L:	maple-tree@lists.infradead.org
@@ -16757,7 +16757,7 @@ MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
@@ -16893,7 +16893,7 @@ MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
@@ -16995,7 +16995,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -17042,7 +17042,7 @@ M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
@@ -17080,7 +17080,7 @@ F:	tools/testing/selftests/mm/uffd-*.[ch
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
@@ -17094,7 +17094,7 @@ F:	rust/kernel/page.rs
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -17126,7 +17126,7 @@ F:	tools/testing/vma/
 MEMORY MAPPING - LOCKING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
@@ -17141,7 +17141,7 @@ F:	mm/mmap_lock.c
 
 MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
@@ -23386,7 +23386,7 @@ RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Uladzislau Rezki <urezki@gmail.com>
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
--- a/tools/testing/radix-tree/maple.c~maintainers-update-email-address
+++ a/tools/testing/radix-tree/maple.c
@@ -2,7 +2,7 @@
 /*
  * maple_tree.c: Userspace testing for maple tree test-suite
  * Copyright (c) 2018-2022 Oracle Corporation
- * Author: Liam R. Howlett <Liam.Howlett@Oracle.com>
+ * Author: Liam R. Howlett <liam@infradead.org>
  *
  * Any tests that require internal knowledge of the tree or threads and other
  * difficult to handle in kernel tests.
_

Patches currently in -mm which might be from liam@infradead.org are

maintainers-update-email-address.patch

