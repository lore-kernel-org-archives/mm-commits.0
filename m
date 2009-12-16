From: akpm@linux-foundation.org
Subject: [folded] mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch removed from -mm tree
Date: Tue, 15 Dec 2009 16:32:59 -0800
Message-ID: <200912160032.nBG0WxUC023624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761177AbZLPAdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 19:33:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agust@denx.de, krzysztof.h1@poczta.fm, valentin.sitdikov@siemens.com, virtuoso@slind.org, mm-commits@vger.kernel.org


The patch titled
     mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2
has been removed from the -mm tree.  Its filename was
     mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch

This patch was dropped because it was folded into mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Valentin Sitdikov <valentin.sitdikov@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2 drivers/video/mb862xx/mb862xxfb_accel.c
--- a/drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2
+++ a/drivers/video/mb862xx/mb862xxfb_accel.c
@@ -3,8 +3,8 @@
  *
  * Fujitsu Carmine/Coral-P(A)/Lime framebuffer driver acceleration support
  *
- * (C) 2007 Alexandr Shishkin <alexandr.shishkin@siemens.com>
- * (C) 2009 Valentin Sitdikov <valentin.sitdikovt@siemens.com>
+ * (C) 2007 Alexander Shishkin <virtuoso@slind.org>
+ * (C) 2009 Valentin Sitdikov <valentin.sitdikov@siemens.com>
  * (C) 2009 Siemens AG
  *
  * This program is free software; you can redistribute it and/or modify
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch

