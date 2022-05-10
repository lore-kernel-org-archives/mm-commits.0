Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37F0C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 00:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbiEJAn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 20:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiEJAn6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 20:43:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1B61DEC5D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 17:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79527B819F0
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 00:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C5C385C2;
        Tue, 10 May 2022 00:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652143201;
        bh=TxOpLBwVZe2RINml2He8jU+ix+2iirH9XOXiGAeCczs=;
        h=Date:To:From:Subject:From;
        b=pZSDXq1Aej5iVZg9tlMxpfOAPd7kp3wNNGqZHgdh0D4NMoW9/DjzAv3JJCMbEnJb3
         tQ0IuNkleliDpyfOrJOlb+P8bBzynQvdpwNT1961BtjuUU9ooPiiz8oDeC569AMi2t
         WLSZU8rXlZeRuBJ4LLeuIs0CDVC/hPsadAm1LkR0=
Date:   Mon, 09 May 2022 17:40:00 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        neilb@suse.de, mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-create-new-mm-swaph-header-file-fix.patch removed from -mm tree
Message-Id: <20220510004001.0A3C5C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-create-new-mm-swaph-header-file-fix
has been removed from the -mm tree.  Its filename was
     mm-create-new-mm-swaph-header-file-fix.patch

This patch was dropped because it was folded into mm-create-new-mm-swaph-header-file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-create-new-mm-swaph-header-file-fix

mm/memory-failure.c needs mm/swap.h

Cc: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: NeilBrown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-create-new-mm-swaph-header-file-fix
+++ a/mm/memory-failure.c
@@ -59,6 +59,7 @@
 #include <linux/page-isolation.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
+#include "swap.h"
 #include "internal.h"
 #include "ras/ras_event.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-create-new-mm-swaph-header-file.patch
mm-page_alloc-cache-the-result-of-node_dirty_ok-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
kfence-enable-check-kfence-canary-on-panic-via-boot-param-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-vmscan-not-necessary-to-re-init-the-list-for-each-iteration-fix.patch
mm-make-minimum-slab-alignment-a-runtime-property-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

