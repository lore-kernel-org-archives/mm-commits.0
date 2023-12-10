Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD986FAD
	for <mm-commits@vger.kernel.org>; Sun, 10 Dec 2023 18:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B7Yzvo3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB2AC433C8;
	Sun, 10 Dec 2023 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702233099;
	bh=6JOwzx5Jpgw9GFcnCH2chek2fU8m8cxO9ms/X7tCPGY=;
	h=Date:To:From:Subject:From;
	b=B7Yzvo3+s0LdfH0L3unI3x0nTjledwbkVnXm7mXUfEEjNeSSBOvpWBXuWV5Jmh2uu
	 jwPye0DuJxncRMi/qmLhtTyqvFDzy++gMp0uwg3RR7kmz072j+K/K0vQorKjEMb2ty
	 Kx5x4b4sNbHtfgYCLTi++Kph3k2Vj8CXU74gUWUo=
Date: Sun, 10 Dec 2023 10:31:38 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-typos-spellos-etc.patch added to mm-unstable branch
Message-Id: <20231210183139.1DB2AC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix typos/spellos etc.
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-fix-typos-spellos-etc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-typos-spellos-etc.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: maple_tree: fix typos/spellos etc.
Date: Sat, 9 Dec 2023 22:38:39 -0800

Fix typos/grammar and spellos in documentation.

Link: https://lkml.kernel.org/r/20231210063839.29967-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
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
@@ -5481,7 +5481,7 @@ int mas_preallocate(struct ma_state *mas
 		goto ask_now;
 	}
 
-	/* New root needs a singe node */
+	/* New root needs a single node */
 	if (unlikely(mte_is_root(mas->node)))
 		goto ask_now;
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

maple_tree-fix-typos-spellos-etc.patch
rapidio-tsi721-fix-kernel-doc-warnings.patch
freevxfs-bmap-fix-kernel-doc-warnings.patch
freevxfs-immed-fix-kernel-doc-param-name.patch
freevxfs-lookup-fix-function-params-kernel-doc.patch
init-kconfig-move-more-items-into-the-expert-menu.patch
usr-kconfig-fix-typos-of-its.patch

