Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92611C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FF6B60F45
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 21:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhJJVUB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 17:20:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhJJVUB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 17:20:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0466D60F23;
        Sun, 10 Oct 2021 21:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633900682;
        bh=7/jpK9m/7wryhYE+ADPDaGQ2cbMDZxSxYv7xuJwWZ/A=;
        h=Date:From:To:Subject:From;
        b=X33ZoX+EdSaq/lxaeEpmJjTXhWuQYmNdtMQC8VaGxVmr2B0jbv5+nqbbz0vLNhMPf
         CoFq6DDr52PO3bRsLXDQZYuGSNiBfcpKB8ysjktpwcm6R3ggpXMEn/McShSWgxdfRQ
         836fcw9rCa/d5yyxEMq5HkLRpdx2KAFnS/CNlSJs=
Date:   Sun, 10 Oct 2021 14:18:01 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, Markov.Andrey@Dell.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  +
 ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch
 added to -mm tree
Message-ID: <20211010211801.5vfG2U2YF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix
has been added to the -mm tree.  Its filename is
     ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix

fix whitespace, per Joseph

Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: "Markov, Andrey" <Markov.Andrey@Dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix
+++ a/fs/ocfs2/alloc.c
@@ -7045,7 +7045,7 @@ void ocfs2_set_inode_data_inline(struct
 int ocfs2_convert_inline_data_to_extents(struct inode *inode,
 					 struct buffer_head *di_bh)
 {
-	int ret,has_data, num_pages = 0;
+	int ret, has_data, num_pages = 0;
 	int need_free = 0;
 	u32 bit_off, num;
 	handle_t *handle;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch
elfcore-correct-reference-to-config_uml-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

