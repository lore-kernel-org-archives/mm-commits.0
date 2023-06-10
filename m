Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E120EC87FDC
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjFJAal (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjFJAaj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B623A91
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B856E64A94
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B126C433D2;
        Sat, 10 Jun 2023 00:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357037;
        bh=9glv2uLEinOdns+ZRGe8JiQEBaMUoHW4OMCUC2vrSVQ=;
        h=Date:To:From:Subject:From;
        b=0rjepVViRZHPbPAPLp2XtVKzUa5SxXONIqnjCMCjxjLutw0NmxKSzBbVnxI0HWcFT
         uI9aqzHiAueUuHd1aMc4zYhyHaHgSFxYQ9kC8uXwtU7bTrTZsJcq4dRRwRPU/ng3ii
         ZY4iaLBNSEI3/luYPf5VDy1v6O//c5uW3UC0KcfE=
Date:   Fri, 09 Jun 2023 17:30:36 -0700
To:     mm-commits@vger.kernel.org, angus.chen@jaguarmicro.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch removed from -mm tree
Message-Id: <20230610003037.1B126C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init-add-bdev-fs-printk-if-mount_block_root-failed-fix
has been removed from the -mm tree.  Its filename was
     init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch

This patch was dropped because it was folded into init-add-bdev-fs-printk-if-mount_block_root-failed.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-add-bdev-fs-printk-if-mount_block_root-failed-fix
Date: Thu May 18 12:58:30 PM PDT 2023

fix spelling in printk message

Cc: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/do_mounts.c~init-add-bdev-fs-printk-if-mount_block_root-failed-fix
+++ a/init/do_mounts.c
@@ -434,7 +434,7 @@ retry:
 		if (!num_fs)
 			pr_err("Can't find any bdev filesystem to be used for mount!\n");
 		else {
-			pr_err("List of all bdev filesystem:\n");
+			pr_err("List of all bdev filesystems:\n");
 			for (i = 0, p = fs_names; i < num_fs; i++, p += strlen(p)+1)
 				pr_err(" %s", p);
 			pr_err("\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed.patch
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

