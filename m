Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392CBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 01:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiATBx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiATBx1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 20:53:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245D9C061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 17:53:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1870B81BFA
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 01:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE1FC004E1;
        Thu, 20 Jan 2022 01:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642643604;
        bh=T8DVnslPpiKYt2rKCEw6Qc4P9IgI8tGd7HvRapPY0nI=;
        h=Date:From:To:Subject:From;
        b=Lf6qMr6tpqkb06gHwIWLCRgD6mMD67MgYT9JqIlJLSlcHdzxSawqNwe4KILfBjCC2
         /YuaJImUh/4WsHd+yBDyKyr8rVVxFvpeX5DIpH5WaYU/ZX4lKa9Dl4rFuGSWvTfe9u
         zDW5RrLnyIgXkinpW0xqJi3dFDqlDBNMhCG/nam4=
Date:   Wed, 19 Jan 2022 17:53:24 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        elver@google.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 panic-use-error_report_end-tracepoint-on-warnings-fix.patch removed from
 -mm tree
Message-ID: <20220120015324.9gjObDtIQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: panic-use-error_report_end-tracepoint-on-warnings-fix
has been removed from the -mm tree.  Its filename was
     panic-use-error_report_end-tracepoint-on-warnings-fix.patch

This patch was dropped because it was folded into panic-use-error_report_end-tracepoint-on-warnings.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-use-error_report_end-tracepoint-on-warnings-fix

add comma to enum list, per Andy.

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/error_report.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/error_report.h~panic-use-error_report_end-tracepoint-on-warnings-fix
+++ a/include/trace/events/error_report.h
@@ -18,7 +18,7 @@
 enum error_detector {
 	ERROR_DETECTOR_KFENCE,
 	ERROR_DETECTOR_KASAN,
-	ERROR_DETECTOR_WARN
+	ERROR_DETECTOR_WARN,
 };
 
 #endif /* __ERROR_REPORT_DECLARE_TRACE_ENUMS_ONCE_ONLY */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

panic-use-error_report_end-tracepoint-on-warnings.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-fix.patch
sysctl-add-helper-to-register-a-sysctl-mount-point-fix.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const-fix.patch
proc-remove-pde_data-completely-fix.patch
proc-remove-pde_data-completely-fix-fix.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

