From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 13 Apr 2017 14:56:07 -0700
Message-ID: <20170413145607.696cf05b7e63bf44d5229035@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbdDMV4I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

11 fixes, based on 2760078203a6b46b96307f4b06030ab0b801c97e:

Subject: z3fold: fix page locking in z3fold_alloc()
Subject: thp: reduce indentation level in change_huge_pmd()
Subject: thp: fix MADV_DONTNEED vs. numa balancing race
Subject: mm: drop unused pmdp_huge_get_and_clear_notify()
Subject: thp: fix MADV_DONTNEED vs. MADV_FREE race
Subject: thp: fix MADV_DONTNEED vs clear soft dirty race
Subject: hugetlbfs: fix offset overflow in hugetlbfs mmap
Subject: zram: fix operator precedence to get offset
Subject: zram: do not use copy_page with non-page aligned address
Subject: zsmalloc: expand class bit
Subject: mailmap: add Martin Kepplinger's email

The presence of "thp: reduce indentation level in change_huge_pmd()" is
unfortunate.  But the patchset had been decently reviewed and tested
before we decided it was needed in -stable and I felt it best not to
churn things at the last minute.

