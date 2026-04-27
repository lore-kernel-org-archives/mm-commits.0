Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF323B47FF
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294510; cv=none; b=Tduso/0R8eMhjXT1qH/9ASzf5DJRCFI/QJxPN1VGC0ZUpFL4uSCAxionY5Biavz6t3RxveKmiDNMtxf09C5ou3SAgGxpqu8t+ptvmb5bRuQPD/3XdcustJUHJyZ9cEk8PhLu7smoUq/ebdh+Fiw/NmuY3V++lXIBHN8yv01CFM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294510; c=relaxed/simple;
	bh=rTc1sRijaAg0GZ5Ke5dvmtYx35z5K9hf4CrUAb8U/kg=;
	h=Date:To:From:Subject:Message-Id; b=E/uH6WbmYrk7ln9kuvF2W56Y/cUx4aQEOGWgdADh7tQMX3wAaPoEs7/Y4REGaG9jWyhSS4W7/SZ4heTNjDmHym/AUOkrnAVz1mxdtc/w5IeFkRRync3rvTPiK0z5EzZYgFe3d5OHLGlC1hbqcXdGpsakJgDtZllBGsFr8J9sWAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UYx9qVCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UYx9qVCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD53C2BCB7;
	Mon, 27 Apr 2026 12:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294510;
	bh=rTc1sRijaAg0GZ5Ke5dvmtYx35z5K9hf4CrUAb8U/kg=;
	h=Date:To:From:Subject:From;
	b=UYx9qVCB6yzQiJrIAUwmb0P866hDSkg1kqtBROgb3ZpSCsha332dXCPA1xnHP5TW8
	 bs97NBSuTDmj1DvxnrV9HwnCFWxjw3gf/bJW1uNCHYmZIyLi7J3Sqyw2M1VBaUfld7
	 JOiKsml5x/YuMnQwxpMYcvNX/QHeCwgAUgZxFLvg=
Date: Mon, 27 Apr 2026 05:55:09 -0700
To: mm-commits@vger.kernel.org,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-email-address.patch removed from -mm tree
Message-Id: <20260427125510.4FD53C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Liam's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -496,6 +496,7 @@ Leon Romanovsky <leon@kernel.org> <leon@
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
 Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
 Leo Yan <leo.yan@linux.dev> <leo.yan@linaro.org>
+Liam R. Howlett <liam@infradead.org> <Liam.Howlett@oracle.com>
 Liam Mark <quic_lmark@quicinc.com> <lmark@codeaurora.org>
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
--- a/MAINTAINERS~maintainers-update-email-address
+++ a/MAINTAINERS
@@ -15399,7 +15399,7 @@ F:	include/net/netns/mctp.h
 F:	net/mctp/
 
 MAPLE TREE
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 R:	Alice Ryhl <aliceryhl@google.com>
 R:	Andrew Ballance <andrewjballance@gmail.com>
 L:	maple-tree@lists.infradead.org
@@ -16759,7 +16759,7 @@ MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
@@ -16895,7 +16895,7 @@ MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
 R:	Suren Baghdasaryan <surenb@google.com>
@@ -16997,7 +16997,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -17044,7 +17044,7 @@ M:	David Hildenbrand <david@kernel.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 R:	Nico Pache <npache@redhat.com>
 R:	Ryan Roberts <ryan.roberts@arm.com>
 R:	Dev Jain <dev.jain@arm.com>
@@ -17082,7 +17082,7 @@ F:	tools/testing/selftests/mm/uffd-*.[ch
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
 R:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Liam R. Howlett <liam@infradead.org>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
 S:	Maintained
@@ -17096,7 +17096,7 @@ F:	rust/kernel/page.rs
 
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -17128,7 +17128,7 @@ F:	tools/testing/vma/
 MEMORY MAPPING - LOCKING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
@@ -17143,7 +17143,7 @@ F:	mm/mmap_lock.c
 
 MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Liam R. Howlett <liam@infradead.org>
 M:	Lorenzo Stoakes <ljs@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
@@ -23370,7 +23370,7 @@ RUST [ALLOC]
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


