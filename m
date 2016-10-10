From: akpm@linux-foundation.org
Subject: [merged] mm-shmemc-constify-anon_ops.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:51 -0700
Message-ID: <57fc1a1f.2ppV97KGMz4jshRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37186 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbcJJWpw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem.c: constify anon_ops
has been removed from the -mm tree.  Its filename was
     mm-shmemc-constify-anon_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: mm/shmem.c: constify anon_ops

Every other dentry_operations instance is const, and this one might as
well be.

Link: http://lkml.kernel.org/r/1473890528-7009-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/shmem.c~mm-shmemc-constify-anon_ops mm/shmem.c
--- a/mm/shmem.c~mm-shmemc-constify-anon_ops
+++ a/mm/shmem.c
@@ -4078,7 +4078,7 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
 /* common code */
 
-static struct dentry_operations anon_ops = {
+static const struct dentry_operations anon_ops = {
 	.d_dname = simple_dname
 };
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are


