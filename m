Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B42AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 23:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiAaX3i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:29:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48362 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiAaX3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 18:29:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0886560C16
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 23:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DFDC340E8;
        Mon, 31 Jan 2022 23:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643671777;
        bh=nuZoBsB5fxweqp7LEPKyFtc2PIwSMyIU5BN1yVWLo84=;
        h=Date:To:From:Subject:From;
        b=OcTSZlsASCGLZcy9qddMgosrj1JM93x19LV9BiTyylOuYI6O2/siwh7ksL3NxfiZ6
         agJH4vtRVZgtwSNiLAWOkivXkoiD3N7H9aotEMgvcdK204Eu3JPeMlTFJawpoIHy7d
         vOZQKi5muQd+KPPEU2hHSvthJ1zYTYihS/qpls7g=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 15:29:35 -0800
Date:   Mon, 31 Jan 2022 15:29:35 -0800
To:     mm-commits@vger.kernel.org, zhanglianjie@uniontech.com,
        yzaikin@google.com, mcgrof@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch added to -mm tree
Message-Id: <20220131232936.34DFDC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes

WARNING: please, no spaces at the start of a line
#249: FILE: mm/page-writeback.c:2089:
+    {$

ERROR: code indent should use tabs where possible
#250: FILE: mm/page-writeback.c:2090:
+        .procname   = "dirty_background_ratio",$

WARNING: please, no spaces at the start of a line
#250: FILE: mm/page-writeback.c:2090:
+        .procname   = "dirty_background_ratio",$

ERROR: code indent should use tabs where possible
#251: FILE: mm/page-writeback.c:2091:
+        .data       = &dirty_background_ratio,$

WARNING: please, no spaces at the start of a line
#251: FILE: mm/page-writeback.c:2091:
+        .data       = &dirty_background_ratio,$

ERROR: code indent should use tabs where possible
#252: FILE: mm/page-writeback.c:2092:
+        .maxlen     = sizeof(dirty_background_ratio),$

WARNING: please, no spaces at the start of a line
#252: FILE: mm/page-writeback.c:2092:
+        .maxlen     = sizeof(dirty_background_ratio),$

ERROR: code indent should use tabs where possible
#253: FILE: mm/page-writeback.c:2093:
+        .mode       = 0644,$

WARNING: please, no spaces at the start of a line
#253: FILE: mm/page-writeback.c:2093:
+        .mode       = 0644,$

ERROR: code indent should use tabs where possible
#254: FILE: mm/page-writeback.c:2094:
+        .proc_handler   = dirty_background_ratio_handler,$

WARNING: please, no spaces at the start of a line
#254: FILE: mm/page-writeback.c:2094:
+        .proc_handler   = dirty_background_ratio_handler,$

ERROR: code indent should use tabs where possible
#255: FILE: mm/page-writeback.c:2095:
+        .extra1     = SYSCTL_ZERO,$

WARNING: please, no spaces at the start of a line
#255: FILE: mm/page-writeback.c:2095:
+        .extra1     = SYSCTL_ZERO,$

ERROR: code indent should use tabs where possible
#256: FILE: mm/page-writeback.c:2096:
+        .extra2     = SYSCTL_ONE_HUNDRED,$

WARNING: please, no spaces at the start of a line
#256: FILE: mm/page-writeback.c:2096:
+        .extra2     = SYSCTL_ONE_HUNDRED,$

WARNING: please, no spaces at the start of a line
#257: FILE: mm/page-writeback.c:2097:
+    },$

WARNING: please, no spaces at the start of a line
#258: FILE: mm/page-writeback.c:2098:
+    {$

ERROR: code indent should use tabs where possible
#259: FILE: mm/page-writeback.c:2099:
+        .procname   = "dirty_background_bytes",$

WARNING: please, no spaces at the start of a line
#259: FILE: mm/page-writeback.c:2099:
+        .procname   = "dirty_background_bytes",$

ERROR: code indent should use tabs where possible
#260: FILE: mm/page-writeback.c:2100:
+        .data       = &dirty_background_bytes,$

WARNING: please, no spaces at the start of a line
#260: FILE: mm/page-writeback.c:2100:
+        .data       = &dirty_background_bytes,$

ERROR: code indent should use tabs where possible
#261: FILE: mm/page-writeback.c:2101:
+        .maxlen     = sizeof(dirty_background_bytes),$

WARNING: please, no spaces at the start of a line
#261: FILE: mm/page-writeback.c:2101:
+        .maxlen     = sizeof(dirty_background_bytes),$

ERROR: code indent should use tabs where possible
#262: FILE: mm/page-writeback.c:2102:
+        .mode       = 0644,$

WARNING: please, no spaces at the start of a line
#262: FILE: mm/page-writeback.c:2102:
+        .mode       = 0644,$

ERROR: code indent should use tabs where possible
#263: FILE: mm/page-writeback.c:2103:
+        .proc_handler   = dirty_background_bytes_handler,$

WARNING: please, no spaces at the start of a line
#263: FILE: mm/page-writeback.c:2103:
+        .proc_handler   = dirty_background_bytes_handler,$

ERROR: code indent should use tabs where possible
#264: FILE: mm/page-writeback.c:2104:
+        .extra1     = SYSCTL_LONG_ONE,$

WARNING: please, no spaces at the start of a line
#264: FILE: mm/page-writeback.c:2104:
+        .extra1     = SYSCTL_LONG_ONE,$

WARNING: please, no spaces at the start of a line
#265: FILE: mm/page-writeback.c:2105:
+    },$

WARNING: please, no spaces at the start of a line
#266: FILE: mm/page-writeback.c:2106:
+    {$

ERROR: code indent should use tabs where possible
#267: FILE: mm/page-writeback.c:2107:
+        .procname   = "dirty_ratio",$

WARNING: please, no spaces at the start of a line
#267: FILE: mm/page-writeback.c:2107:
+        .procname   = "dirty_ratio",$

ERROR: code indent should use tabs where possible
#268: FILE: mm/page-writeback.c:2108:
+        .data       = &vm_dirty_ratio,$

WARNING: please, no spaces at the start of a line
#268: FILE: mm/page-writeback.c:2108:
+        .data       = &vm_dirty_ratio,$

ERROR: code indent should use tabs where possible
#269: FILE: mm/page-writeback.c:2109:
+        .maxlen     = sizeof(vm_dirty_ratio),$

WARNING: please, no spaces at the start of a line
#269: FILE: mm/page-writeback.c:2109:
+        .maxlen     = sizeof(vm_dirty_ratio),$

ERROR: code indent should use tabs where possible
#270: FILE: mm/page-writeback.c:2110:
+        .mode       = 0644,$

WARNING: please, no spaces at the start of a line
#270: FILE: mm/page-writeback.c:2110:
+        .mode       = 0644,$

ERROR: code indent should use tabs where possible
#271: FILE: mm/page-writeback.c:2111:
+        .proc_handler   = dirty_ratio_handler,$

WARNING: please, no spaces at the start of a line
#271: FILE: mm/page-writeback.c:2111:
+        .proc_handler   = dirty_ratio_handler,$

ERROR: code indent should use tabs where possible
#272: FILE: mm/page-writeback.c:2112:
+        .extra1     = SYSCTL_ZERO,$

WARNING: please, no spaces at the start of a line
#272: FILE: mm/page-writeback.c:2112:
+        .extra1     = SYSCTL_ZERO,$

ERROR: code indent should use tabs where possible
#273: FILE: mm/page-writeback.c:2113:
+        .extra2     = SYSCTL_ONE_HUNDRED,$

WARNING: please, no spaces at the start of a line
#273: FILE: mm/page-writeback.c:2113:
+        .extra2     = SYSCTL_ONE_HUNDRED,$

WARNING: please, no spaces at the start of a line
#274: FILE: mm/page-writeback.c:2114:
+    },$

WARNING: please, no spaces at the start of a line
#275: FILE: mm/page-writeback.c:2115:
+    {$

ERROR: code indent should use tabs where possible
#276: FILE: mm/page-writeback.c:2116:
+        .procname   = "dirty_bytes",$

WARNING: please, no spaces at the start of a line
#276: FILE: mm/page-writeback.c:2116:
+        .procname   = "dirty_bytes",$

ERROR: code indent should use tabs where possible
#277: FILE: mm/page-writeback.c:2117:
+        .data       = &vm_dirty_bytes,$

WARNING: please, no spaces at the start of a line
#277: FILE: mm/page-writeback.c:2117:
+        .data       = &vm_dirty_bytes,$

ERROR: code indent should use tabs where possible
#278: FILE: mm/page-writeback.c:2118:
+        .maxlen     = sizeof(vm_dirty_bytes),$

WARNING: please, no spaces at the start of a line
#278: FILE: mm/page-writeback.c:2118:
+        .maxlen     = sizeof(vm_dirty_bytes),$

ERROR: code indent should use tabs where possible
#279: FILE: mm/page-writeback.c:2119:
+        .mode       = 0644,$

WARNING: please, no spaces at the start of a line
#279: FILE: mm/page-writeback.c:2119:
+        .mode       = 0644,$

ERROR: code indent should use tabs where possible
#280: FILE: mm/page-writeback.c:2120:
+        .proc_handler   = dirty_bytes_handler,$

WARNING: please, no spaces at the start of a line
#280: FILE: mm/page-writeback.c:2120:
+        .proc_handler   = dirty_bytes_handler,$

ERROR: code indent should use tabs where possible
#281: FILE: mm/page-writeback.c:2121:
+        .extra1     = (void *)&dirty_bytes_min,$

WARNING: please, no spaces at the start of a line
#281: FILE: mm/page-writeback.c:2121:
+        .extra1     = (void *)&dirty_bytes_min,$

WARNING: please, no spaces at the start of a line
#282: FILE: mm/page-writeback.c:2122:
+    },$

WARNING: please, no spaces at the start of a line
#283: FILE: mm/page-writeback.c:2123:
+    {$

ERROR: code indent should use tabs where possible
#284: FILE: mm/page-writeback.c:2124:
+        .procname   = "dirty_writeback_centisecs",$

WARNING: please, no spaces at the start of a line
#284: FILE: mm/page-writeback.c:2124:
+        .procname   = "dirty_writeback_centisecs",$

ERROR: code indent should use tabs where possible
#285: FILE: mm/page-writeback.c:2125:
+        .data       = &dirty_writeback_interval,$

WARNING: please, no spaces at the start of a line
#285: FILE: mm/page-writeback.c:2125:
+        .data       = &dirty_writeback_interval,$

ERROR: code indent should use tabs where possible
#286: FILE: mm/page-writeback.c:2126:
+        .maxlen     = sizeof(dirty_writeback_interval),$

WARNING: please, no spaces at the start of a line
#286: FILE: mm/page-writeback.c:2126:
+        .maxlen     = sizeof(dirty_writeback_interval),$

ERROR: code indent should use tabs where possible
#287: FILE: mm/page-writeback.c:2127:
+        .mode       = 0644,$

WARNING: please, no spaces at the start of a line
#287: FILE: mm/page-writeback.c:2127:
+        .mode       = 0644,$

ERROR: code indent should use tabs where possible
#288: FILE: mm/page-writeback.c:2128:
+        .proc_handler   = dirty_writeback_centisecs_handler,$

WARNING: please, no spaces at the start of a line
#288: FILE: mm/page-writeback.c:2128:
+        .proc_handler   = dirty_writeback_centisecs_handler,$

WARNING: please, no spaces at the start of a line
#289: FILE: mm/page-writeback.c:2129:
+    },$

WARNING: please, no spaces at the start of a line
#290: FILE: mm/page-writeback.c:2130:
+    {$

ERROR: code indent should use tabs where possible
#291: FILE: mm/page-writeback.c:2131:
+        .procname   = "dirty_expire_centisecs",$

WARNING: please, no spaces at the start of a line
#291: FILE: mm/page-writeback.c:2131:
+        .procname   = "dirty_expire_centisecs",$

ERROR: code indent should use tabs where possible
#292: FILE: mm/page-writeback.c:2132:
+        .data       = &dirty_expire_interval,$

WARNING: please, no spaces at the start of a line
#292: FILE: mm/page-writeback.c:2132:
+        .data       = &dirty_expire_interval,$

ERROR: code indent should use tabs where possible
#293: FILE: mm/page-writeback.c:2133:
+        .maxlen     = sizeof(dirty_expire_interval),$

WARNING: please, no spaces at the start of a line
#293: FILE: mm/page-writeback.c:2133:
+        .maxlen     = sizeof(dirty_expire_interval),$

ERROR: code indent should use tabs where possible
#294: FILE: mm/page-writeback.c:2134:
+        .mode       = 0644,$

WARNING: please, no spaces at the start of a line
#294: FILE: mm/page-writeback.c:2134:
+        .mode       = 0644,$

ERROR: code indent should use tabs where possible
#295: FILE: mm/page-writeback.c:2135:
+        .proc_handler   = proc_dointvec_minmax,$

WARNING: please, no spaces at the start of a line
#295: FILE: mm/page-writeback.c:2135:
+        .proc_handler   = proc_dointvec_minmax,$

ERROR: code indent should use tabs where possible
#296: FILE: mm/page-writeback.c:2136:
+        .extra1     = SYSCTL_ZERO,$

WARNING: please, no spaces at the start of a line
#296: FILE: mm/page-writeback.c:2136:
+        .extra1     = SYSCTL_ZERO,$

WARNING: please, no spaces at the start of a line
#297: FILE: mm/page-writeback.c:2137:
+    },$

total: 37 errors, 49 warnings, 287 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-move-page-writeback-sysctls-to-is-own-file.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: zhanglianjie <zhanglianjie@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   98 +++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

--- a/mm/page-writeback.c~mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes
+++ a/mm/page-writeback.c
@@ -2086,55 +2086,55 @@ static int page_writeback_cpu_online(uns
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table vm_page_writeback_sysctls[] = {
-    {
-        .procname   = "dirty_background_ratio",
-        .data       = &dirty_background_ratio,
-        .maxlen     = sizeof(dirty_background_ratio),
-        .mode       = 0644,
-        .proc_handler   = dirty_background_ratio_handler,
-        .extra1     = SYSCTL_ZERO,
-        .extra2     = SYSCTL_ONE_HUNDRED,
-    },
-    {
-        .procname   = "dirty_background_bytes",
-        .data       = &dirty_background_bytes,
-        .maxlen     = sizeof(dirty_background_bytes),
-        .mode       = 0644,
-        .proc_handler   = dirty_background_bytes_handler,
-        .extra1     = SYSCTL_LONG_ONE,
-    },
-    {
-        .procname   = "dirty_ratio",
-        .data       = &vm_dirty_ratio,
-        .maxlen     = sizeof(vm_dirty_ratio),
-        .mode       = 0644,
-        .proc_handler   = dirty_ratio_handler,
-        .extra1     = SYSCTL_ZERO,
-        .extra2     = SYSCTL_ONE_HUNDRED,
-    },
-    {
-        .procname   = "dirty_bytes",
-        .data       = &vm_dirty_bytes,
-        .maxlen     = sizeof(vm_dirty_bytes),
-        .mode       = 0644,
-        .proc_handler   = dirty_bytes_handler,
-        .extra1     = (void *)&dirty_bytes_min,
-    },
-    {
-        .procname   = "dirty_writeback_centisecs",
-        .data       = &dirty_writeback_interval,
-        .maxlen     = sizeof(dirty_writeback_interval),
-        .mode       = 0644,
-        .proc_handler   = dirty_writeback_centisecs_handler,
-    },
-    {
-        .procname   = "dirty_expire_centisecs",
-        .data       = &dirty_expire_interval,
-        .maxlen     = sizeof(dirty_expire_interval),
-        .mode       = 0644,
-        .proc_handler   = proc_dointvec_minmax,
-        .extra1     = SYSCTL_ZERO,
-    },
+	{
+		.procname   = "dirty_background_ratio",
+		.data       = &dirty_background_ratio,
+		.maxlen     = sizeof(dirty_background_ratio),
+		.mode       = 0644,
+		.proc_handler   = dirty_background_ratio_handler,
+		.extra1     = SYSCTL_ZERO,
+		.extra2     = SYSCTL_ONE_HUNDRED,
+	},
+	{
+		.procname   = "dirty_background_bytes",
+		.data       = &dirty_background_bytes,
+		.maxlen     = sizeof(dirty_background_bytes),
+		.mode       = 0644,
+		.proc_handler   = dirty_background_bytes_handler,
+		.extra1     = SYSCTL_LONG_ONE,
+	},
+	{
+		.procname   = "dirty_ratio",
+		.data       = &vm_dirty_ratio,
+		.maxlen     = sizeof(vm_dirty_ratio),
+		.mode       = 0644,
+		.proc_handler   = dirty_ratio_handler,
+		.extra1     = SYSCTL_ZERO,
+		.extra2     = SYSCTL_ONE_HUNDRED,
+	},
+	{
+		.procname   = "dirty_bytes",
+		.data       = &vm_dirty_bytes,
+		.maxlen     = sizeof(vm_dirty_bytes),
+		.mode       = 0644,
+		.proc_handler   = dirty_bytes_handler,
+		.extra1     = (void *)&dirty_bytes_min,
+	},
+	{
+		.procname   = "dirty_writeback_centisecs",
+		.data       = &dirty_writeback_interval,
+		.maxlen     = sizeof(dirty_writeback_interval),
+		.mode       = 0644,
+		.proc_handler   = dirty_writeback_centisecs_handler,
+	},
+	{
+		.procname   = "dirty_expire_centisecs",
+		.data       = &dirty_expire_interval,
+		.maxlen     = sizeof(dirty_expire_interval),
+		.mode       = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1     = SYSCTL_ZERO,
+	},
 #ifdef CONFIG_HIGHMEM
 	{
 		.procname	= "highmem_is_dirtyable",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-move-page-writeback-sysctls-to-is-own-file-checkpatch-fixes.patch
mm-move-page-writeback-sysctls-to-is-own-file-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
proc-alloc-path_max-bytes-for-proc-pid-fd-symlinks-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

