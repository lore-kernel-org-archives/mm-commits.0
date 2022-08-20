Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2D0C25B08
	for <mm-commits@archiver.kernel.org>; Sat, 20 Aug 2022 20:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiHTUkT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Aug 2022 16:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiHTUkT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Aug 2022 16:40:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F802C106
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 13:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 917E1B80AE8
        for <mm-commits@vger.kernel.org>; Sat, 20 Aug 2022 20:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107C1C433D6;
        Sat, 20 Aug 2022 20:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661028012;
        bh=4bymadQm6kvtrJ8mE6spWBN5JQx/FKT+wm8hX77h4CE=;
        h=Date:To:From:Subject:From;
        b=qx55aOHKLqoXNjKYN1vtyz4C7tdEZId6m4E14O+neGOEjoFfbI6eASrpEpvfwiTJ9
         8IOUQSH2wQtMpvDJzSzyab2ShDmGL6ekC9un4woUOzbBkCPLsapollBrmw2/vVVXry
         XRc7l4L1kQ/PbEBn1JK3t+s3XD1rT/H2Cp3mvD/Q=
Date:   Sat, 20 Aug 2022 13:40:11 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.patch removed from -mm tree
Message-Id: <20220820204012.107C1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.txt
has been removed from the -mm tree.  Its filename was
     memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix.txt
Date: Fri Aug 19 10:06:07 PM PDT 2022

mm/memory.c needs memory-tiers.h

Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~memory-tiering-hot-page-selection-with-hint-page-fault-latency-fix
+++ a/mm/memory.c
@@ -65,6 +65,7 @@
 #include <linux/elf.h>
 #include <linux/gfp.h>
 #include <linux/migrate.h>
+#include <linux/memory-tiers.h>
 #include <linux/string.h>
 #include <linux/debugfs.h>
 #include <linux/userfaultfd_k.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

asm-generic-sections-refactor-memory_intersects-fix.patch
procfs-add-path-to-proc-pid-fdinfo-fix.patch
zsmalloc-zs_object_copy-add-clarifying-comment-fix.patch
mm-oom_kill-add-trace-logs-in-process_mrelease-system-call-fix.patch
zsmalloc-zs_object_copy-replace-email-link-to-doc-checkpatch-fixes.patch
mm-demotion-add-support-for-explicit-memory-tiers-fix.patch

