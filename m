Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3572C47082
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbiDDVlF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379760AbiDDSB4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 14:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE1A26110
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 10:59:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9C34B818D7
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 17:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689B8C2BBE4;
        Mon,  4 Apr 2022 17:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649095197;
        bh=5kDxjVpg478Eip2iqrxillyutNEcAu4yjJy2z0IjLjM=;
        h=Date:To:From:Subject:From;
        b=elB6QK6ruUd7sIV73XIXHAMLUoO0R5uTcljXmnWdPZib8F1C55VV3sR4fX0HgPTUB
         g5IL6kmwoLqkg24+Hdfk6AV+BC1UiCsKXltvNYELFnzat12YhYsS7lsbbic1294fbD
         p3NNhmGH4DGjDPJyn4C7/U7H6sK13TlesTx6Z6ck=
Date:   Mon, 04 Apr 2022 10:59:56 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220404175957.689B8C2BBE4@smtp.kernel.org>
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

 Makefile |    6 ------
 1 file changed, 6 deletions(-)

--- a/Makefile~linux-next-git-rejects
+++ a/Makefile
@@ -443,10 +443,7 @@ else
 HOSTCC	= gcc
 HOSTCXX	= g++
 endif
-<<<<<<< HEAD
-=======
 HOSTRUSTC = rustc
->>>>>>> linux-next/akpm-base
 
 KBUILD_USERHOSTCFLAGS := -Wall -Wmissing-prototypes -Wstrict-prototypes \
 			 -O2 -fomit-frame-pointer -std=gnu11 \
@@ -454,8 +451,6 @@ KBUILD_USERHOSTCFLAGS := -Wall -Wmissing
 KBUILD_USERCFLAGS  := $(KBUILD_USERHOSTCFLAGS) $(USERCFLAGS)
 KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 
-<<<<<<< HEAD
-=======
 # These flags apply to all Rust code in the tree, including the kernel and
 # host programs.
 export rust_common_flags := --edition=2021 \
@@ -472,7 +467,6 @@ export rust_common_flags := --edition=20
 			    -Dclippy::needless_continue \
 			    -Wclippy::dbg_macro
 
->>>>>>> linux-next/akpm-base
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) $(HOSTCFLAGS)
 KBUILD_HOSTCXXFLAGS := -Wall -O2 $(HOST_LFS_CFLAGS) $(HOSTCXXFLAGS)
 KBUILD_HOSTRUSTFLAGS := $(rust_common_flags) -O -Cstrip=debuginfo \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

