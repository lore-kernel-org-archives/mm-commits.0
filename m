Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807C9C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 06:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5645361178
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 06:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhDIGYY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:24:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhDIGYX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 02:24:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4160361178;
        Fri,  9 Apr 2021 06:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617949451;
        bh=R6rt/UaVNgVqCp3e/NuiAaBLSQUnFuDeSIvqJUWKYW4=;
        h=Date:From:To:Subject:From;
        b=l6ybugjh4A+XfaG5p4bn9sOsM2KRKG6wSigKIeG53LUGkT/WBjJdtmmI7PdjIsZLx
         W8RZY4Z6Xflczvh7k0Il33zNKCveNdEtrAV1j3J6PX4Uw/rEmcgmMBSFedaPUIPtj6
         6Vh41ShLxMVZO+6aDbvrDcBZPG/qV+USUID9gxMg=
Date:   Thu, 08 Apr 2021 23:24:10 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  [obsolete]
 kernelh-split-out-panic-and-oops-helpers-fix.patch removed from -mm tree
Message-ID: <20210409062410.qJZ-16EAS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernelh-split-out-panic-and-oops-helpers-fix
has been removed from the -mm tree.  Its filename was
     kernelh-split-out-panic-and-oops-helpers-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernelh-split-out-panic-and-oops-helpers-fix

more files need panic_notifier.h

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/enlighten.c        |    1 +
 drivers/video/fbdev/hyperv_fb.c |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/x86/xen/enlighten.c~kernelh-split-out-panic-and-oops-helpers-fix
+++ a/arch/x86/xen/enlighten.c
@@ -6,6 +6,7 @@
 #include <linux/cpu.h>
 #include <linux/kexec.h>
 #include <linux/slab.h>
+#include <linux/panic_notifier.h>
 
 #include <xen/xen.h>
 #include <xen/features.h>
--- a/drivers/video/fbdev/hyperv_fb.c~kernelh-split-out-panic-and-oops-helpers-fix
+++ a/drivers/video/fbdev/hyperv_fb.c
@@ -52,6 +52,7 @@
 #include <linux/completion.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
+#include <linux/panic_notifier.h>
 #include <linux/efi.h>
 #include <linux/console.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
lib-test_kasan_modulec-suppress-unused-var-warning.patch
scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

