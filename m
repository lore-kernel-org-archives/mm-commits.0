Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E94AC43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379561AbiFQCMd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379695AbiFQCM3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F8E64BE9
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 705EFB8269B
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054F3C3411A;
        Fri, 17 Jun 2022 02:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431942;
        bh=OQXY3/TEQ/R3L/zfDbg7Z6gVo3AgtDezSdBTmEcYynQ=;
        h=Date:To:From:Subject:From;
        b=zXb5lT3pPejAxNB+sxQz/FvXO/O5Zk8dzxqpyHN3vUsL+AMuuSTqetGjoNGxJeJaN
         NZWNO7LC9rsEpXc+e+ffFMGt0p6hAKBtOOvJPLiqXFw5RbjCEyP0/xVTbKYh6/lB9b
         LikKZMR1mBTGaXGSeABkHw/imOzoGUKIprrgH7zg=
Date:   Thu, 16 Jun 2022 19:12:21 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-tree-references.patch removed from -mm tree
Message-Id: <20220617021222.054F3C3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update MM tree references
has been removed from the -mm tree.  Its filename was
     maintainers-update-tree-references.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: update MM tree references
Date: Wed Jun 15 02:22:44 PM PDT 2022

Describe the new kernel.org location of the MM trees.

Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/MAINTAINERS~maintainers-update-tree-references
+++ a/MAINTAINERS
@@ -12846,9 +12846,8 @@ M:	Andrew Morton <akpm@linux-foundation.
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
-T:	quilt https://ozlabs.org/~akpm/mmotm/
-T:	quilt https://ozlabs.org/~akpm/mmots/
-T:	git git://github.com/hnaz/linux-mm.git
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	include/linux/gfp.h
 F:	include/linux/memory_hotplug.h
 F:	include/linux/mm.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-shrinkers-introduce-debugfs-interface-for-memory-shrinkers-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch
mm-factor-helpers-for-memory_failure_dev_pagemap-fix.patch
xfs-support-cow-in-fsdax-mode-fix.patch

