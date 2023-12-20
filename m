Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017BA208A8
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="arLn0zcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4EFC433C7;
	Wed, 20 Dec 2023 22:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112558;
	bh=VrOCE+D151Opt3SokMZOROBzX6W1SaQgOMgTooLObWM=;
	h=Date:To:From:Subject:From;
	b=arLn0zcqgud57xV8DFHDmli46OxpVuAnpE9SGb7CAapT7UGhVm0sA4IQxEjquC3sU
	 mnLSE7rDK2pJq2CARWjSSjuVkzd6gaMwqKB5yVry6gOgV5GxdKB4e6QaAwpl+tQ8cs
	 3/dqMg5MnyvsllnYAlhZKDPza8cfNcfFVoJkHB/k=
Date: Wed, 20 Dec 2023 14:49:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-typos-spellos-etc.patch removed from -mm tree
Message-Id: <20231220224918.BE4EFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix typos/spellos etc
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-typos-spellos-etc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: maple_tree: fix typos/spellos etc
Date: Sat, 9 Dec 2023 22:38:39 -0800

Fix typos/grammar and spellos in documentation.

Link: https://lkml.kernel.org/r/20231210063839.29967-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-typos-spellos-etc
+++ a/lib/maple_tree.c
@@ -16,8 +16,8 @@
  * and are simply the slot index + the minimum of the node.
  *
  * In regular B-Tree terms, pivots are called keys.  The term pivot is used to
- * indicate that the tree is specifying ranges,  Pivots may appear in the
- * subtree with an entry attached to the value where as keys are unique to a
+ * indicate that the tree is specifying ranges.  Pivots may appear in the
+ * subtree with an entry attached to the value whereas keys are unique to a
  * specific position of a B-tree.  Pivot values are inclusive of the slot with
  * the same index.
  *
@@ -2500,7 +2500,7 @@ static inline void mast_set_split_parent
 }
 
 /*
- * mas_topiary_node() - Dispose of a singe node
+ * mas_topiary_node() - Dispose of a single node
  * @mas: The maple state for pushing nodes
  * @enode: The encoded maple node
  * @in_rcu: If the tree is in rcu mode
@@ -5492,7 +5492,7 @@ int mas_preallocate(struct ma_state *mas
 		goto ask_now;
 	}
 
-	/* New root needs a singe node */
+	/* New root needs a single node */
 	if (unlikely(mte_is_root(mas->node)))
 		goto ask_now;
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch
init-kconfig-move-more-items-into-the-expert-menu.patch
usr-kconfig-fix-typos-of-its.patch
stacktrace-fix-kernel-doc-typo.patch
nilfs2-cpfile-fix-some-kernel-doc-warnings.patch

