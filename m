Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30740C7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbjFIXfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjFIXd0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E6249EA
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 791DD65D05
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD88CC433EF;
        Fri,  9 Jun 2023 23:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353429;
        bh=JCcNCR6F8lHILVfnRvN/M4NvOq9NGmy7C96wWG+CW9o=;
        h=Date:To:From:Subject:From;
        b=DQ4fuPWJDfKcvCKwRrgZUChPhxR8JefQxMwm/pRnNwJ8Be3hnqFCLx3P/spKf5hXQ
         UcOX2NMkllR6jM/U6fQ2T/PbpUEDhK5TMlNl3P9FjsN0yPXvsZMlnsMhLfmOECbEmn
         zHLRh9BanKrPtQ0BWDwQ9isxqxsFplBWA6x6uSWQ=
Date:   Fri, 09 Jun 2023 16:30:29 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-unneeded-header-files.patch removed from -mm tree
Message-Id: <20230609233029.CD88CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: remove unneeded header files
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unneeded-header-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: page_alloc: remove unneeded header files
Date: Sat, 3 Jun 2023 19:25:58 +0800

Remove some unneeded header files. No functional change intended.

Link: https://lkml.kernel.org/r/20230603112558.213694-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-unneeded-header-files
+++ a/mm/page_alloc.c
@@ -26,7 +26,6 @@
 #include <linux/kmsan.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
-#include <linux/pagevec.h>
 #include <linux/ratelimit.h>
 #include <linux/oom.h>
 #include <linux/topology.h>
@@ -36,8 +35,6 @@
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
-#include <linux/sort.h>
-#include <linux/pfn.h>
 #include <linux/fault-inject.h>
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
@@ -52,7 +49,6 @@
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
 #include <linux/lockdep.h>
-#include <linux/nmi.h>
 #include <linux/psi.h>
 #include <linux/khugepaged.h>
 #include <linux/delayacct.h>
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch
mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch
memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch

