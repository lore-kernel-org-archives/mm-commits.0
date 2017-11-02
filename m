From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 2 Nov 2017 15:59:19 -0700
Message-ID: <20171102155919.7bbeec6289be8f4e3105ab5b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934407AbdKBW7V (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 18:59:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

7 fixes, based on 5cb0512c02ecd7e6214e912e4c150f4219ac78e0:

Subject: userfaultfd: hugetlbfs: prevent UFFDIO_COPY to fill beyond the end of i_size
Subject: mm, /proc/pid/pagemap: fix soft dirty marking for PMD migration entry
Subject: ocfs2: fstrim: Fix start offset of first cluster group during fstrim
Subject: fs/hugetlbfs/inode.c: fix hwpoison reserve accounting
Subject: initramfs: fix initramfs rebuilds w/ compression after disabling
Subject: mm/huge_memory.c: deposit page table when copying a PMD migration entry
Subject: mm, swap: fix race between swap count continuation operations



