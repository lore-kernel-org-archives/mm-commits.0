Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6858C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 21:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbiCaVL6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 17:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241635AbiCaVL5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 17:11:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4357B1704EC
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 14:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03AB4B8224A
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 21:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA4EC340ED;
        Thu, 31 Mar 2022 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648761004;
        bh=zdvipYXpUMRnnbkKzmJSLrxdVHmN1QbnmJy1qIHJANA=;
        h=Date:To:From:Subject:From;
        b=UQe0sRJDs6IVwXQphqXpc7preTafj7EX19av3DXk+E3q2E3LEMqoKXKyKQ5edPl6c
         qwlC10Dldq4QiL6DPjuvj/IE5zMZmduxJpUmzQgV0s9uoiYSI8lTfEOrlN6Zf69h4X
         icRw2Ds+tucwqD772R7PJQy5z2m1emiD5tbx/9zI=
Date:   Thu, 31 Mar 2022 14:10:03 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220331211004.ACA4EC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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

mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
linux-next-git-rejects.patch

