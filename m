From: akpm@linux-foundation.org
Subject: + smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch added to -mm tree
Date: Tue, 08 Oct 2013 13:39:43 -0700
Message-ID: <52546d8f.io0GmgFDgbzw1isZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3JHUjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 16:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, gorcunov@openvz.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com

Subject: + smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,fengguang.wu@intel.com,gorcunov@openvz.org,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 13:39:43 -0700


The patch titled
     Subject: smaps-show-vm_softdirty-flag-in-vmflags-line-fix
has been added to the -mm tree.  Its filename is
     smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-correct-missing-private-flag-clearing.patch
mm-migration-do-not-lose-soft-dirty-bit-if-page-is-in-migration-state.patch
mm-proc-pid-pagemap-inspect-_page_soft_dirty-only-on-present-pages.patch
mm-remove-obsolete-comments-about-page-table-lock.patch
mm-memory-failurec-move-set_migratetype_isolate-outside-get_any_page.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
smaps-show-vm_softdirty-flag-in-vmflags-line.patch
smaps-show-vm_softdirty-flag-in-vmflags-line-fix.patch
page-typesc-support-kpf_softdirty-bit.patch

