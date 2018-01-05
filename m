From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 4 Jan 2018 16:17:32 -0800
Message-ID: <20180104161732.40ac5445619607f336b2adf3@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEARe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:17:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

9 fixes, based on e1915c8195b38393005be9b74bfa6a3a367c83b3:

Subject: mm: check pfn_valid first in zero_resv_unavail
Subject: kernel/acct.c: fix the acct->needcheck check in check_free_space()
Subject: mm/mprotect: add a cond_resched() inside change_pmd_range()
Subject: kernel/exit.c: export abort() to modules
Subject: mm/debug.c: provide useful debugging information for VM_BUG
Subject: mm/zsmalloc.c: include fs.h
Subject: mm/sparse.c: wrong allocation for mem_section
Subject: userfaultfd: clear the vma->vm_userfaultfd_ctx if UFFD_EVENT_FORK fails
Subject: mailmap: update Mark Yao's email address

