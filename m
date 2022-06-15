Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E052FC43334
	for <mm-commits@archiver.kernel.org>; Wed, 15 Jun 2022 21:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349687AbiFOV2o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jun 2022 17:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350013AbiFOV2n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jun 2022 17:28:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB3E56238
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 14:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6DC85CE22ED
        for <mm-commits@vger.kernel.org>; Wed, 15 Jun 2022 21:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854EEC3411A;
        Wed, 15 Jun 2022 21:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655328518;
        bh=/g7GxQHsre2Pzxcf4dnNg3FH7J1oGEiy8mANTA6D+ow=;
        h=Date:To:From:Subject:From;
        b=2hpdUQxpdP5fgMmU+EVERUFfpiC99kLoc3G5IgcLVsv6FaU1VLbnYH2fXqkmRFfxy
         MmHfpTqhNywSSLN+s7WPpVdCKLAli7CSwJ/MIL24zLm8cVbOaJ4SgyNPoiEF/6LmUT
         XiiLkJ7u1JX6OmaPiOBqbEYUvQWb463X9QIrf5xE=
Date:   Wed, 15 Jun 2022 14:28:37 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, gregkh@linuxfoundation.org, david@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-tree-references.patch added to mm-hotfixes-unstable branch
Message-Id: <20220615212838.854EEC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update tree references
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-tree-references.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-tree-references.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: update tree references
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

maintainers-update-tree-references.patch
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

