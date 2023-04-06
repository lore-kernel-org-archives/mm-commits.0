Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9754C77B71
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjDFCdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbjDFCdj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:33:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF53A6190
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:33:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59CCA62D65
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:33:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5CDC433EF;
        Thu,  6 Apr 2023 02:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748417;
        bh=BOejeL817H4VOmcjVbDGp8RpZZUVh4AHApTDjzbzA08=;
        h=Date:To:From:Subject:From;
        b=L6t8uHz2/MO98WdYHRJvRzMxMKD5DsdMp4pBpbhRf+Wddx/Ve/nN9W+zAcFVOEOgl
         y7neBrHVfSwfqg5JS+NGdYrbQ0y+LZ2bSo0uI6hAHBPnbBKobfWe10FopUSCfLtLgn
         Z6HD8+RRk3iptch+lUwOu5RSr+Mz5hfV44KVNWI4=
Date:   Wed, 05 Apr 2023 19:33:37 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, lkp@intel.com,
        kirill@shutemov.name, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-treewide-redefine-max_order-sanely-fix-3-fix.patch removed from -mm tree
Message-Id: <20230406023337.AF5CDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-3-fix
has been removed from the -mm tree.  Its filename was
     mm-treewide-redefine-max_order-sanely-fix-3-fix.patch

This patch was dropped because it was folded into mm-treewide-redefine-max_order-sanely.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-treewide-redefine-max_order-sanely-fix-3-fix
Date: Sun Mar 19 11:36:07 AM PDT 2023

fix underlining

Reported-by: kernel test robot <lkp@intel.com>
  Link: https://lore.kernel.org/oe-kbuild-all/202303191025.VRCTk6mP-lkp@intel.com/
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/vmcoreinfo.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kdump/vmcoreinfo.rst~mm-treewide-redefine-max_order-sanely-fix-3-fix
+++ a/Documentation/admin-guide/kdump/vmcoreinfo.rst
@@ -190,7 +190,7 @@ information. Makedumpfile gets the start
 from this.
 
 (zone.free_area, MAX_ORDER + 1)
----------------------------
+-------------------------------
 
 Free areas descriptor. User-space tools use this value to iterate the
 free_area ranges. MAX_ORDER is used by the zone buddy allocator.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
mm-treewide-redefine-max_order-sanely.patch
mm-vmalloc-convert-vread-to-vread_iter-v8-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch
notifiers-add-tracepoints-to-the-notifiers-infrastructure-checkpatch-fixes.patch

