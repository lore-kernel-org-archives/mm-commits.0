From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-remove-wrong-comment-from-userfaultfd_ctx_get.patch removed
 from -mm tree
Date: Fri, 10 Mar 2017 13:43:41 -0800
Message-ID: <58c31e0d.f/ssGIHbEwn7FT5Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38128 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932482AbdCJVnm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:43:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: remove wrong comment from userfaultfd_ctx_get()
has been removed from the -mm tree.  Its filename was
     userfaultfd-remove-wrong-comment-from-userfaultfd_ctx_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: userfaultfd: remove wrong comment from userfaultfd_ctx_get()

It's a void function, so there is no return value;

Link: http://lkml.kernel.org/r/20170309150817.7510-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-remove-wrong-comment-from-userfaultfd_ctx_get fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-remove-wrong-comment-from-userfaultfd_ctx_get
+++ a/fs/userfaultfd.c
@@ -138,8 +138,6 @@ out:
  * userfaultfd_ctx_get - Acquires a reference to the internal userfaultfd
  * context.
  * @ctx: [in] Pointer to the userfaultfd context.
- *
- * Returns: In case of success, returns not zero.
  */
 static void userfaultfd_ctx_get(struct userfaultfd_ctx *ctx)
 {
_

Patches currently in -mm which might be from david@redhat.com are


