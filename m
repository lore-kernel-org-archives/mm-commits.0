Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8F8C77B7A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 20:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232490AbjFAUsV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 16:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbjFAUsO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 16:48:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7301B99
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 13:48:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB309618EE
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 20:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1E9C433D2;
        Thu,  1 Jun 2023 20:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685652492;
        bh=el6gOXGTe+sSuWHvzbfOduvWem+ewgpMgmk4XLEkbD8=;
        h=Date:To:From:Subject:From;
        b=1cjEQxE66JvmHMXPYYLT2w/NJ9kgxjyMPfyWuycC6F1t6QWzWsidodlX0brk7qlyO
         ep1j6aANBqTHcvMo/2BSWc+fpbI0siNSfXJXAwFb21AjJ+xol/M+1YkiHCsvGCuxVr
         2ZaDFynQZYVMCK6XiNwasShItJjEq7njP4cQ9rvc=
Date:   Thu, 01 Jun 2023 13:48:11 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-multiple-zpools-support-fix.patch removed from -mm tree
Message-Id: <20230601204812.3F1E9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-zswap-multiple-zpools-support-fix
has been removed from the -mm tree.  Its filename was
     mm-zswap-multiple-zpools-support-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-zswap-multiple-zpools-support-fix
Date: Wed May 31 03:24:44 PM PDT 2023

fix Kconfig text, per Yu Zhao

Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-zswap-multiple-zpools-support-fix
+++ a/mm/Kconfig
@@ -64,7 +64,7 @@ config ZSWAP_NR_ZPOOLS_ORDER
 	default 0
 	depends on ZSWAP
 	help
-	  This options determines the number of zpools to use for zswap, it
+	  This option determines the number of zpools to use for zswap, it
 	  will be 1 << CONFIG_ZSWAP_NR_ZPOOLS_ORDER.
 
 	  Having multiple zpools helps with concurrency and lock contention
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

