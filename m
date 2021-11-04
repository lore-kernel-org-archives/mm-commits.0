Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA245C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C5161186
	for <mm-commits@archiver.kernel.org>; Thu,  4 Nov 2021 01:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhKDBub (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Nov 2021 21:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231206AbhKDBua (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Nov 2021 21:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7298B61186;
        Thu,  4 Nov 2021 01:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635990473;
        bh=IYR+KJ/VEC8yDcSyAVkTnpgX5RiQGxTNzgCCenBYDX0=;
        h=Date:From:To:Subject:From;
        b=a6ArQsZh6AiWBGjR+R23Bt3HX62bwfwC2cIu/1wyW6htb9MDU5p3WEG9nk5UjpIhB
         DJLPGBGh/vhWnhmtpYdBmA0oENizw7OcC/usStZAQMuHveAFXUvMdjGAnb0qLlDCik
         +Cb5H/kkzfc7duQKTFS5Vlou0YF2wbVedyZRGahE=
Date:   Wed, 03 Nov 2021 18:47:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20211104014753.OY90qeSUi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/sock.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/net/sock.h~linux-next-git-rejects
+++ a/include/net/sock.h
@@ -2840,21 +2840,14 @@ void sock_set_sndtimeo(struct sock *sk,
 
 int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
 
-<<<<<<< HEAD
-=======
 int sock_get_timeout(long timeo, void *optval, bool old_timeval);
 int sock_copy_user_timeval(struct __kernel_sock_timeval *tv,
 			   sockptr_t optval, int optlen, bool old_timeval);
 
->>>>>>> linux-next/akpm-base
 static inline bool sk_is_readable(struct sock *sk)
 {
 	if (sk->sk_prot->sock_is_readable)
 		return sk->sk_prot->sock_is_readable(sk);
 	return false;
 }
-<<<<<<< HEAD
-=======
-
->>>>>>> linux-next/akpm-base
 #endif	/* _SOCK_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-move-kvmalloc-related-functions-to-slabh-fix.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

