Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE251C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 21:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCC9360FDA
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 21:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhJRWAT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWAT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7A460F6E;
        Mon, 18 Oct 2021 21:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634594287;
        bh=YqAGdrx7lQpl42QjQaW0KtgH04wfwBi5EIY2WyRhGSM=;
        h=Date:From:To:Subject:From;
        b=hPwu+L1HMT0YUkaRASIjhzqSM9JFJy3fQSviSnVcFPwlR4ddKhbJK0yMc6fPSCPWI
         BHAGJi5a4I+s03V0AQUo5HQOZqmVp8yFB7tGJM66v5tuOkuz3fCmtZv54tb/AZFS1O
         sPeyPZtmsHJtRthWj5B+NByLpk3pMyYMGqa0Uegc=
Date:   Mon, 18 Oct 2021 14:58:06 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com,
        jack@suse.cz, jlbec@evilplan.org, joseph.qi@linux.alibaba.com,
        junxiao.bi@oracle.com, mark@fasheh.com, Markov.Andrey@Dell.com,
        mm-commits@vger.kernel.org, piaojun@huawei.com
Subject:  [folded-merged]
 ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch
 removed from -mm tree
Message-ID: <20211018215806.EZ1NiVjhY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-data-corruption-after-conversion-from-inline-format-fix.patch

This patch was dropped because it was folded into ocfs2-fix-data-corruption-after-conversion-from-inline-format.patch

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

ocfs2-fix-data-corruption-after-conversion-from-inline-format.patch
elfcore-correct-reference-to-config_uml-fix.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

