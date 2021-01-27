Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CAF0C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 20:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D9D64D9A
	for <mm-commits@archiver.kernel.org>; Wed, 27 Jan 2021 20:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhA0U5J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Jan 2021 15:57:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233715AbhA0U4t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Jan 2021 15:56:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F56261601;
        Wed, 27 Jan 2021 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611780966;
        bh=njxjmbL45RAiPqATDDDoWdaIVYKGoJ7+QXs2ueBfTeM=;
        h=Date:From:To:Subject:From;
        b=p71C+Yl9CY3Mus/z3L3ZHUy0UqHDiSU/19Ax8DvweDtcPl2amhxN/GaaNU/okYjjr
         VoGWsARnhqkOd1FLQBq7Hh9QCEDb7N2cGkuxys0SrV1PMsHc1EVQVo18wOsPhBFALu
         yMRT7V7elebyeTSxlip2o0FjuSaH+8LjqgRyvn24=
Date:   Wed, 27 Jan 2021 12:56:05 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20210127205605.XoW1wFiNg%akpm@linux-foundation.org>
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

 include/linux/tty.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/tty.h~linux-next-git-rejects
+++ a/include/linux/tty.h
@@ -421,11 +421,8 @@ extern void tty_kclose(struct tty_struct
 extern int tty_dev_name_to_number(const char *name, dev_t *number);
 extern int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout);
 extern void tty_ldisc_unlock(struct tty_struct *tty);
-<<<<<<< HEAD
 extern ssize_t redirected_tty_write(struct kiocb *, struct iov_iter *);
-=======
 extern struct file *tty_release_redirect(struct tty_struct *tty);
->>>>>>> linux-next/akpm-base
 #else
 static inline void tty_kref_put(struct tty_struct *tty)
 { }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
bdi-use-might_alloc-fix.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
initramfs-panic-with-memory-information-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

