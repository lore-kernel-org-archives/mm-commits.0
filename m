Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52352C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Apr 2022 21:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355126AbiDTV3c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Apr 2022 17:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345541AbiDTV3c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 20 Apr 2022 17:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23943424A9
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 14:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F043618E8
        for <mm-commits@vger.kernel.org>; Wed, 20 Apr 2022 21:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0015CC385A1;
        Wed, 20 Apr 2022 21:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650490004;
        bh=OAtU/X1a99dnRJsqjKvvXXiR7LPSatcPDKNfAk5HHqQ=;
        h=Date:To:From:Subject:From;
        b=Gv5FwZXnynEFmKqGE5jQ5XUGDL4D0qsRGKbsOSwMlmxhjTKyxiDUYlzecZd/Z/vvH
         TLvGhc8dt1N8+ckaYLyVlCrNLP7RHxiac0FGX0s7p5Jw7ixazm5B2OHR8Ae/pewUyk
         5lqqE1Eahn9jGNU3Tes1NuhUA1ylNDypyB0AcLeE=
Date:   Wed, 20 Apr 2022 14:26:43 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220420212644.0015CC385A1@smtp.kernel.org>
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

 fs/xattr.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/xattr.c~linux-next-git-rejects
+++ a/fs/xattr.c
@@ -566,13 +566,6 @@ int setxattr_copy(const char __user *nam
 			error = PTR_ERR(ctx->kvalue);
 			ctx->kvalue = NULL;
 		}
-<<<<<<< HEAD
-		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
-		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
-			posix_acl_fix_xattr_from_user(mnt_userns, d_inode(d),
-						      kvalue, size);
-=======
->>>>>>> linux-next/akpm-base
 	}
 
 	return error;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-khugepaged-introduce-khugepaged_enter_vma-helper-vs-maple-tree.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mglru-vs-maple-tree.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

