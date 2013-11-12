From: akpm@linux-foundation.org
Subject: [folded-merged]
 smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch removed from -mm
 tree
Date: Tue, 12 Nov 2013 14:35:21 -0800
Message-ID: <5282ad29.MCnwPRgV6cxY7ind%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3KLWfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:35:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, gorcunov@openvz.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: [folded-merged] smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,gorcunov@openvz.org,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:35:21 -0800


The patch titled
     Subject: smaps-show-vm_softdirty-flag-in-vmflags-line-fix
has been removed from the -mm tree.  Its filename was
     smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch

This patch was dropped because it was folded into smaps-show-vm_softdirty-flag-in-vmflags-line.patch

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: smaps-show-vm_softdirty-flag-in-vmflags-line-fix

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/filesystems/proc.txt~smaps-show-vm_softdirty-flag-in-vmflags-line-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~smaps-show-vm_softdirty-flag-in-vmflags-line-fix
+++ a/Documentation/filesystems/proc.txt
@@ -460,6 +460,7 @@ manner. The codes are the following:
     nl  - non-linear mapping
     ar  - architecture specific flag
     dd  - do not include area into core dump
+    sd  - soft-dirty flag
     mm  - mixed map area
     hg  - huge page advise flag
     nh  - no-huge page advise flag
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-remove-obsolete-comments-about-page-table-lock.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
smaps-show-vm_softdirty-flag-in-vmflags-line.patch
page-typesc-support-kpf_softdirty-bit.patch
mm-ensure-get_unmapped_area-returns-higher-address-than-mmap_min_addr.patch

